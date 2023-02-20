//
//  NewsResponseObject.swift
//  theApp
//
//  Created by Robert Zinyatullin on 18.02.2023.
//

import UIKit

class NewsResponseObject: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [ArticleResponseObject]?
}

class ArticleResponseObject: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var liked: Bool?
}

struct Source: Codable {
    var id: String?
    var name: String?
}
