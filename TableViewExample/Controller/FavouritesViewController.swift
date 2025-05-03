import UIKit

class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fetchedCoins: [Coin] = []
    @IBOutlet weak var emptyListView: UIView!
    @IBOutlet weak var emptyList: UILabel!
    var refreshControl: UIRefreshControl?
    @IBOutlet weak var favouriteTableView: UITableView!
    var selectedShapePosition = 0
    var isObserverAdded = false

    @IBSegueAction
    private func showFavTableViewDetail(coder: NSCoder, sender: Any?, segueIdentifier: String?)
       -> FavTableViewDetail? {
           return FavTableViewDetail(coder: coder, selectedShape: self.fetchedCoins[selectedShapePosition])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshList)
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleListChange), name: .favouriteSwipped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCryptoSwipe(_:)), name: .cryptoSwiped, object: nil)
        
        addRefreshControl()
        handleListChange()
        self.view.layoutIfNeeded()
    }

    @objc func handleCryptoSwipe(_ notification: Notification) {
        if let name = notification.userInfo?["name"] as? String {
            print("Swiped on: \(name)")
        }

        if let tabbarvalue = tabBarController as? CustomTabBarController {
            let newCoins = tabbarvalue.selectedCoins
            self.fetchedCoins.append(contentsOf: newCoins)
            self.fetchedCoins = uniqueElementsFrom(array: self.fetchedCoins)
            favouriteTableView.reloadData()
            emptyListView.isHidden = !self.fetchedCoins.isEmpty
        }
    }

    @objc func handleListChange() {
        favouriteTableView.reloadData()
        emptyListView.isHidden = !fetchedCoins.isEmpty
        self.view.layoutIfNeeded()
    }

    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        favouriteTableView.addSubview(refreshControl!)
    }

    @objc func refreshList() {
        guard let tabbarvalue = tabBarController as? CustomTabBarController else { return }
        
        self.fetchedCoins.append(contentsOf: tabbarvalue.selectedCoins)
        self.fetchedCoins = uniqueElementsFrom(array: self.fetchedCoins)
        
        refreshControl?.endRefreshing()
        favouriteTableView.reloadData()
        emptyListView.isHidden = !fetchedCoins.isEmpty
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isObserverAdded {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handleCryptoSwipe(_:)),
                                                   name: .cryptoSwiped,
                                                   object: nil)
            isObserverAdded = true
        }

        if let tabbarvalue = tabBarController as? CustomTabBarController {
            self.fetchedCoins.append(contentsOf: tabbarvalue.selectedCoins)
            self.fetchedCoins = uniqueElementsFrom(array: self.fetchedCoins)
        }

        favouriteTableView.reloadData()
        emptyListView.isHidden = !fetchedCoins.isEmpty
    }

    func uniqueElementsFrom<T: Hashable>(array: [T]) -> [T] {
        var set = Set<T>()
        return array.filter {
            guard !set.contains($0) else { return false }
            set.insert($0)
            return true
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavouriteViewCellID") as! FavableViewCell
        let coin = fetchedCoins[indexPath.row]
        tableViewCell.favName.text = coin.name
        tableViewCell.favImage.load(urlString: coin.iconUrl)
        return tableViewCell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            let coinToRemove = self.fetchedCoins[indexPath.row]
            self.fetchedCoins.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if let tabbarvalue = self.tabBarController as? CustomTabBarController {
                tabbarvalue.selectedCoins.removeAll(where: { $0 == coinToRemove })
            }

            self.emptyListView.isHidden = !self.fetchedCoins.isEmpty
            completion(true)
        }

        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedShapePosition = indexPath.row
        self.performSegue(withIdentifier: "favDetailSegue", sender: self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
