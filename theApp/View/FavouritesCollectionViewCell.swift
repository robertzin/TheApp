//
//  FavouritesCollectionViewCell.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class FavouritesCollectionViewCell: UICollectionViewCell {
    
    private lazy var articleImageView: UIImageView = {
        let imageLabel = UIImageView()
        imageLabel.contentMode = .scaleAspectFill
        imageLabel.clipsToBounds = true
        imageLabel.layer.cornerRadius = 22
        imageLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 13)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    lazy var heartButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonFunction), for: .touchUpInside)
        return button
    }()
    
    var liked: Bool?
    
    var cellButtonDelegate:  LikeButtonDelegate?
    
    var indexPath: IndexPath = IndexPath()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let imageStackView = UIStackView()
    
    private var loadingState: LoadingState = .notLoading {
        didSet {
            switch loadingState {
            case .notLoading:
                activityIndicator.stopAnimating()
            case .loading:
                activityIndicator.startAnimating()
            case .loaded:
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(articleImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(activityIndicator)
        contentView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(articleImageView)
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(contentView.frame.height / 2)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(articleImageView.snp.bottom).offset(11)
            make.left.equalTo(contentView.snp.left).inset(6)
            make.width.equalTo(72)
            make.height.equalTo(18)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel)
            make.right.equalTo(contentView.snp.right).inset(9)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).inset(8)
            make.right.equalTo(contentView.snp.right).inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadingState = .notLoading
    }
    
    func set(article: Article) {
        
        if let url = article.urlToImage {
            downloadImage(urlString: url)
        }
        self.dateLabel.text = article.publishedAt?.toFormattedDateString()
        self.titleLabel.text = article.title
        
        if article.liked == true {
            self.heartButton.setImage(UIImage(named: "heartColouredLogo")!, for: .normal)
        } else {
            self.heartButton.setImage(UIImage(named: "heartLogo"), for: .normal)
        }
    }
    
    @objc private func likeButtonFunction(_ sender: UIButton) {
        cellButtonDelegate?.likeButtonClicked(tag: sender.tag, indexPath: self.indexPath)
    }
    
    private func downloadImage(urlString: String) {
        loadingState = .loading
        let url = URL(string: urlString)
        articleImageView.kf.indicatorType = .activity
        articleImageView.kf.setImage(with: url)
        {
            result in
            switch result {
            case .success(_):
                self.loadingState = .loaded
            case .failure(let error):
                debugPrint("Image download failure: \(error.localizedDescription)")
            }
        }
    }
}


