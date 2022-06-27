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
    func reloadData()
    func select(indexPath: IndexPath)
    func prevBtn(isEnabled: Bool)
    func nextBtn(isEnabled: Bool)
}

class FactsVC: UIViewController, FactsVCProtocol {
    
    var presenter: FactsPresenterProtocol!
    private let cardView = UIView()
    private var collectionView: UICollectionView!
    private let prevBtn = UIButton()
    private let nextBtn = UIButton()
    
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
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.bounds.width - (16*4), height: 400)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FactCell.self, forCellWithReuseIdentifier: FactCell.className)
        
        cardView.backgroundColor = .appCardBg
        cardView.corner(radius: 6)
        
        prevBtn.addTarget(self, action: #selector(prevDidTap), for: .touchUpInside)
        prevBtn.isEnabled = false
        prevBtn.setImage(.factsPrevBtn, for: .normal)
        
        nextBtn.addTarget(self, action: #selector(nextDidTap), for: .touchUpInside)
        nextBtn.isEnabled = false
        nextBtn.setImage(.factsNextBtn, for: .normal)
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
        cardView.addSubview(collectionView)
        cardView.addSubview(prevBtn)
        cardView.addSubview(nextBtn)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        prevBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 400),
            
            prevBtn.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            prevBtn.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            prevBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            prevBtn.widthAnchor.constraint(equalToConstant: 52),
            prevBtn.heightAnchor.constraint(equalToConstant: 52),

            nextBtn.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            nextBtn.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            nextBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            nextBtn.widthAnchor.constraint(equalToConstant: 52),
            nextBtn.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    //MARK: actions
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareAction() {
        guard let cell = collectionView.visibleCells.first as? FactCell else {
            presenter.share(image: nil, text: nil)
            return
        }
        let data = cell.getData()
        presenter.share(image: data.image, text: data.text)
    }
    
    @objc private func prevDidTap() {
        presenter.prevDidTap()
    }
    
    @objc private func nextDidTap() {
        presenter.nextDidTap()
    }
    
    //MARK: protocol
    
    func select(indexPath: IndexPath) {
        self.collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    func prevBtn(isEnabled: Bool) {
        prevBtn.isEnabled = isEnabled
    }
    
    func nextBtn(isEnabled: Bool) {
        nextBtn.isEnabled = isEnabled
    }
    
    func setup(title: String) {
        self.title = title
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension FactsVC: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = presenter.numberOfItems()
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FactCell.className, for: indexPath) as! FactCell
        let vm = presenter.viewModel(for: indexPath)
        cell.setup(vm: vm)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            presenter.select(indexPath: indexPath)
        }
    }
}
