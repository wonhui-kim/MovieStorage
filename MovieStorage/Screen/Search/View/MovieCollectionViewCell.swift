//
//  MovieCollectionViewCell.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/25.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setTitle("즐겨찾기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 12.5
        button.isHidden = true
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 5, leading: 10, bottom: 5, trailing: 10)
            configuration.baseBackgroundColor = .red
            configuration.cornerStyle = .capsule
            button.configuration = configuration
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookmarkButton.isHidden = true
    }
    
    private func configureUI() {
        [posterImageView, titleLabel, yearLabel, typeLabel].forEach { view in
            contentView.addSubview(view)
        }
        posterImageView.addSubview(bookmarkButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            posterImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 2/3)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            bookmarkButton.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 10),
            bookmarkButton.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
    
    func configure(with model: Movie) {

        APICaller.shared.downloadImage(url: model.poster) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.posterImageView.image = UIImage(named: "defaultImage")
                }
                print(error.localizedDescription)
            }
        }
        
        titleLabel.text = model.title
        yearLabel.text = model.year
        typeLabel.text = model.type
    }
    
}
