
import UIKit
import SwiftUI


protocol SecondViewControllerDelegate: AnyObject {
    func didFetchCoins(_ coins: [String])
}


class TableHeader : UITableViewHeaderFooterView{
    static let identifier = "TableHeader"
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Crypto Coins"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.backgroundColor = .gray
        return label
    }()
    
    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
            
            // Ensure label fits well within the header and is properly aligned
            label.sizeToFit()
            label.frame = CGRect(x: 0, y: (contentView.frame.height - label.frame.height) / 2, width: contentView.frame.width, height: label.frame.height)
    }
    
}


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    weak var delegate: SecondViewControllerDelegate?
    
    let searchController = UISearchController()
    var selectedShapePosition = 0
 
	@IBOutlet weak var shapeTableView: UITableView!
    let getDataFromJson = GetJSONData()
    
    var favouriteCoins:[Coin] = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func sendData() {
        NotificationCenter.default.post(name: Notification.Name("DidFetchCoinsNotification"), object: ["coins" : favouriteCoins])
    }
    
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
	
	/*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
	{
        
		if(segue.identifier == "detailSegue")
		{
			let indexPath = self.shapeTableView.indexPathForSelectedRow!
			
			let tableViewDetail = segue.destination as? TableViewDetail
			
            let selectedShape = getDataFromJson.coinArray[indexPath.row]
			
			tableViewDetail!.selectedShape = selectedShape
			
			self.shapeTableView.deselectRow(at: indexPath, animated: true)
		}
	}
    */
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Add selected coin item to a list array
        
        let addFavourites = UIContextualAction(style: .destructive, title: nil){_,_, completion in
            let selectedCoin = self.getDataFromJson.coinArray[indexPath.row].name
            
            self.favouriteCoins.append(self.getDataFromJson.coinArray[indexPath.row])
            //print("Selected \(selectedCoin) as favourite")
            self.sendData()
            completion(true)
        }
        addFavourites.image = UIImage(systemName: "heart")
        addFavourites.backgroundColor = .systemGreen
        
        let config = UISwipeActionsConfiguration(actions: [addFavourites])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func getFavouriteCoins() -> [Coin?]{
        
        return favouriteCoins
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
