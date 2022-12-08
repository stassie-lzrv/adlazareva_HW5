//
//  ApiService.swift
//  adlazareva_HW5
//
//  Created by Настя Лазарева on 08.12.2022.
//

import Foundation

class ApiService{
    
    static let shared = ApiService()
    
    
    public func getTopStories(completion: @escaping (Result<[ArticleResponse],Error>)->Void){
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2022-12-07&sortBy=popularity&apiKey=2f6b4cc0007148559335ef38ac1a57c3") else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data,_,error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(ResponseBody.self, from: data)
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
           
        }
        task.resume()
        
    }
    
}


struct ResponseBody: Codable{
    var articles : [ArticleResponse]
    
}
    
struct ArticleResponse: Codable{
    var title: String
    var description : String?
    var urlToImage : String?
}
