//
//  FactCell.swift
//  Animals
//
//  Created by Oleksii Mykhailenko on 27.06.2022.
//

import Foundation
import UIKit

struct FactCellVM {
    let imgLink: String
    let text: String
}

class FactCell: UICollectionViewCell {
    
    private let imgView = UIImageView()
    private let textView = UITextView()
    
    //MARK: init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        textView.text = nil
    }
    
    //MARK: setup
    
    private func setupView() {
        imgView.contentMode = .scaleAspectFit
        
        textView.isPagingEnabled = true
        textView.isEditable = false
        textView.backgroundColor = .appCardBg
        textView.textColor = .appTextTitle
        textView.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    private func setupLayout() {
        contentView.addSubview(imgView)
        contentView.addSubview(textView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imgView.heightAnchor.constraint(equalToConstant: 250),
            
            textView.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            textView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 0)
        ])
    }
    
    //MARK: public
    
    func setup(vm: FactCellVM) {
        imgView.loadFrom(link: vm.imgLink)
        textView.text = vm.text
    }
    
    func getData() -> (image: UIImage?, text: String?) {
        return (imgView.image, textView.text)
    }
}
