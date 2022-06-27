//
//  FactsVC.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 26.06.2022.
//

import Foundation
import UIKit

protocol FactsVCProtocol: AnyObject {
    func setup(title: String)
    func setup(vm: FactVM)
}

class FactsVC: UIViewController, FactsVCProtocol {
    
    var presenter: FactsPresenterProtocol!
    private let cardView = UIView()
    private let imgView = UIImageView()
    private let textView = UITextView()
    private let prevBtn = UIButton()
    private let nextBtn = UIButton()
    private let indicator = UIActivityIndicatorView(style: .medium)
    private var gestureBeganPoint: CGPoint = .zero
    private var loadImageTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupView()
        setupLayout()
        presenter.populateView()
    }
    
    //MARK: setup
    
    private func setupNav() {
        navigationController?.navigationBar.backgroundColor = .appBg
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 1
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationController?.navigationBar.layer.shadowRadius = 4
        let backButton = UIBarButtonItem(
            image: .navBackIcon,
            style: .plain,
            target: self,
            action: #selector(backAction)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        let shareButton = UIBarButtonItem(
            image: .navShareIcon,
            style: .plain,
            target: self,
            action: #selector(shareAction)
        )
        shareButton.tintColor = .black
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func setupView() {
        view.backgroundColor = .appBg
        
        indicator.color = .appBg
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        cardView.backgroundColor = .appCardBg
        cardView.corner(radius: 6)
        
        imgView.contentMode = .scaleAspectFit
        
        textView.isSelectable = false
        textView.isEditable = false
        textView.backgroundColor = .appCardBg
        textView.textColor = .appTextTitle
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.textAlignment = .center
        
        prevBtn.addTarget(self, action: #selector(prevDidTap), for: .touchUpInside)
        prevBtn.isEnabled = false
        prevBtn.setImage(.factsPrevBtn, for: .normal)
        
        nextBtn.addTarget(self, action: #selector(nextDidTap), for: .touchUpInside)
        nextBtn.isEnabled = false
        nextBtn.setImage(.factsNextBtn, for: .normal)
        

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        cardView.addSubview(imgView)
        cardView.addSubview(indicator)
        cardView.addSubview(textView)
        cardView.addSubview(prevBtn)
        cardView.addSubview(nextBtn)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        prevBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            imgView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            imgView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 22),
            imgView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),
            imgView.heightAnchor.constraint(equalToConstant: 240),

            indicator.centerXAnchor.constraint(equalTo: imgView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),

            textView.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 14),
            textView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 22),
            textView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            prevBtn.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 14),
            prevBtn.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 22),
            prevBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            prevBtn.widthAnchor.constraint(equalToConstant: 52),
            prevBtn.heightAnchor.constraint(equalToConstant: 52),

            nextBtn.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 14),
            nextBtn.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),
            nextBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            nextBtn.widthAnchor.constraint(equalToConstant: 52),
            nextBtn.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    //MARK: actions
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareAction() {
        presenter.share(image: imgView.image, text: textView.text)
    }
    
    @objc private func prevDidTap() {
        presenter.prevDidTap()
    }
    
    @objc private func nextDidTap() {
        presenter.nextDidTap()
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            presenter.nextDidTap()
        case .right:
            presenter.prevDidTap()
        default:
            break
        }
    }
    
    //MARK: protocol
    
    func setup(title: String) {
        self.title = title
    }
    
    func setup(vm: FactVM) {
        loadImageTask?.cancel()
        indicator.startAnimating()
        imgView.image = nil
        loadImageTask = ImageLoader().loadFrom(link: vm.imgURL) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imgView.image = image
                    self?.indicator.stopAnimating()
                }
            case .failure(let error):
                switch error {
                case .cancelled:
                    DispatchQueue.main.async {
                        self?.imgView.image = nil
                    }
                default:
                    DispatchQueue.main.async {
                        self?.imgView.image = .placeholder
                        self?.indicator.stopAnimating()
                    }
                }
            }
        }
        textView.text = vm.text
        prevBtn.isEnabled = !vm.isFirst
        nextBtn.isEnabled = !vm.isLast
        view.layoutIfNeeded()
    }
}
