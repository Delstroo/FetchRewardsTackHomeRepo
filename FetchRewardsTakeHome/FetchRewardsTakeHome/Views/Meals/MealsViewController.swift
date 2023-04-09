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
    var mealSearchResults: [MealSearchResult] = []
    
    let layout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.layer.cornerRadius = 20
        return collectionView
    }()
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: "MealCollectionCell")
        setupCollectionView()
        fetchMeals()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Initializer
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    // MARK: - Helper Funcs
    func fetchMeals() {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=\(category.name)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        NetworkAgent().fetch(request) { (result: Result<MealSearchResponse, NetworkError>) in
            switch result {
            case .success(let mealResponse):
                self.mealSearchResults = mealResponse.meals.sorted(by: { $0.name < $1.name })
                DispatchQueue.main.async {
                    self.collectionView.reloadData()    
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
        } 
    }
}

// MARK: - CollectionView Delegate and DataSource Extensions
extension MealsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionCell", for: indexPath) as? MealCollectionViewCell else { return UICollectionViewCell() }
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
