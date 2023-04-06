//
//  MealsCollectionViewCell.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import UIKit

private struct MealCollectionViewUX {
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

class MealsCollectionViewCell: UICollectionViewCell {
    
    var mealSearchResult: MealSearchResult? {
        didSet {
            updateViews()
        }
    }
    
    var meal: Meal?
    var idString: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = MealCollectionViewUX.generalCornerRadius
        contentView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = MealCollectionViewUX.generalCornerRadius
        layer.masksToBounds = false
        
        // Apply a shadow
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.12
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: MealCollectionViewUX.generalCornerRadius
        ).cgPath
    }
    
    let cellBackgroundView: UIView = .build { view in
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = MealCollectionViewUX.generalCornerRadius
        view.backgroundColor = .systemBackground
        view.layer.borderColor = UIColor.secondarySystemBackground.withAlphaComponent(0.15).cgColor
        view.layer.borderWidth = 1.0
    }
    
    lazy var mealImageView: UIImageView = .build { imageView in 
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        imageView.backgroundColor = .secondarySystemBackground
    }
    
    lazy var mealNameLabel: UILabel = .build { label in
        label.numberOfLines = 2
        label.textColor = .label
    }
    
    lazy var mealIngredientCountLabel: UILabel = .build { label in
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(14)
        label.minimumScaleFactor = 0.7
    }
    
    lazy var mealTypeLabel: UILabel = .build { label in
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(14)
        label.minimumScaleFactor = 0.7
    }
    
    override func prepareForReuse() {
        mealImageView.image = nil
        mealNameLabel.text = nil
        mealIngredientCountLabel.text = nil
        mealTypeLabel.text = nil
    }
    
    func setupLayout() {
        contentView.layer.cornerRadius = MealCollectionViewUX.generalCornerRadius
        contentView.layer.shadowRadius = MealCollectionViewUX.newsCellShadowRadius
        contentView.layer.shadowOffset = CGSize(width: 0, height: MealCollectionViewUX.newsCellShadowOffset)
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOpacity = 0.2
        
        let imageHeight = CGFloat(contentView.frame.height * 0.65)
        
        contentView.addSubviews(cellBackgroundView, mealNameLabel, mealImageView, mealIngredientCountLabel, mealTypeLabel)
        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            mealImageView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            
            mealNameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 4),
            mealNameLabel.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 8),
            mealNameLabel.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -8),
            
            mealTypeLabel.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 4),
            mealTypeLabel.leadingAnchor.constraint(equalTo: mealNameLabel.leadingAnchor),
            mealTypeLabel.trailingAnchor.constraint(equalTo: mealNameLabel.trailingAnchor),
            
            mealIngredientCountLabel.topAnchor.constraint(equalTo: mealTypeLabel.bottomAnchor, constant: 4),
            mealIngredientCountLabel.leadingAnchor.constraint(equalTo: mealNameLabel.leadingAnchor),
            mealIngredientCountLabel.trailingAnchor.constraint(equalTo: mealNameLabel.trailingAnchor),
        ])
    }
    
    func fetchIngredients() {
        guard let mealSearchResult = mealSearchResult else { return }
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealSearchResult.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        NetworkAgent().fetch(request) { (result: Result<MealResponse, ErrorHandler>) in
            switch result {
            case .success(let meal):
                DispatchQueue.main.async {
                    self.meal = meal.meals.first
                    self.mealTypeLabel.text = "Type: \(meal.meals[0].area)"
                    self.mealIngredientCountLabel.text = "Number of Ingredients: \(meal.meals[0].ingredients.count)"
                    self.updateViews()
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
        } 
    }
    
    func updateViews() {
        guard let mealSearchResult = mealSearchResult else { return }
        mealNameLabel.text = mealSearchResult.name
        if mealSearchResult.thumbnail != nil {
            let imageUrl = URL(string: mealSearchResult.thumbnail!)!

            ImageCache.shared.loadImage(from: imageUrl) { (image: UIImage?) in
                if let downloadedImage = image {
                    if let cachedImage = ImageCache.shared.loadCachedImage(forKey: imageUrl.absoluteString) {
                        if downloadedImage.isEqual(cachedImage) {
                            self.mealImageView.image = cachedImage
                        } else {
                            self.mealImageView.image = image
                        }
                    } else {
                        print("Image is not cached.")
                    }
                } else {
                    print("Failed to download image.")
                }
            }
        } else {
            mealImageView.image = UIImage(named: "defaultImage")
        }
    }
}

