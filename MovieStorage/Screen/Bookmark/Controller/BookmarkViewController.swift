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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bookmarkCollectionView.frame = view.bounds
    }
    
    private func configureNavigationBar() {
        title = "내 즐겨찾기"
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
