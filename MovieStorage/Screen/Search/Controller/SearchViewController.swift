//
//  SearchViewController.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/23.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.returnKeyType = .search
        return controller
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self

        configureNavigationItem()
        configureUI()
        setupLayout()
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
    }
    
    private func configureUI() {
        view.addSubview(noResultsLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let query = searchBar.text,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }

        resultsController.configure(with: query)
    }

}
