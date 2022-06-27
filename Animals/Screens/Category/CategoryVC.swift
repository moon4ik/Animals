//
//  CategoryVC.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

protocol CategoryVCProtocol: AnyObject {
    func update()
    func showLoading()
    func hideLoading()
}

class CategoryVC: UIViewController, CategoryVCProtocol {
    
    var presenter: CategoryPresenterProtocol!
    
    private let tableView = UITableView()
    private let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            self?.presenter.fetchCategories()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    //MARK: setup
    
    private func setupView() {
        view.backgroundColor = .appBg

        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryFreeCell.self,
                           forCellReuseIdentifier: CategoryFreeCell.className)
        tableView.register(CategoryPaidCell.self,
                           forCellReuseIdentifier: CategoryPaidCell.className)
        tableView.register(CategoryComingSoonCell.self,
                           forCellReuseIdentifier: CategoryComingSoonCell.className)
        
        indicator.style = .medium
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
    }
    
    private func setupLayout() {
        view.addSubview(indicator)
        view.addSubview(tableView)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: protocol
    
    func update() {
        tableView.reloadData()
    }
    
    func showLoading() {
        indicator.startAnimating()
        tableView.isHidden = true
    }
    
    func hideLoading() {
        indicator.stopAnimating()
        tableView.isHidden = false
    }
}

//MARK: - UITableView

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = presenter.numberOfRows()
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vm = presenter.getCellVM(for: indexPath) else { return UITableViewCell() }
        let cell: UITableViewCell
        switch vm.status {
        case .free:
            let freeCell = tableView.dequeueReusableCell(
                withIdentifier: CategoryFreeCell.className,
                for: indexPath) as! CategoryFreeCell
            freeCell.setup(vm)
            cell = freeCell
        case .paid:
            let paidCell = tableView.dequeueReusableCell(
                withIdentifier: CategoryPaidCell.className,
                for: indexPath) as! CategoryPaidCell
            paidCell.setup(vm)
            cell = paidCell
        case .comingSoon:
            let comingSoonCell = tableView.dequeueReusableCell(
                withIdentifier: CategoryComingSoonCell.className,
                for: indexPath) as! CategoryComingSoonCell
            comingSoonCell.setup(vm)
            cell = comingSoonCell
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = presenter.heightForRow(at: indexPath)
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
}
