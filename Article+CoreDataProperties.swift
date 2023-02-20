//
//  Article+CoreDataProperties.swift
//  theApp
//
//  Created by Robert Zinyatullin on 19.02.2023.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var author: String?
    @NSManaged public var descript: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var liked: Bool
    @NSManaged public var publishedAt: String?

}

extension Article : Identifiable {

}
