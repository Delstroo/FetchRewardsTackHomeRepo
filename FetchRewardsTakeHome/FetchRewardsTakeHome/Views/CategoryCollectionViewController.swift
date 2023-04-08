//
//  CategoryCollectionViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import UIKit

private let reuseIdentifier = "CategoryCell"

struct CategoryCollectionViewUX {
    static let cellWidth: CGFloat = 225
    static let cellHeight: CGFloat = 230
    static let generalSpacing: CGFloat = 16
    static let iPadGeneralSpacing: CGFloat = 20
}

class CategoryCollectionViewController: UICollectionViewController {
    
    var categories: [Category] = []
    var category: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Helper Func
    
    
    func fetchCategories() {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        NetworkAgent().fetch(request) { (result: Result<CategoryResults, NetworkError>) in
            switch result {
            case .success(let categories):
                self.categories = categories.categories.sorted(by: { $0.name < $1.name })

                DispatchQueue.main.async {
                    self.collectionView.reloadData()    
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
        } 
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMealCollectionView" {
            guard let cell = sender as? CategoryCell,
                  let indexPath = collectionView.indexPath(for: cell),
                  let destination = segue.destination as? MealsCollectionViewController else { return }
            let selectedCategory = categories[indexPath.row]
            destination.category = selectedCategory
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        
        let category = categories[indexPath.row]
        cell.setupLayout()
        cell.category = category
    
        return cell
    }
}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = view.frame.width

        return CGSize(width: width, height: width / 3.4)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
    }
}
