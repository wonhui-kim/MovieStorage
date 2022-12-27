//
//  BookmarkViewController.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/26.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    private var bookmarks = [Movie]()
    
    private let bookmarkCollectionView: UICollectionView = {
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
        
        configureNavigationBar()
        configureUI()
        configureCollectionView()
        
        reloadCollectionView()
        subscribeBookmark()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bookmarkCollectionView.frame = view.bounds
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "내 즐겨찾기"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureUI() {
        view.addSubview(bookmarkCollectionView)
    }
    
    private func configureCollectionView() {
        bookmarkCollectionView.delegate = self
        bookmarkCollectionView.dataSource = self
    }

}

extension BookmarkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell else {
            return
        }
        
        let bookmark = bookmarks[indexPath.item]
        deleteBookmarkAction(bookmark: bookmark, cell: cell)
    }
}

extension BookmarkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let bookmark = bookmarks[indexPath.item]
        cell.configureBookmark(with: bookmark)
    
        return cell
    }
}

extension BookmarkViewController {
    private func subscribeBookmark() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: Notification.Name.bookmarkUpdated, object: nil)
    }
    
    @objc
    private func reloadCollectionView() {
        bookmarks = BookmarkManager.shared.fetchBookmark()
        DispatchQueue.main.async { [weak self] in
            self?.bookmarkCollectionView.reloadData()
        }
    }
}

extension BookmarkViewController {
    private func deleteBookmarkAction(bookmark: Movie, cell: MovieCollectionViewCell) {
        let defaultAction = UIAlertAction(title: "즐겨찾기 제거", style: .destructive) { (action) in
            
            BookmarkManager.shared.removeBookmark(movie: bookmark)
            
            NotificationCenter.default.post(name: Notification.Name.bookmarkUpdated, object: nil)
            NotificationCenter.default.post(name: Notification.Name.bookmarkRemoved, object: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let controller = UIAlertController(title: "즐겨찾기 제거", message: "즐겨찾기에서 제거하시겠습니까?", preferredStyle: .actionSheet)
        
        [defaultAction, cancelAction].forEach { action in
            controller.addAction(action)
        }
        
        present(controller, animated: true)
    }
}
