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
        APICaller.shared.search(with: query, page: page) { [weak self] result in
            switch result {
            case .success(let movieResponse):
                self?.query = query
                guard let totalResultsString = movieResponse.totalResults,
                      let totalResultsInt = Int(totalResultsString),
                      let movies = movieResponse.search else {
                    return
                }
                self?.totalPages = totalResultsInt / 10 + 1
                self?.movies = movies
                
                DispatchQueue.main.async {
                    self?.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadNextPage(with query: String, page: Int) {
        APICaller.shared.search(with: query, page: page) { [weak self] result in
            switch result {
            case .success(let movieResponse):
                guard let appendedMovie = movieResponse.search,
                      let moviesCount = self?.movies.count
                else {
                    return
                }
                
                var indexPaths = [IndexPath]()
                for item in 0..<moviesCount {
                    let indexPath = IndexPath(item: item + appendedMovie.count - 1, section: 0)
                    indexPaths.append(indexPath)
                }
                
                self?.movies.append(contentsOf: appendedMovie)
                DispatchQueue.main.async {
                    self?.searchResultsCollectionView.insertItems(at: indexPaths)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == movies.count - 1, currentPage <= totalPages {
            currentPage += 1
            loadNextPage(with: query, page: currentPage)
        }
    }
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
