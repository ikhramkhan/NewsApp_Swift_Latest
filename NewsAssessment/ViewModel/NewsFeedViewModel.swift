//
//  NewsFeedViewModel.swift
//  NewsAssessment
//
//  Created by Mohamed Ikhram Khan on 04/06/2022.
//

import Foundation

class NewsFeedViewModel{
    private var aggregationCount = 0
    var news: Box<[Article]> = Box([])
    
    func getAllArticles(noAggregationCountCallback: @escaping () -> (), startIndex: Int , currentListCount: Int, noMoreDataCallback: @escaping () -> ()) {
        if startIndex == 0 {
            getNewsFromServer(page: startIndex, noAggregationCountCallback: noAggregationCountCallback)
        } else {
            if aggregationCount == 0 {
                noAggregationCountCallback()
            }
            else if currentListCount <= aggregationCount
            {
                getNewsFromServer(page: startIndex, noAggregationCountCallback: noAggregationCountCallback)
            }
            else{
                noMoreDataCallback()
            }
        }
    }
    
    
   private func getNewsFromServer(page: Int, noAggregationCountCallback: @escaping () -> ()) {
        START_LOADING_VIEW()
        ServiceManager.shared.methodType(requestType: GET_REQUEST, url: GET_NEWS(page: page), completion: { [weak self] (response, responseData, statusCode) in
            STOP_LOADING_VIEW()
            if let newsListData = responseData, statusCode == 200{
                let newsListResponse = try? Shared_CustomJsonDecoder.decode(NewsResponse.self, from: newsListData)
                if let totalCount = newsListResponse?.totalResults, totalCount == 0 {
                    noAggregationCountCallback()
                }
                else
                {
                self?.sendArticlesToViewController(newsResponse: newsListResponse)
                }
            }
        }) { [weak self] (failure, statusCode) in
            STOP_LOADING_VIEW()
            print("Error happened \(failure.debugDescription)")
            self?.sendArticlesToViewController(newsResponse: nil)
        }
    }
     
   private func sendArticlesToViewController(newsResponse: NewsResponse?) {
    guard let newsResponsex = newsResponse else { news.value = [];
        return }
    aggregationCount = newsResponsex.totalResults ?? 0
    news.value = newsResponsex.articles ?? []
}
}



