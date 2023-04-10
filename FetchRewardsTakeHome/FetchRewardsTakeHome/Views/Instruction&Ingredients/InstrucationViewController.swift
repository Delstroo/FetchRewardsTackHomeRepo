//
//  InstrucationViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/7/23.
//

import UIKit

class InstrucationViewController: UIViewController {
    
    // MARK: - Variables
    
    private let contentView = InstructionView()
    let networkLayer = NetworkLayer()
    var meal: Meal?
    var mealSearchResult: MealSearchResult
    var strings: [String] = []
    
    override func loadView() {
        view = contentView
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllIngredients()
        contentView.mediaButton.addTarget(self, action: #selector(mediaButtonTapped), for: .touchUpInside)
        contentView.webButton.addTarget(self, action: #selector(webButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Initializer
    
    init(mealSearchResult: MealSearchResult) {
        self.mealSearchResult = mealSearchResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func fetchAllIngredients() {
        let viewModel = InstructionViewModel(mealSearchResult: self.mealSearchResult)
        viewModel.fetchAllIngredients(networkLayer: networkLayer) { result in
            switch result {
            case .success(let meal):
                DispatchQueue.main.async {
                    self.meal = meal
                    self.contentView.updateViews(with: meal)
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
        }
    }
    
    @objc func mediaButtonTapped() {
        guard let meal = meal else { return }
        UIApplication.shared.open(meal.mediaUrl!)
    }
    
    @objc func webButtonTapped() {
        guard let meal = meal else { return }
        UIApplication.shared.open(meal.sourceURL!)
    }
}
