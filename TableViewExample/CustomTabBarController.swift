//
//  CustomTabBarController.swift
//  TableViewExample
//
//  Created by Lucy Chetalam on 29/04/2025.
//  Copyright © 2025 CodeWithCal. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController
{
    @IBInspectable var initialIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex
        
        configureTabs()
    }
    
    private func configureTabs(){
        let vc1 = TableViewController()
        let vc2 = FavouritesViewController()
        
        vc1.title = "Home"
        vc2.title = "Favourites"
        
    }
}
