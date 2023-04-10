//
//  CategoryView.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/9/23.
//

import UIKit

class CategoryTableView: UIView {
    // MARK: - UI Elements
    
    lazy var tableView: UITableView = .build { tableView in
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
