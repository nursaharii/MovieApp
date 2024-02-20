//
//  MovieDetailCell.swift
//  MovieApp
//
//  Created by Nurşah Ari on 19.02.2024.
//

import UIKit

class MovieDetailCell: UICollectionViewCell {
    private lazy var infoLabel = PaddingLabel()
    
    static let identifier = String(describing: MovieDetailCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLabel(_ info: String) {
        infoLabel.text = info
    }
    
    func prepareUI() {
        infoLabel.font = .boldSystemFont(ofSize: 16)
        infoLabel.textColor = .label
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.cornerRadius = 10
        infoLabel.addShadow(opacity: 0.5)
        infoLabel.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
        ])
    }
}
