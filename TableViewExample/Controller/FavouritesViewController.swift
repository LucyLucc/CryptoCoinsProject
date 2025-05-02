//
//  FavouritesViewController.swift
//  TableViewExample
//
//  Created by Lucy Chetalam on 29/04/2025.
//  Copyright © 2025 CodeWithCal. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var fetchedCoins: [Coin] = []
    @IBOutlet weak var emptyListView: UIView!
    var fetchedCoinsX: [Coin] = []
    @IBOutlet weak var emptyList: UILabel!
    let messageLabel = UILabel()
    var observer: NSObjectProtocol?
    var refreshControl: UIRefreshControl?
    @IBOutlet weak var favouriteTableView: UITableView!
    var selectedShapePosition = 0
    
    @IBSegueAction
    private func showFavTableViewDetail(coder: NSCoder, sender: Any?, segueIdentifier: String?)
       -> FavTableViewDetail? {
           return FavTableViewDetail(coder: coder, selectedShape: self.fetchedCoins[selectedShapePosition])
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(refreshList))
        favouriteTableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleListChange), name: Notification.Name("favouriteSwipped"), object: nil)
        addRefreshControl()
        handleListChange()
        self.view.layoutIfNeeded()
    }
    
    @objc func handleListChange(){
        favouriteTableView.reloadData()
        print("fetchedCoins\(fetchedCoins)")
        if(fetchedCoins.count == 0){
            favouriteTableView.backgroundView = emptyListView
        }else{
            emptyListView.isHidden = true
            favouriteTableView.backgroundView = nil
        }
        self.view.layoutIfNeeded()
    }
    
    func addRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.red
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        favouriteTableView.addSubview(refreshControl!)
        
    }
    
    @objc func refreshList(){
        let tabbarvalue = tabBarController as! CustomTabBarController
        
        self.fetchedCoins.append(contentsOf: tabbarvalue.selectedCoins)
        
        self.fetchedCoins = uniqueElementsFrom(array:self.fetchedCoins)
        print("tabbarvalue.selectedCoins \(tabbarvalue.selectedCoins)")
        
        refreshControl?.endRefreshing()
        favouriteTableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbarvalue = tabBarController as! CustomTabBarController
        
        self.fetchedCoins.append(contentsOf: tabbarvalue.selectedCoins)
        
        self.fetchedCoins = uniqueElementsFrom(array:self.fetchedCoins)
        print("tabbarvalue.selectedCoins \(tabbarvalue.selectedCoins)")
       
        DispatchQueue.main.async {
                self.favouriteTableView.reloadData()
            }
        self.view.layoutIfNeeded()
    }
    
    func uniqueElementsFrom<T: Hashable>(array: [T]) -> [T] {
      var set = Set<T>()
      let result = array.filter {
        guard !set.contains($0) else {
          return false
        }
        set.insert($0)
        return true
      }
      return result
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the count of your data array
        print(fetchedCoins.count)
        return fetchedCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavouriteViewCellID") as! FavableViewCell
        
        let thisName = fetchedCoins[indexPath.row].name
        let thisIcon = fetchedCoins[indexPath.row].iconUrl
        
        tableViewCell.favName.text = "\(thisName)"
        
        tableViewCell.favImage.load(urlString:thisIcon)
        return tableViewCell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil){_,_, completion in
            self.fetchedCoins.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            let tabbarvalue = self.tabBarController as! CustomTabBarController
            tabbarvalue.selectedCoins.remove(at: indexPath.row)
            
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedShapePosition = indexPath.row
        self.performSegue(withIdentifier: "favDetailSegue", sender: self)
    }
}

