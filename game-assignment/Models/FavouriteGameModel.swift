//
//  File.swift
//  game-assignment
//
//  Created by Huzaifa Ali Abbasi on 18/05/2023.
//

import Foundation
import RealmSwift

class FavouriteGameModel: Object{
    
    @objc dynamic var id: Int = 0
    @objc dynamic var image:  String = ""
    @objc dynamic var name:  String = ""
    @objc dynamic var metacritic: Int = 0
    @objc dynamic var genre:  String = ""
    
    override func copy() -> Any {
            let copy = FavouriteGameModel()
            copy.id = self.id
            copy.image = self.image
            copy.name = self.name
            copy.metacritic = self.metacritic
            copy.genre = self.genre
            return copy
        }
    
    func convertGameToFav(item: GameDataModel) -> FavouriteGameModel {
        let saveGameData = FavouriteGameModel()
        saveGameData.id = item.id
        saveGameData.name = item.name
        saveGameData.image = item.background_image
        saveGameData.metacritic = item.metacritic
        saveGameData.genre = item.convertToString()
        return saveGameData
    }
    
}
