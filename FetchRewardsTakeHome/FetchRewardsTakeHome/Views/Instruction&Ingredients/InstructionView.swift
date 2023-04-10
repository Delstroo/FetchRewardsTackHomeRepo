//
//  InstructionView.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/9/23.
//

import UIKit

class InstructionView: UIView {
    
    lazy var scrollView: UIScrollView = .build { scrollView in
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
    }
    
    lazy var containerView: UIView = .build { contentView in
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .systemBackground
    }
    
    lazy var mealImageView: UIImageView = .build { imageView in
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
    }
    
    lazy var mealNameLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .label
    }
    
    lazy var nameDividerView: UIView = .build { view in
        view.backgroundColor = .label.withAlphaComponent(0.15)
        view.alpha = 0.0
    }
    
    lazy var ingredientsHeaderLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Ingredients:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.alpha = 0.0
    }
    
    lazy var ingredientsLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
    }
    
    lazy var instructionsHeaderLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Instructions:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.alpha = 0.0
    }
    
    lazy var instructionsLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
    }
    
    lazy var needSomeHelplabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Need some help? Try some of our sources!"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.textAlignment = .center
        label.alpha = 0.0
    }
    
    lazy var mediaButton: UIButton = .build { button in
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "playButton"), for: .normal)
    }
    
    lazy var webButton: UIButton = .build { button in
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "webButton"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    private func setupLayout() {
        var screenHeight: CGFloat {
            return UIScreen.main.bounds.width
        }
        let imageHeight = CGFloat(screenHeight * 0.46)
        scrollView.contentSize = containerView.bounds.size
        containerView.addSubviews(mealImageView, mealNameLabel, nameDividerView, ingredientsHeaderLabel, ingredientsLabel, instructionsHeaderLabel, instructionsLabel, needSomeHelplabel, mediaButton, webButton)
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: -8),
            mealImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            mealImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            mealNameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 8),
            mealNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            mealNameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20),
            
            nameDividerView.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 4),
            nameDividerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nameDividerView.heightAnchor.constraint(equalToConstant: 3),
            nameDividerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20),
            
            ingredientsHeaderLabel.topAnchor.constraint(equalTo: nameDividerView.bottomAnchor, constant: 40),
            ingredientsHeaderLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            ingredientsHeaderLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20),
            
            ingredientsLabel.topAnchor.constraint(equalTo: ingredientsHeaderLabel.bottomAnchor, constant: 8),
            ingredientsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            ingredientsLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20),
            
            instructionsHeaderLabel.topAnchor.constraint(equalTo:ingredientsLabel.bottomAnchor, constant: 40),
            instructionsHeaderLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            instructionsHeaderLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20),
            
            instructionsLabel.topAnchor.constraint(equalTo: instructionsHeaderLabel.bottomAnchor, constant: 8),
            instructionsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            instructionsLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20),
        ])
    }
    
    func updateViews(with meal: Meal?) {
        guard let meal = meal else { return }
        var strings = [String]()
        self.instructionsLabel.text = meal.instructions
        self.mealNameLabel.text = meal.name
        for ingredient in meal.ingredients {
            if ingredient.measurement != "" {
                strings.append("⊛ \(ingredient.name) - \(ingredient.measurement)")
            }
        }
        ingredientsLabel.text = strings.joined(separator: "\n")
        shouldShowButtons(meal: meal)
        fetchMealImage(meal: meal)
        showLabels()
    }
    
    func showLabels() {
        self.nameDividerView.alpha = 1.0
        self.ingredientsHeaderLabel.alpha = 1.0
        self.instructionsHeaderLabel.alpha = 1.0
        self.needSomeHelplabel.alpha = 1.0
    }
    
    func shouldShowButtons(meal: Meal) {
        if meal.mediaUrl == nil || meal.mediaUrl == URL(string: "") {
            mediaButton.isHidden = true
        }
        
        if meal.sourceURL == nil || meal.sourceURL == URL(string: "") {
            webButton.isHidden = true
        }
        
        if webButton.isHidden && mediaButton.isHidden {
            needSomeHelplabel.isHidden = true
            instructionsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        } else {
            needSomeHelplabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 40).isActive = true
            needSomeHelplabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            needSomeHelplabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20).isActive = true
            
            mediaButton.topAnchor.constraint(equalTo: needSomeHelplabel.bottomAnchor, constant: 12).isActive = true
            mediaButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50).isActive = true
            mediaButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            mediaButton.heightAnchor.constraint(equalTo: mediaButton.widthAnchor).isActive = true
            mediaButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
            
            webButton.topAnchor.constraint(equalTo: needSomeHelplabel.bottomAnchor, constant: 12).isActive = true
            webButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50).isActive = true
            webButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            webButton.heightAnchor.constraint(equalTo: mediaButton.widthAnchor).isActive = true
            webButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        }
    }
    
    func fetchMealImage(meal: Meal) {
        guard let url = meal.thumbnailURL else { return }
            self.mealImageView.downloadAndSetImage(from: url.absoluteString)
        }
}
