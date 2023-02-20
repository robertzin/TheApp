//
//  DetailsViewController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 18.02.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailsViewController: UIViewController {
    
    private lazy var articleImageView: UIImageView = {
        let imageLabel = UIImageView()
        imageLabel.contentMode = .scaleAspectFill
        imageLabel.clipsToBounds = true
        imageLabel.layer.cornerRadius = 22
        imageLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 13)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var heartButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonFunction), for: .touchUpInside)
        return button
    }()
    
    var article: Article!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        navigationItem.title = article.title
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(dateLabel)
        view.addSubview(heartButton)
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        
        view.addSubview(activityIndicator)
        view.addSubview(imageStackView)
        imageStackView.addArrangedSubview(articleImageView)
        
        if let url = article.urlToImage { downloadImage(urlString: url) }
        self.dateLabel.text = article.publishedAt?.toFormattedDateString()
        self.titleLabel.text = article.title
        self.contentLabel.text = article.content
        setHeartLogo()
    }
    
    private func setupConstraints() {
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(260)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(imageStackView.snp.center)
            make.width.equalTo(140)
            make.height.equalTo(140)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(articleImageView.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left).inset(15)
            make.width.equalTo(72)
            make.height.equalTo(18)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel)
            make.right.equalTo(view.snp.right).inset(23)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(11)
            make.left.equalTo(view.snp.left).inset(15)
            make.right.equalTo(view.snp.right).inset(15)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(view.snp.left).inset(15)
            make.right.equalTo(view.snp.right).inset(15)
        }
    }
    
    private func setHeartLogo() {
        if article.liked == true {
            self.heartButton.setImage(UIImage(named: "heartColouredLogo")!, for: .normal)
        } else {
            self.heartButton.setImage(UIImage(named: "heartLogo"), for: .normal)
        }
    }
    
    @objc private func likeButtonFunction() {
        let articleToChange = CoreDataManager.shared.context.object(with: article.objectID) as! Article
        articleToChange.liked = !articleToChange.liked
        CoreDataManager.shared.saveContext()
        setHeartLogo()
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
            case .failure(_): break
            }
        }
    }
}
