//
//  FavouritesViewController.swift
//  game-assignment
//
//  Created by Huzaifa Ali Abbasi on 18/05/2023.
//

import UIKit
import RealmSwift
import SDWebImage

class FavouritesViewController: UIViewController {
    
    private var favourites = [FavouriteGameModel]()
    private let realm = try! Realm()
    
    @IBOutlet weak private var myTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Favourites"
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        myTable.rowHeight = CGFloat(Constants().tableRowHeight)
        myTable.dataSource = self
        
        myTable.register(UINib(nibName: Constants().cellNameAndIdentifier, bundle: nil),forCellReuseIdentifier: Constants().cellNameAndIdentifier)
    }
}

//MARK: - Loads Data from Realm
extension FavouritesViewController {
    private func loadData(){
        let data = realm.objects(FavouriteGameModel.self)
        favourites.removeAll()
        if(!data .isEmpty){
            for d in data{
                favourites.append(d)
            }
        }
        DispatchQueue.main.async {
            self.myTable.reloadData()
        }
    }
}

extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favourites.count == 0 {
            myTable.isHidden = true
            return 0
        } else {
            myTable.isHidden = false
            self.tabBarController?.navigationItem.title = "Favourites (\(favourites.count))"
            return favourites.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants().cellNameAndIdentifier,
                      for: indexPath) as! GameViewCell
        cell.addCellDatawithFavouriteData(favouriteModel: favourites[indexPath.row])
        return cell
    }
    
}
