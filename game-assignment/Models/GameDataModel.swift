//
//  GameData.swift
//  game-assignment
//
//  Created by Huzaifa Ali Abbasi on 03/05/2023.
//

import Foundation

//struct GameDataModel {
//    var id: Int
//    var image: String
//    var name: String
//    var metacritic: Int
//    var genre: String
//
//}


struct GameDataModelDecodable: Decodable
{
    
    var results: [GameDataModel]//Result
    
}

struct GameDataModel: Decodable{//Result
    
    var id: Int
    var background_image: String
    var name: String
    var metacritic: Int
    var genres: [Genres]
    
    func convertToString() -> String{
        var allGenres = ""
        for genre in genres{
            allGenres += "\(genre), "
        }
        return allGenres
        
    }
    
}

struct Genres: Decodable{
    var name: String
}
