import UIKit
import SwiftUI
import Network

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedShapePosition = 0
    let getDataFromJson = GetJSONData()
    var favouriteCoins: [Coin] = []
    var set = Set<Coin>()
    let monitor = NWPathMonitor()
    var isConnected = true

    @IBOutlet weak var shapeTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "No internet connection."
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        shapeTableView.delegate = self
        shapeTableView.dataSource = self
        setupErrorLabel()
        startMonitoringConnection()
        initList()

        if let tabbarvalue = tabBarController as? CustomTabBarController {
            favouriteCoins = tabbarvalue.selectedCoins
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let tabbarvalue = tabBarController as? CustomTabBarController {
            tabbarvalue.selectedCoins = self.favouriteCoins
        }
    }

    func setupErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func startMonitoringConnection() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.errorLabel.isHidden = self.isConnected
                if self.isConnected {
                    self.initList()
                } else {
                    self.shapeTableView.reloadData()
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func initList() {
        guard isConnected else { return }
        getDataFromJson.getData {success in 
            DispatchQueue.main.async {
                if success {
                    self.sortCoinTable()
                } else {
                    self.errorLabel.isHidden = false
                }
            }
        }
    }

    @IBAction func SortTable(_ sender: UISegmentedControl) {
        sortCoinTable()
    }

    func sortCoinTable() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            getDataFromJson.coinArray.sort(by: {
                       guard let price1 = Decimal(string: $0.price),
                             let price2 = Decimal(string: $1.price) else { return false }
                       return price1 > price2
                   })
        case 1:
            getDataFromJson.coinArray.sort {
                        (Double($0.volume24h) ?? 0.0) > (Double($1.volume24h) ?? 0.0)
                    }
        default:
            print("Error occurred!")
        }
        shapeTableView.reloadData()
    }

    @IBSegueAction
    private func showTableViewDetail(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> TableViewDetail? {
        return TableViewDetail(coder: coder, selectedShape: getDataFromJson.coinArray[selectedShapePosition])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isConnected ? getDataFromJson.coinArray.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! TableViewCell
        let thisShape = getDataFromJson.coinArray[indexPath.row]
        tableViewCell.shapeName.text = thisShape.name

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.currencyCode = "$"
        formatter.numberStyle = .currency

        let value = Decimal(string: thisShape.price)!
        let stringPrice = formatter.string(for: value) ?? "?"
        tableViewCell.shapePrice.text = "Price: \(stringPrice)"
       // tableViewCell.shapePerformance.text = "\(thisShape.volume24h)"
        
        if let volume = Double(thisShape.volume24h) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 0
            let volumeFormatted = numberFormatter.string(from: NSNumber(value: volume)) ?? "?"
            tableViewCell.shapePerformance.text = "\(volumeFormatted)"
        } else {
            tableViewCell.shapePerformance.text = "24h Vol: ?"
        }
        tableViewCell.shapeImage.load(urlString: thisShape.iconUrl)

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedShapePosition = indexPath.row
        performSegue(withIdentifier: "detailSegue", sender: self)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addFavourites = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            let selectedCoin = self.getDataFromJson.coinArray[indexPath.row]
            let selectedName = selectedCoin.name

            NotificationCenter.default.post(name: .favouriteSwipped, object: nil)
            NotificationCenter.default.post(name: .cryptoSwiped, object: nil, userInfo: ["name": selectedName])

            if let tabbarvalue = self.tabBarController as? CustomTabBarController {
                if !tabbarvalue.selectedCoins.contains(selectedCoin) {
                    tabbarvalue.selectedCoins.append(selectedCoin)
                }
                if !tabbarvalue.lastSwipedCoins.contains(selectedCoin) {
                    tabbarvalue.lastSwipedCoins.append(selectedCoin)
                }
            }

            if !self.favouriteCoins.contains(selectedCoin) {
                self.favouriteCoins.append(selectedCoin)
            }

            print("Selected \(selectedName) as favourite")
            completion(true)
        }

        addFavourites.image = UIImage(systemName: "heart")
        addFavourites.backgroundColor = .systemGreen

        let config = UISwipeActionsConfiguration(actions: [addFavourites])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
