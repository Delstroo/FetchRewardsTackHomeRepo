//
//  MealsViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/7/23.
//

import UIKit

class MealsViewController: UIViewController {
    
    // MARK: - Variables
    
    var category: Category
    var mealsCollectionView = MealsCollectionView()
    var mealSearchResults: [MealSearchResult] = []
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealsCollectionView.collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: MealCollectionViewCell.cellIdentifier())
        fetchMeals()
        mealsCollectionView.collectionView.delegate = self
        mealsCollectionView.collectionView.dataSource = self
    }
    
    override func loadView() {
        super.loadView()
        view = mealsCollectionView
    }
    
    // MARK: - Initializer
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Funcs
    func fetchMeals() {
        let viewModel = MealsViewModel(category: category)
        viewModel.fetchMeals(completion: { [weak self] result in
            switch result {
            case .success(let meals):
                self?.mealSearchResults = meals
                DispatchQueue.main.async {
                    self?.mealsCollectionView.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
        })
    }
}

// MARK: - CollectionView Delegate and DataSource Extensions
extension MealsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionViewCell.cellIdentifier(), for: indexPath) as? MealCollectionViewCell else { return UICollectionViewCell() }
        let mealSearchResult = mealSearchResults[indexPath.row]
        cell.setupLayout()
        cell.mealSearchResult = mealSearchResult
        cell.fetchIngredients()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealSearchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mealSearchResult = mealSearchResults[indexPath.row]
        let viewController = InstrucationViewController(mealSearchResult: mealSearchResult)
        navigationController?.present(viewController, animated: true)
    }
}

extension MealsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width * 0.45
        
        return CGSize(width: width, height: width * 1.20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let oneCellWidth = view.frame.width * 0.45
        
        let cellsTotalWidth = oneCellWidth * 2
        
        let leftOverWidth = view.frame.width - cellsTotalWidth
        
        let inset = leftOverWidth / 3
        
        return UIEdgeInsets(top: inset, left: inset, bottom: 4, right: inset)
    }
}
