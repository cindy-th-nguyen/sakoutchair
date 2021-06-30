//
//  CarouselCell.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 29/06/2021.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    private lazy var imageView = UIImageView()
    private lazy var textLabel = UILabel()
    
    static let cellId = "CarouselCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

private extension CarouselCell {
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 18)
        textLabel.textColor = .white
    }
}

extension CarouselCell {
    public func configure(image: UIImage?, text: String) {
        imageView.image = image
        textLabel.text = text
    }
}
