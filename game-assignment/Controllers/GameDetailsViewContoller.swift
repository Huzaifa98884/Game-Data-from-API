//
//  GameDetailsViewContoller.swift
//  game-assignment
//
//  Created by Huzaifa Ali Abbasi on 09/05/2023.
//

import UIKit
import SDWebImage
import SafariServices
import RealmSwift

class GameDetailsViewContoller: UIViewController {
    
    private let realm = try! Realm()
    var favouriteGame = FavouriteGameModel()
    private var favouriteButton: UIBarButtonItem = UIBarButtonItem(title: "Favourite", style: .plain, target: GameDetailsViewContoller.self, action: nil)
    private var redditUrl = ""
    private var websiteUrl = ""
    
    @IBOutlet weak private var gameImage: UIImageView!
    @IBOutlet weak private var gameName: UILabel!
    @IBOutlet weak private var gameDescriptionDetails: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteButton.target = self
        favouriteButton.action = #selector(favouriteButtonPressed(sender:))
        navigationItem.rightBarButtonItem = favouriteButton
        callApi()
        
    }
    
    @IBAction private func redditButtonTapped(_ sender: Any) {
        openurl(urlAsString: redditUrl)
    }
    
    @IBAction private func websiteButtonTapped(_ sender: Any) {
        openurl(urlAsString: websiteUrl)
    }
    
    @IBAction private func readMoreButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "read more"{
            gameDescriptionDetails.numberOfLines = 0
            sender.setTitle("read less", for: .normal)
        } else{
            gameDescriptionDetails.numberOfLines = 4
            sender.setTitle("read more", for: .normal)
        }
    }
}

extension GameDetailsViewContoller {
    //MARK: - API Calling and Parsing
    private func callApi(){
        showloader()
        Network.gameDetail(id: String(favouriteGame.id)).fetchData { data in
                self.parseClickedGameData(data)
                self.dismissloader()
            
        }
    }
    
    private func parseClickedGameData(_ gameDetailsData: Data?){
        if let gameData = gameDetailsData{
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(GameDetailsModel.self, from: gameData)
                updateUI(decodedData)
            } catch {
                print("Error decoding data \(error)")
                return
            }
        } else {
            print("Error while fetching data")
            return
        }
    }
}

extension GameDetailsViewContoller {
    //MARK: - Updating UI to show the loaded data
    func updateUI(_ gameDetails: GameDetailsModel) {
        DispatchQueue.main.async {
            self.favouriteButton.title = (self.checkIfAlreadyAdded(delete: false) ? "UnFavourite" : "Favourite")
            self.gameName.text = gameDetails.name
            self.gameDescriptionDetails.text = gameDetails.description.html2String
            self.redditUrl = gameDetails.reddit_url
            self.websiteUrl = gameDetails.website
            let url = URL(string: gameDetails.background_image)!
            self.gameImage.sd_setImage(with: url)
            
        }
    }
}

extension GameDetailsViewContoller {
    //MARK: - Buttons Functionality
    @discardableResult
    private func checkIfAlreadyAdded(delete: Bool) -> Bool {
        let favourites = realm.objects(FavouriteGameModel.self)
        let copiedObject = favouriteGame.copy() as! FavouriteGameModel
        for fav in favourites{
            if copiedObject.id == fav.id{
                print(copiedObject)
                if delete == true {
                    try! realm.write{
                        realm.delete(fav)
                        favouriteButton.title = "Favourite"
                    }
                    
                }
                return true
            }
        }
        return false
    }
    
    @objc private func favouriteButtonPressed(sender: UIButton!){
        showloader()
        
        if favouriteButton.title == "Favourite" {
            let copiedObject = favouriteGame.copy() as! FavouriteGameModel
            try! realm.write {
                print("Value Added")
                realm.add(copiedObject)
                favouriteButton.title = "UnFavourite"
            }
        } else {
            print("Value Removed")
            checkIfAlreadyAdded(delete: true)
        }
        dismissloader()
    }
    
    private func openurl(urlAsString: String){
        if let url = URL(string: urlAsString) {
            UIApplication.shared.open(url)
        }
    }
    
}



