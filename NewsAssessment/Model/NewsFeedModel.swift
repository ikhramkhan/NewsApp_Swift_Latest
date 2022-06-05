//
//  NewsFeedModel.swift
//  NewsAssessment
//
//  Created by Mohamed Ikhram Khan on 04/06/2022.
//

import Foundation

struct NewsResponse: Decodable {
    var articles: [Article]?
    var status: String?
    var totalResults: Int?
}

struct Article: Decodable {
    var source: ArticleSource
    var author, title, description, urlToImage, publishedAt: String?
}

struct ArticleSource: Decodable {
    var   id, name: String?
}
