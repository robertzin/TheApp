//
//  Article+CoreDataClass.swift
//  theApp
//
//  Created by Robert Zinyatullin on 19.02.2023.
//
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {
    
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "Article"), insertInto: CoreDataManager.shared.context)
    }
    
    func set(article: ArticleResponseObject) {
        self.author = article.author
        self.content = article.content
        self.descript = article.description
        self.liked = article.liked ?? false
        self.title = article.title
        self.publishedAt = article.publishedAt
        self.urlToImage = article.urlToImage
    }
}
