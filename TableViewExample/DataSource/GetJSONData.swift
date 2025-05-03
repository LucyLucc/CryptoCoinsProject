import Foundation
import Network

class GetJSONData {
    
    let urlString = "https://api.coinranking.com/v2/coins"
    var coinArray: [Coin] = []
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")

    func getData(completion: @escaping (_ success: Bool) -> ()) {
        
        monitor.pathUpdateHandler = { path in
            self.monitor.cancel() 

            guard path.status == .satisfied else {
                print("No internet connection.")
                completion(false)
                return
            }

            // Internet is available, proceed with network call
            guard let url = URL(string: self.urlString) else {
                print("URL is invalid. Try again.")
                completion(false)
                return
            }

            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let data = data else {
                    print("No data received.")
                    completion(false)
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(Root.self, from: data)
                    self.coinArray = decodedData.data.coins
                    completion(true)
                } catch {
                    print("Decoding error: \(error)")
                    completion(false)
                }
            }
            task.resume()
        }
        
        monitor.start(queue: queue)
    }
}
