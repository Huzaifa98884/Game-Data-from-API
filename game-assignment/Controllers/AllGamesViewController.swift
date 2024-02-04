
import UIKit
import SDWebImage


internal class AllGamesViewController: UIViewController {
    
    private var pageNumber = 1
    private var gameData = [GameDataModel]()
    private let constants = Constants()
    
    
    @IBOutlet weak private var searchGame: UISearchBar!
    @IBOutlet weak private var myTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.navigationItem.title = "Games"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.rowHeight = CGFloat(constants.tableRowHeight)
        searchGame.delegate = self
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName: constants.cellNameAndIdentifier, bundle: nil),
                         forCellReuseIdentifier: constants.cellNameAndIdentifier)
        callApi(showLoader: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeArea = self.myTable.safeAreaInsets
        self.myTable.contentInset = .init(top: safeArea.bottom, left: 0, bottom: safeArea.top, right: 0)
    }
}

// MARK: - Search Bar
extension AllGamesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        callSearchApi()
        searchBar.resignFirstResponder()
        
    }
}


//MARK: - TableView Delegate Methods
extension AllGamesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(hex: constants.cellOnClickedColor)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: constants.favouriteVCStoryboardId) as! GameDetailsViewContoller
            vc.favouriteGame = FavouriteGameModel().convertGameToFav(item: gameData[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Table View Data Source Methods
extension AllGamesViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.myTable.tableFooterView = spinner
            self.myTable.tableFooterView?.isHidden = false
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: constants.cellNameAndIdentifier,
            for: indexPath) as! GameViewCell
        // todo Data should be given in cell file
        cell.addCellDatawithGameData(gamemodel: gameData[indexPath.row])
        
        if indexPath.row == gameData.count - 1 { // last cell
            callApi(showLoader: false)
        }
        return cell
    }
}

// MARK: - API Calling & Parsing
extension AllGamesViewController {
    private func callApi(showLoader: Bool){
        if showLoader {
            self.gameData.removeAll()
            showloader()
        }
        Network.gamesList(pageNumber: pageNumber).fetchData { data in
            if showLoader {
                self.dismissloader()
            }
            self.parseJSONAllGameData(data, searched: false)
        }
    }
    
    private func callSearchApi() {
        showloader()
        gameData.removeAll()
        Network.gameSearch(text: searchGame.text ?? "").fetchData { data in
            self.parseJSONAllGameData(data, searched: true)
            self.dismissloader()
        }
    }
    
    private func parseJSONAllGameData(_ gameData: Data?, searched: Bool){
        if let gameData = gameData {
            pageNumber = (searched ? 1 : pageNumber + 1)
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(GameDataModelDecodable.self, from: gameData)
                self.gameData.append(contentsOf: decodedData.results)
                DispatchQueue.main.async {
                    self.myTable.reloadData()
                }
            } catch {
                print("Error decoding data \(error)")
                return
            }
        } else {
            print("Error while fetching data")
        }
    }
}



