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
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: 300)
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
                
                let indexPaths = Array(0..<appendedMovie.count).map {
                    IndexPath(item: $0 + moviesCount - 1, section: 0)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell else {
            return
        }
        
        let movie = movies[indexPath.item]
        let bookmark = movie
        
        if !BookmarkManager.shared.containsBookmark(movie: bookmark) {
            insertBookmarkAction(bookmark: bookmark, cell: cell)
        } else {
            deleteBookmarkAction(bookmark: bookmark, cell: cell)
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
        cell.configureSearchResults(with: movie)
        
        return cell
    }
}

// MARK: 즐겨찾기 actionSheet 관련 함수
extension SearchResultsViewController {
    
    ///즐겨찾기에 추가되지 않은 셀 클릭 시 "즐겨찾기" 선택창(actionSheet)이 뜨도록 호출되는 함수
    private func insertBookmarkAction(bookmark: Movie, cell: MovieCollectionViewCell) {
        let defaultAction = UIAlertAction(title: "즐겨찾기", style: .default) { [weak self] (action) in
            
            BookmarkManager.shared.insertBookmark(movie: bookmark)
            
            NotificationCenter.default.post(name: Notification.Name.bookmarkUpdated, object: nil)
            
            if BookmarkManager.shared.containsBookmark(movie: bookmark) {
                self?.showBookmarkButton(cell: cell)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let controller = UIAlertController(title: "즐겨찾기 추가", message: "즐겨찾기에 추가하시겠습니까?", preferredStyle: .actionSheet)
        
        [defaultAction, cancelAction].forEach { action in
            controller.addAction(action)
        }
        
        present(controller, animated: true)
    }
    
    ///즐겨찾기에 이미 추가된 셀 클릭 시 "즐겨찾기 제거" 선택창(actionSheet)이 뜨도록 호출되는 함수
    private func deleteBookmarkAction(bookmark: Movie, cell: MovieCollectionViewCell) {
        let defaultAction = UIAlertAction(title: "즐겨찾기 제거", style: .destructive) { [weak self] (action) in
            
            BookmarkManager.shared.removeBookmark(movie: bookmark)
            
            NotificationCenter.default.post(name: Notification.Name.bookmarkUpdated, object: nil)
            
            if !BookmarkManager.shared.containsBookmark(movie: bookmark) {
                self?.hideBookmarkButton(cell: cell)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let controller = UIAlertController(title: "즐겨찾기 제거", message: "즐겨찾기에서 제거하시겠습니까?", preferredStyle: .actionSheet)
        
        [defaultAction, cancelAction].forEach { action in
            controller.addAction(action)
        }
        
        present(controller, animated: true)
    }
    
    ///선택된 셀의 버튼을 보이게 하는 함수 - 즐겨찾기에 추가된 영화임을 알 수 있게 하는 기능
    private func showBookmarkButton(cell: MovieCollectionViewCell) {
        cell.bookmarkButton.isHidden = false
    }
    
    ///선택된 셀의 버튼을 보이지 않게 하는 함수
    private func hideBookmarkButton(cell: MovieCollectionViewCell) {
        cell.bookmarkButton.isHidden = true
    }
}

extension Notification.Name {
    static let bookmarkUpdated = Notification.Name(rawValue: "bookmarkUpdated")
}
