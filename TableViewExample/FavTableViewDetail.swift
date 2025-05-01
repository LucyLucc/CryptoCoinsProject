//
//  FavTableViewDetail.swift
//  TableViewExample
//
//  Created by Lucy Chetalam on 01/05/2025.
//  Copyright © 2025 CodeWithCal. All rights reserved.
//

import Foundation
import UIKit


class FavTableViewDetail: UIViewController
{
    
    @IBOutlet weak var favIcon: UIImageView!
    @IBOutlet weak var favName: UILabel!
    
    @IBOutlet weak var contracts: UILabel!
    @IBOutlet weak var btcPrice: UILabel!
    @IBOutlet weak var listedAt: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    var selectedShape : Coin!
    
    //The received data gets initialized below
       init?(coder: NSCoder, selectedShape: Coin) {
         self.selectedShape = selectedShape
         super.init(coder: coder)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        favName.text = selectedShape.name
        favIcon.load(urlString: selectedShape.iconUrl)
        coinPrice.text = ("Price: \(selectedShape.price)")
        listedAt.text = ("Listed At : \(selectedShape.listedAt)")
        btcPrice.text = ("btcPrice: \(selectedShape.btcPrice)")
        //print("selectedShape \(selectedShape.contractAddresses)")
    
        var addressText = ""  // Create an empty string to hold all contract addresses

        // Loop through the array and append each address followed by a newline character
        for address in selectedShape.contractAddresses {
            print("address \(address)")
            addressText += address + "\n"
        }

        contracts.text = addressText  // Set the label's text to the concatenated string
        contracts.numberOfLines = selectedShape.contractAddresses.count  // Number of lines will match the count of contract addresses
        contracts.lineBreakMode = .byWordWrapping
        
    }
}
