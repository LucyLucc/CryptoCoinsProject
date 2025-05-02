//
//  FavTableViewDetail.swift
//  TableViewExample
//
//  Created by Lucy Chetalam on 01/05/2025.
//  Copyright © 2025 CodeWithCal. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

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
        
        let controller = UIHostingController(rootView: DynamicCharts(sparkline: selectedShape.sparkline))
        guard let chartfView = controller.view else {
            
            return
        }
        
        view.addSubview(chartfView)
        chartfView.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
            make.topMargin.greaterThanOrEqualTo(btcPrice).offset(120)
        }
        
    }
}
