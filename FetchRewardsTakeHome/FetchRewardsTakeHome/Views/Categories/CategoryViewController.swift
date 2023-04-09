//
//  CategoryViewController.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/7/23.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables
    
    var categories: [Category] = [] 
    
    // MARK: - UI Elements
    
    lazy private var tableView: UITableView = .build { tableView in
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureTableViewCell()
        fetchCategories()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Helper Funcs
    
    private func configureTableViewCell() {
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.cellIdentifier)
    }
    
    func fetchCategories() {
        let url = URL.categoryURL
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        NetworkAgent().fetch(request) { (result: Result<CategoryResults, NetworkError>) in
            switch result {
            case .success(let categories):
                self.categories = categories.categories.sorted(by: { $0.name < $1.name })
                DispatchQueue.main.async {
                    self.tableView.reloadData()    
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
            }
        } 
    }

} 

// MARK: - TableView Delegate and DataSource Extensions

extension CategoryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.cellIdentifier, for: indexPath) as? CategoryTableViewCell else{ return UITableViewCell() }
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
