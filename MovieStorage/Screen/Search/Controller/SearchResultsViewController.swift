//
//  SearchResultsViewController.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/23.
//

import UIKit

final class SearchResultsViewController: UIViewController {
    
    private var movies = [Movie]()
    private var query = ""
    private var currentPage = 1
    private var totalResults = 0
    private var totalPages = 0
    
    private let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2-10, height: 300)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
    
    private func configureUI() {
        view.addSubview(searchResultsCollectionView)
    }
    
    private func configureCollectionView() {
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    func configure(with query: String, page: Int) {
        APICaller.shared.search(with: query, page: page) { result in
            switch result {
            case .success(let movieResponse):
                self.query = query
                guard let totalResultsString = movieResponse.totalResults,
                      let totalResultsInt = Int(totalResultsString),
                      let movies = movieResponse.search else {
                    return
                }
                self.totalResults = totalResultsInt
                self.totalPages = self.totalResults / 10 + 1
                self.movies = movies
                
                DispatchQueue.main.async { [weak self] in
                    self?.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadNextPage(with query: String, page: Int) {
        APICaller.shared.search(with: query, page: page) { result in
            switch result {
            case .success(let movieResponse):
                guard let appendedMovie = movieResponse.search else {
                    return
                }
                self.movies.append(contentsOf: appendedMovie)
                DispatchQueue.main.async { [weak self] in
                    self?.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension SearchResultsViewController: UICollectionViewDelegate {
    
}

extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        
        return cell
    }
}
