//
//  CategoryFreeCell.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 25.06.2022.
//

import Foundation
import UIKit

class CategoryFreeCell: UITableViewCell {
    
    let cardView = UIView()
    let imgView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    //MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(cardView)
        cardView.addSubview(imgView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        
        cardView.backgroundColor = .appCardBg
        cardView.layer.cornerRadius = 6
        cardView.layer.masksToBounds = true
        
        imgView.contentMode = .scaleAspectFit
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .appTextTitle
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .appTextSubtitle
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
        
    private func setupLayout() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            imgView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 5),
            imgView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            imgView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -5),
            imgView.widthAnchor.constraint(equalToConstant: 120),
            imgView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10)
        ])
    }
    
    //MARK: public
    
    public func setup(_ vm: CategoryCellVM) {
        imgView.loadFrom(link: vm.imageURL)
        titleLabel.text = vm.title
        subtitleLabel.text = vm.subtitle
    }
}
