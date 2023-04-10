//
//  CategoryViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/7/23.
//

import UIKit

class CategoryViewController: UIViewController {

    // MARK: - Variables
    let categoryTableView = CategoryTableView()
    let networkAgent = NetworkLayer()
    let viewModel = CategoryViewModel()
    var categories: [Category] = [] 
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewCell()
        fetchCategories()
        categoryTableView.tableView.delegate = self
        categoryTableView.tableView.dataSource = self
    }
    
    override func loadView() {
        view = categoryTableView
    }

    // MARK: - Helper Funcs
    
    private func configureTableViewCell() {
        categoryTableView.tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.cellIdentifier())
    }
    
    func fetchCategories() {
        viewModel.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                DispatchQueue.main.async {
                    self?.categoryTableView.tableView.reloadData()
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
        }
    }
} 

// MARK: - TableView Delegate and DataSource Extensions

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellIdentifier(), for: indexPath) as? CategoryTableViewCell else{ return UITableViewCell() }
        categoryCell.updateViews(with: categories[indexPath.row])
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        let viewController = MealsViewController(category: category)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
