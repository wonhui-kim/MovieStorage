//
//  SearchResultsViewController.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/23.
//

import UIKit

final class SearchResultsViewController: UIViewController {
    
    private var movies = [Movie]()
    
    private let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2-10, height: 300)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    func configure(with query: String) {
        APICaller.shared.search(with: query) { result in
            switch result {
            case .success(let movieResponse):
                self.movies = movieResponse.search ?? []
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
