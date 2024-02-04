//
//  GameDetailsModel.swift
//  game-assignment
//
//  Created by Huzaifa Ali Abbasi on 08/05/2023.
//

import Foundation

//struct GameDetailsModel{
//    var gameImage: String
//    var gameName: String
//    var gameDescription: String
//    var websiteUrl: String
//    var redditUrl: String
//    
//}

struct GameDetailsModel: Decodable
{
    var background_image: String
    var name: String
    var description: String
    var website: String
    var reddit_url: String
    
}

