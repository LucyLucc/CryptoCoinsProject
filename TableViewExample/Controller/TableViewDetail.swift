
import Foundation
import UIKit
import SwiftUI
import SnapKit


class TableViewDetail: UIViewController
{
	
	@IBOutlet weak var name: UILabel!
	
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var image: UIImageView!
	
    @IBOutlet weak var perfmance: UILabel!
    @IBOutlet weak var color: UIButton!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var tier: UILabel!
    
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
		
		name.text = selectedShape.name
        symbol.text = "Symbol: \(selectedShape.symbol)"
        rank.text = "Rank: \(String(selectedShape.rank))"
        tier.text = "Tier \(String(selectedShape.tier))"
        color.backgroundColor = hexStringToUIColor(hex: selectedShape.color)
        color.layer.cornerRadius = 5
        color.layer.borderWidth = 1
        
        let controller = UIHostingController(rootView: PerformanceChart(sparkline: selectedShape.sparkline))
        guard let perfView = controller.view else {
            
            return
        }
        
        view.addSubview(perfView)
        perfView.snp.makeConstraints{make in
            //make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
            make.topMargin.greaterThanOrEqualTo(perfmance).offset(120)
        }
        
	}
}

func drawRectangle()
{
    // Get the Graphics Context
    let context = UIGraphicsGetCurrentContext()

    // Set the rectangle outerline-width
    context?.setLineWidth( 5.0)

    // Set the rectangle outerline-colour
    UIColor.red.set()

    // Create Rectangle
    context?.addRect( CGRect(x: 0, y: 0, width: 100, height: 100))

    // Draw
    context?.strokePath()

}


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


