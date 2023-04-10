//
//  CategiryTableViewCell.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/7/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let cellIdentifier = {
        return String(describing: CategoryTableViewCell.self)
    }
    
    private lazy var cellBackgroundView: UIView = .build { view in
        view.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(1)
        view.layer.cornerRadius = 20

        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }
    
    private lazy var categoryImageView: UIImageView = .build { image in
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
    }
    
    private lazy var categoryLabel: UILabel = .build { label in 
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.label
    }
    
    private lazy var descriptionLabel: UILabel = .build { label in 
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.secondaryLabel
    }
    
    private func setupLayout() {
        cellBackgroundView.addSubviews(categoryImageView, categoryLabel, descriptionLabel) 
        addSubview(cellBackgroundView)
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            categoryImageView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 8),
            categoryImageView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 8),
            categoryImageView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -8),
            categoryImageView.widthAnchor.constraint(equalTo: categoryImageView.heightAnchor, multiplier: 1.4),
            
            categoryLabel.topAnchor.constraint(equalTo: categoryImageView.topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 8),
            categoryLabel.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: categoryImageView.bottomAnchor)
            
        ])
    }
    
    func updateViews(with category: Category) {
        fetchImages(with: category)
        categoryLabel.text = category.name
        descriptionLabel.text = category.description
    }
    
    func fetchImages(with category: Category) {
    
        guard let imageUrl = URL(string: category.thumbnail) else { return }
        let cachedImage = ImageCache.shared.loadCachedImage(forKey: imageUrl)
        if cachedImage != nil {
            self.categoryImageView.image = cachedImage
        } else {
            self.categoryImageView.setImage(withURL: imageUrl)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        heightAnchor.constraint(equalToConstant: 150).isActive = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
