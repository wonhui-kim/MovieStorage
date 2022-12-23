//
//  SearchViewController.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.returnKeyType = .search
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
    }
}
