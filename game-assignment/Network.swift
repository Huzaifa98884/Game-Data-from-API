//
//  Network.swift
//  game-assignment
//
//  Created by Huzaifa Ali Abbasi on 09/05/2023.
//

import Foundation
let ROOT_URL = "https://api.rawg.io/api/games"

enum Network {
    case gamesList(pageNumber: Int)
    case gameSearch(text: String)
    case gameDetail(id: String)
    
    func getPath() -> String {
        switch self {
        case .gamesList(let pageNumber):
            return "?page_size=10&page=\(String(pageNumber))&key=3897ec2348af4eadb5048bcd1c109fce"
        case .gameSearch(let text):
            return "?page_size=10&page=1&search=\(text)&key=3897ec2348af4eadb5048bcd1c109fce"
        case .gameDetail(let id):
            return "/\(id)?key=3897ec2348af4eadb5048bcd1c109fce"
        }
    }
    
    func fetchData(completion: @escaping ((Data?) -> Void)) {
        if let url = URL(string: ROOT_URL + getPath()) {
            print("-------------------------------------")
            print("URL: \(url.absoluteString)")
            print("-------------------------------------")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("########### Error")
                    return completion(nil)
                }
                
                return completion(data)
            }
            task.resume()
        }
    }
}

