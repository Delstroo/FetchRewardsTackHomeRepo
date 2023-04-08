//
//  InstrucationViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/7/23.
//

import UIKit

class InstrucationViewController: UIViewController {

    // MARK: - Variables
    
    var meal: Meal?
    var mealSearchResult: MealSearchResult
    var strings: [String] = []
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = .build { scrollView in
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
    }
    
    private lazy var contentView: UIView = .build { contentView in
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .systemBackground
    }
    
    private lazy var mealImageView: UIImageView = .build { imageView in 
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
    }
    
    private lazy var mealNameLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .label
    }
    
    private lazy var nameDividerView: UIView = .build { view in 
        view.backgroundColor = .label.withAlphaComponent(0.15)
    }
    
    private lazy var ingredientsHeaderLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Ingredients:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
    }
    
    private lazy var ingredientsLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
    }
    
    private lazy var instructionsHeaderLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Instructions:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
    }
    
    private lazy var instructionsLabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
    }
    
    private lazy var needSomeHelplabel: UILabel = .build { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Need some help? Try some of our sources!"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
    }
        
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupLayout()
        
        fetchAllIngredients()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = contentView.frame.size
        contentView.layoutIfNeeded()
    }
    
    // MARK: - Initializer
    
    init(mealSearchResult: MealSearchResult) {
        self.mealSearchResult = mealSearchResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    private func setupLayout() {
        var screenHeight: CGFloat {
            return UIScreen.main.bounds.width
        }
        let imageHeight = CGFloat(screenHeight * 0.46)
        scrollView.contentSize = contentView.bounds.size
        contentView.addSubviews(mealImageView, mealNameLabel, nameDividerView, ingredientsHeaderLabel, ingredientsLabel, instructionsHeaderLabel, instructionsLabel)
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -8),
            mealImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            mealImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            mealNameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 8),
            mealNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mealNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            
            nameDividerView.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 4),
            nameDividerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameDividerView.heightAnchor.constraint(equalToConstant: 3),
            nameDividerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            
            ingredientsHeaderLabel.topAnchor.constraint(equalTo: nameDividerView.bottomAnchor, constant: 12),
            ingredientsHeaderLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ingredientsHeaderLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            
            ingredientsLabel.topAnchor.constraint(equalTo: ingredientsHeaderLabel.bottomAnchor, constant: 8),
            ingredientsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ingredientsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            
            instructionsHeaderLabel.topAnchor.constraint(equalTo:ingredientsLabel.bottomAnchor, constant: 12),
            instructionsHeaderLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            instructionsHeaderLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            
            instructionsLabel.topAnchor.constraint(equalTo: instructionsHeaderLabel.bottomAnchor, constant: 8),
            instructionsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            instructionsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            instructionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Helper Functions
    
    func fetchAllIngredients() {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealSearchResult.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        NetworkAgent().fetch(request) { (result: Result<MealResponse, NetworkError>) in
            switch result {
            case .success(let meal):
                DispatchQueue.main.async {
                    self.meal = meal.meals[0]
                    self.updateViews()
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
        } 
    }
    
    func updateViews() {
        guard let meal = meal else { return }
        self.instructionsLabel.text = meal.instructions
        self.mealNameLabel.text = meal.name
        for ingredient in meal.ingredients {
            if ingredient.measurement != "" {
                strings.append("⊛ \(ingredient.name) - \(ingredient.measurement)")
            }
        }
        ingredientsLabel.text = strings.joined(separator: "\n")
        fetchImage()
    }
    
    func fetchImage() {
        guard let meal = meal,
              let thumbnail = meal.thumbnailURL else { return }
        let urlRequest = URLRequest(url: thumbnail)
        let cachedImage = ImageCache.shared.loadCachedImage(forKey: thumbnail)
        
        if cachedImage != nil {
            self.mealImageView.image = cachedImage
        } else {
            NetworkAgent().fetchImage(urlRequest) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.mealImageView.image = image
                    }
                    break
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }

}
