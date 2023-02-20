//
//  NewsViewController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit
import CoreData

final class NewsViewController: UIViewController {
    
    let cellId = "cellId"
    
    private var activityIndicator = UIActivityIndicatorView()
    
    var presenter: NewsPresenterProtocol!
    
    var viewControllerType: Constants.NewsVCType!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 18
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Constants.Colors.backgroundColor
        
        if self.viewControllerType == .feed {
            collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        } else {
            collectionView.register(FavouritesCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefreshControl),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! presenter.fetchResultController.performFetch()
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.getArticles(url: Constants.getNewsURL)
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor

        navigationItem.title = self.viewControllerType == .feed ? "Новости" : "Избранное"
        navigationController?.navigationBar.tintColor = Constants.Colors.buttonColor
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        collectionView.addSubview(refreshControl)
        
        activityIndicator.startAnimating()
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(140)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height)
        }
    }
    
    @objc func handleRefreshControl() {
        presenter.getArticles(url: Constants.getNewsURL)
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectDiskItemAt(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.viewControllerType == .feed {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsCollectionViewCell
            
            let article = presenter.dataForDiskItemAt(indexPath)
            
            cell.indexPath = indexPath
            cell.heartButton.tag = 0
            cell.cellButtonDelegate = self
            
            cell.set(article: article)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 22
            return cell
        }
        
        else if self.viewControllerType == .favourites {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavouritesCollectionViewCell
            
            let article = presenter.dataForDiskItemAt(indexPath)
            
            cell.indexPath = indexPath
            cell.heartButton.tag = 0
            cell.cellButtonDelegate = self
            
            cell.set(article: article)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 22
            return cell
        }
        return UICollectionViewCell()
    }
}

extension NewsViewController: LikeButtonDelegate {
    func likeButtonClicked(tag: Int, indexPath: IndexPath) {
        let article = presenter.dataForDiskItemAt(indexPath)
        article.liked = !article.liked
        
        presenter.coreDataManager.saveContext()
        try! presenter.fetchResultController.performFetch()
        self.collectionView.reloadData()
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.viewControllerType == .feed ? CGSize.init(width: 345, height: 240) : CGSize.init(width: 164, height: 191)
    }
}

extension NewsViewController: NewsProtocol {
    func success() {
        activityIndicator.stopAnimating()
        presenter.coreDataManager.saveContext()
        try! presenter.fetchResultController.performFetch()
        self.collectionView.reloadData()
    }
    
    func failure() {
        activityIndicator.stopAnimating()
        debugPrint("failure in News View Controller")
    }
    
    func openDiskItemView(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
