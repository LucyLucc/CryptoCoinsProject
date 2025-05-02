
import UIKit
import SwiftUI


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var selectedShapePosition = 0
    let getDataFromJson = GetJSONData()
    var favouriteCoins:[Coin] = []
    var set = Set<Coin>()
    
	@IBOutlet weak var shapeTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func SortTable(_ sender: UISegmentedControl) {
        sortCoinTable()
    }
    
    func sortCoinTable(){
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            getDataFromJson.coinArray.sort(by: {$0.price > $1.price})
        case 1:
            getDataFromJson.coinArray.sort(by: {$0.volume24h > $1.volume24h})
        default:
            print("Error occured!")
        }
        shapeTableView.reloadData()
    }
    
    
    @IBSegueAction
    private func showTableViewDetail(coder: NSCoder, sender: Any?, segueIdentifier: String?)
       -> TableViewDetail? {
           return TableViewDetail(coder: coder, selectedShape: getDataFromJson.coinArray[selectedShapePosition])
    }
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
        shapeTableView.delegate = self
        shapeTableView.dataSource = self
        initList()
        
        let tabbarvalue = tabBarController as! CustomTabBarController
        favouriteCoins = tabbarvalue.selectedCoins
	}
	
    override func viewDidDisappear(_ animated: Bool) {
        let tabbarvalue = tabBarController as! CustomTabBarController
        tabbarvalue.selectedCoins = self.favouriteCoins
        //print("tabview on disapper \(tabbarvalue.selectedCoins[0].name)")
    }
    
	func initList()
	{
        getDataFromJson.getData {
            DispatchQueue.main.async{self.sortCoinTable()}
        }
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return getDataFromJson.coinArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! TableViewCell
		
		let thisShape = getDataFromJson.coinArray[indexPath.row]
		
		tableViewCell.shapeName.text = "\(thisShape.name)"
       
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.currencyCode = "$"
        formatter.numberStyle = .currency
        
        let value = Decimal(string: thisShape.price)!
        
        let stringPrice = formatter.string(for: value) ?? "?"
         
        tableViewCell.shapePrice.text = "Price: \(stringPrice) "
        
        tableViewCell.shapePerformance.text = "\(thisShape.volume24h)"
       
        tableViewCell.shapeImage.load(urlString: thisShape.iconUrl)
		
		return tableViewCell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
        selectedShapePosition = indexPath.row
		self.performSegue(withIdentifier: "detailSegue", sender: self)
	}
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Add selected coin item to a list array
        
        let addFavourites = UIContextualAction(style: .destructive, title: nil){_,_, completion in
            let selectedCoin = self.getDataFromJson.coinArray[indexPath.row].name
            NotificationCenter.default.post(name: Notification.Name("favouriteSwipped"), object: nil, userInfo: nil)
            self.addCoin(object: self.getDataFromJson.coinArray[indexPath.row])
            print("Selected \(selectedCoin) as favourite")
            completion(true)
        }
        addFavourites.image = UIImage(systemName: "heart")
        addFavourites.backgroundColor = .systemGreen
        
        let config = UISwipeActionsConfiguration(actions: [addFavourites])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func addCoin(object: Coin) {
        if !favouriteCoins.contains(object) {
            favouriteCoins.append(object)
        }
    }
}

extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
