//
//  NewsPresenter.swift
//  theApp
//
//  Created by Robert Zinyatullin on 18.02.2023.
//

import UIKit
import CoreData

protocol NewsProtocol {
    func success()
    func failure()
    func openDiskItemView(vc: UIViewController)
}

protocol NewsPresenterProtocol {
    init(view: NewsProtocol, vcType: Constants.NewsVCType)
    
    func getArticles(url: String)
    
    func numberOfRowsInSection(at section: Int) -> Int
    func dataForDiskItemAt(_ indexPath: IndexPath) -> Article
    func didSelectDiskItemAt(_ indexPath: IndexPath)
    
    var articles: [ArticleResponseObject]? { get set }
    
    var coreDataManager: CoreDataManager! { get }
    var fetchResultController: NSFetchedResultsController<Article> { get }
}

final class NewsPresenter: NewsPresenterProtocol {
    var view: NewsProtocol?
    var viewControllerType: Constants.NewsVCType?
    
    var articles: [ArticleResponseObject]? = []
    
    var coreDataManager: CoreDataManager!
    var networkManager: NetworkManagerProtocol!
    var fetchResultController: NSFetchedResultsController<Article>
    
    required init(view: NewsProtocol, vcType: Constants.NewsVCType) {
        self.view = view
        self.viewControllerType = vcType
        self.coreDataManager = CoreDataManager.shared
        self.networkManager = NetworkManager.shared
        self.fetchResultController = vcType == .feed
            ? coreDataManager.newsFetchResultController
            : coreDataManager.favouritedNewsFetchResultController
    }

    func getArticles(url: String) {
        if self.viewControllerType == .feed {
            networkManager.getNews(url: url) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let articleResponseObjects):
                        // MARK: add elements to CoreData
                        articleResponseObjects?.forEach({ articleResponseObject in
                            let article = Article()
                            article.set(article: articleResponseObject)
                        })
                        
                        self?.view?.success()
                    case .failure(let error):
                        debugPrint("getNews failure: \(error.localizedDescription)")
                        self?.view?.failure()
                    }
                }
            }
        } else {
            self.view?.success()
        }
    }
    
    func numberOfRowsInSection(at section: Int) -> Int {
        guard let sections = fetchResultController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func dataForDiskItemAt(_ indexPath: IndexPath) -> Article {
        if (fetchResultController.sections) != nil {
            return fetchResultController.object(at: indexPath)
        }
        return Article()
    }
    
    func didSelectDiskItemAt(_ indexPath: IndexPath) {
        let article = fetchResultController.object(at: indexPath)
        let vc = DetailsViewController()
        vc.article = article
        view?.openDiskItemView(vc: vc)
    }
}
