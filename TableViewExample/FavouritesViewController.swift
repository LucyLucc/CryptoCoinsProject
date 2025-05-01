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
  
    var observer: NSObjectProtocol?
    
    @IBOutlet weak var favouriteTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var selectedShapePosition = 0
    
    let getFavouriteCoins = TableViewController().getFavouriteCoins()
    
    @IBSegueAction
   private func showFavTableViewDetail(coder: NSCoder, sender: Any?, segueIdentifier: String?)
       -> FavTableViewDetail? {
           return FavTableViewDetail(coder: coder, selectedShape: self.fetchedCoins[selectedShapePosition])
   }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        favouriteTableView.dataSource = self
        favouriteTableView.delegate = self
        
      //  updateNoDataLabelVisibility()
        
        print("Fetched Coins: \(self.getFavouriteCoins)")
        // Listen for the notification
        observer  =    NotificationCenter.default.addObserver(forName: Notification.Name("DidFetchCoinsNotification"), object: nil, queue: .main, using: {notification in
            guard let object = notification.object as? [String: [Coin]] else{
                return
            }
            
            guard let coins = object["coins"] else {
                
                return
            }
            
            self.fetchedCoins.append(contentsOf: coins)
            self.favouriteTableView.reloadData()
            print("Received from notification \(coins)")
        })
        
        favouriteTableView.reloadData()
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the count of your data array
       let count = fetchedCoins.count
       
       // Update the no data label visibility
       //updateNoDataLabelVisibility()
       
       return count
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
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "favDetailSegue")
        {
            let indexPath = self.favouriteTableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? TableViewDetail
            
            let selectedCoin = self.fetchedCoins[indexPath.row]
            
            tableViewDetail!.selectedShape = selectedCoin
            
            self.favouriteTableView.deselectRow(at: indexPath, animated: true)
        }
    }*/
    
    // Helper function to show or hide the no data label
        func updateNoDataLabelVisibility() {
            // Show the label if the array is empty, otherwise hide it
            if fetchedCoins.isEmpty {
                noDataLabel.isHidden = false
                favouriteTableView.isHidden = true // Hide the table view
            } else {
                noDataLabel.isHidden = true
                favouriteTableView.isHidden = false // Show the table view
            }
        }
    
}

