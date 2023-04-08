//
//  MealInstructionViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import UIKit

class MealInstructionsViewController: UIViewController {

    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var ingredientsHeaderLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsHeaderLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var sourceLinkButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var ingredientStackView: UIStackView!
    @IBOutlet weak var isntructionsStackView: UIStackView!
    @IBOutlet weak var helpStackview: UIStackView!
    @IBOutlet weak var spacerView: UIView!
    
    var meal: Meal?
    var mealSearchResult: MealSearchResult?
    var strings: [String] = []
    private var spinnerView: SpinnerView?
    var isLoading: Bool = false {
        didSet{
            DispatchQueue.main.async {
                self.spinnerView?.isHidden = !self.isLoading
                self.isLoading ? self.showSpinner() : self.hideSpinner()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.mealNameLabel.text = ""
            self.ingredientsHeaderLabel.text = ""
            self.ingredientsLabel.text = ""
            self.instructionsHeaderLabel.text = ""
            self.instructionsLabel.text = ""
            self.helpLabel.text = ""
            self.mealNameLabel.alpha = 0.0
            self.ingredientsHeaderLabel.alpha = 0.0
            self.ingredientsLabel.alpha = 0.0
            self.instructionsHeaderLabel.alpha = 0.0
            self.instructionsLabel.alpha = 0.0
            self.helpLabel.alpha = 0.0
            self.youtubeButton.alpha = 0.0
            self.sourceLinkButton.alpha = 0.0
           }, completion: {
               finished in
               self.updateViews()
               if finished {
                   self.helpLabel.text = "Need some help? Try some of our sources!"
                   //Once the label is completely invisible, set the text and fade it back in
                   // Fade in
                   UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
                       self.mealNameLabel.alpha = 1.0
                       self.ingredientsHeaderLabel.alpha = 1.0
                       self.ingredientsLabel.alpha = 1.0
                       self.instructionsHeaderLabel.alpha = 1.0
                       self.instructionsLabel.alpha = 1.0
                       self.helpLabel.alpha = 1.0
                       self.youtubeButton.alpha = 1.0
                       self.sourceLinkButton.alpha = 1.0
                   }, completion: nil)
               }
       })
        fetchAllIngredients()
        // Do any additional setup after loading the view.
    }
    @IBAction func mediaButtonPressed(_ sender: Any) {
        guard let meal = meal else { return }
        UIApplication.shared.open(meal.youtubeURL!)
    }
    @IBAction func webButtonPressed(_ sender: Any) {
        guard let meal = meal else { return }
        UIApplication.shared.open(meal.sourceURL!)
    }
    
    func fetchAllIngredients() {
        guard let mealSearchResult = mealSearchResult else { return }
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
    
    func showSpinner() {
        var spinnerView = spinnerView
        spinnerView = SpinnerView(frame: CGRect(x: self.view.center.x - 35, y: self.view.center.y, width: 75, height: 74))
        self.view.addSubview(spinnerView!)
    }
    
    func hideSpinner() {
        spinnerView?.removeFromSuperview()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func setupView() {
        ingredientStackView.isLayoutMarginsRelativeArrangement = true
        isntructionsStackView.isLayoutMarginsRelativeArrangement = true
        ingredientStackView.translatesAutoresizingMaskIntoConstraints = false
        isntructionsStackView.translatesAutoresizingMaskIntoConstraints = false
        ingredientStackView.spacing = UIStackView.spacingUseSystem
        isntructionsStackView.spacing = UIStackView.spacingUseSystem
        
        ingredientStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        ingredientStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        isntructionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        isntructionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        helpStackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        helpStackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        mealImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mealImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mealImageView.layer.cornerRadius = 15
        spacerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        spacerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }

    func updateViews() {
        guard let meal = meal else { return }
        fetchImage()
        instructionsLabel.lineBreakMode = .byWordWrapping
        youtubeButton.setImage(UIImage(named: "playButton"), for: .normal)
        sourceLinkButton.setImage(UIImage(named: "webButton"), for: .normal)
        for ingredient in meal.ingredients {
            if ingredient.measurement != "" {
                strings.append("⊛ \(ingredient.name) - \(ingredient.measurement)")
            }
        }
        mealImageView.clipsToBounds = true
        spacerView.backgroundColor = UIColor.label.withAlphaComponent(0.15)
        spacerView.layer.cornerRadius = 1.5
        ingredientsLabel.text = strings.joined(separator: "\n")
        instructionsLabel.text = meal.instructions
        mealNameLabel.text = meal.name
        if meal.sourceURL == nil || meal.sourceURL == URL(string: "") {
            sourceLinkButton.isHidden = true
        }
        if meal.youtubeURL == nil || meal.youtubeURL == URL(string: "") {
            youtubeButton.isHidden = true
        }       
        
        if youtubeButton.isHidden && sourceLinkButton.isHidden {
            helpLabel.isHidden = true
        }
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
