//
//  CustomTabBarController.swift
//  TableViewExample
//
//  Created by Lucy Chetalam on 29/04/2025.
//  Copyright © 2025 CodeWithCal. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate
{
    @IBInspectable var initialIndex: Int = 0
    var selectedCoins: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        selectedIndex = initialIndex
        selectedCoins.removeAll()
        
        configureTabs()
    }
    
    private func configureTabs(){
        let vc1 = TableViewController()
        let vc2 = FavouritesViewController()
        
        vc1.title = "Home"
        vc2.title = "Favourites"
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //selectedCoins.removeAll()
    }
}
