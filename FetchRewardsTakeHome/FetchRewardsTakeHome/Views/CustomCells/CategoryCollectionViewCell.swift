//
//  CategoryCollectionViewCell.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import UIKit

private struct CategoryCellUX {
    static let generalCornerRadius: CGFloat = 12
    static let titleMaxFontSize: CGFloat = 12
    static let newsDescriptionMaxFontSize: CGFloat = 16
    static let generalSpacing: CGFloat = 8
    static let newsCellShadowRadius: CGFloat = 4
    static let newsCellShadowOffset: CGFloat = 2
    static let topInset: CGFloat = 5.0
    static let bottomInset: CGFloat = 5.0
    static let leftInset: CGFloat = 7.0
    static let rightInset: CGFloat = 7.0

}

class CategoryCell: UICollectionViewCell {
    
    var category: Category? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
          super.awakeFromNib()
              
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = CategoryCellUX.generalCornerRadius
        contentView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = CategoryCellUX.generalCornerRadius
        layer.masksToBounds = false
          
          // Apply a shadow
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.07
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
      }
      
      override func layoutSubviews() {
          super.layoutSubviews()
          
          layer.shadowPath = UIBezierPath(
              roundedRect: bounds,
              cornerRadius: CategoryCellUX.generalCornerRadius
          ).cgPath
      }
    
    let cellBackgroundView: UIView = .build { view in
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CategoryCellUX.generalCornerRadius
        view.backgroundColor = .systemBackground
    }
    
    lazy var categoryImageView: UIImageView = .build { imageView in 
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = CategoryCellUX.generalCornerRadius
        imageView.backgroundColor = .clear
        imageView.backgroundColor = .secondarySystemBackground
    }
    
    lazy var categoryTitle: UILabel = .build { label in
        label.numberOfLines = 1
        label.textColor = .label
        label.font = UIFont(name: "HelveticaNeue-SemiBold", size: 30.0)
    }
    
    lazy var categoryDescription: UILabel = .build { label in
        label.numberOfLines = 4
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(14)
        label.minimumScaleFactor = 0.7
    }
    
    override func prepareForReuse() {
        categoryImageView.image = nil
        categoryTitle.text = nil
        categoryDescription.text = nil
    }
    
    func setupLayout() {
        contentView.layer.cornerRadius = CategoryCellUX.generalCornerRadius
        contentView.layer.shadowRadius = CategoryCellUX.newsCellShadowRadius
        contentView.layer.shadowOffset = CGSize(width: 0, height: CategoryCellUX.newsCellShadowOffset)
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOpacity = 0.2
        let imageWidth = CGFloat(contentView.frame.height * 1.40)
        
        contentView.addSubviews(cellBackgroundView, categoryTitle, categoryImageView, categoryDescription)
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryImageView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 8),
            categoryImageView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 8),
            categoryImageView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -8),
            categoryImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            
            categoryTitle.topAnchor.constraint(equalTo: categoryImageView.topAnchor),
            categoryTitle.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 8),
            categoryTitle.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -8),
            categoryTitle.heightAnchor.constraint(equalToConstant: 20),
            
            categoryDescription.topAnchor.constraint(equalTo: categoryTitle.bottomAnchor, constant: -10),
            categoryDescription.leadingAnchor.constraint(equalTo: categoryTitle.leadingAnchor),
            categoryDescription.trailingAnchor.constraint(equalTo: categoryTitle.trailingAnchor),
            categoryDescription.bottomAnchor.constraint(equalTo: categoryImageView.bottomAnchor)
        ])
    }
    
    func updateViews() {
        guard let category = category else { return }
        categoryTitle.text = category.name
        categoryDescription.text = category.description
                
        // Load image from URL
        let imageUrl = URL(string: category.thumbnail)!
        // Create an instance of ImageCache or use the shared singleton instance
        let imageCache = ImageCache.shared

        // Check if the image is already cached
        ImageCache.shared.loadImage(from: imageUrl) { (image: UIImage?) in
            if let downloadedImage = image {
                if let cachedImage = ImageCache.shared.loadCachedImage(forKey: imageUrl.absoluteString) {
                    if downloadedImage.isEqual(cachedImage) {
                        self.categoryImageView.image = cachedImage
                    } else {
                        self.categoryImageView.image = image
                    }
                } else {
                    print("Image is not cached.")
                }
            } else {
                print("Failed to download image.")
            }
        }
    }
}
