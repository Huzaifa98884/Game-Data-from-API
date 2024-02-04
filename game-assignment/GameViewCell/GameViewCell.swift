//
//  GameViewCell.swift
//  game-assignment
//
//  Created by Huzaifa Ali Abbasi on 03/05/2023.
//

import UIKit
import SDWebImage

class GameViewCell: UITableViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameMetacritic: UILabel!
    @IBOutlet weak var gameGenres: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addCellDatawithGameData(gamemodel: GameDataModel) {
        gameName.text = gamemodel.name
        gameGenres.text = gamemodel.convertToString()
        gameMetacritic.text = String(gamemodel.metacritic)
        let imageUrl = URL(string: gamemodel.background_image)
        DispatchQueue.main.async {
            self.gameImage.sd_setImage(with: imageUrl)
        }
    }
    
    func addCellDatawithFavouriteData(favouriteModel: FavouriteGameModel){
        gameName.text = favouriteModel.name
        gameGenres.text = favouriteModel.genre
        gameMetacritic.text = String(favouriteModel.metacritic)
        let imageUrl = URL(string: favouriteModel.image)
        DispatchQueue.main.async {
            self.gameImage.sd_setImage(with: imageUrl)
        }
    }
}
