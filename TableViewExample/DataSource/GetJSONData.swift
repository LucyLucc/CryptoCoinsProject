import Foundation

class GetJSONData {

    let baseUrl = "https://api.coinranking.com/v2/coins"
    var coinArray: [Coin] = []

    func getData(offset: Int, completion: @escaping (Bool) -> ()) {
        guard let url = URL(string: "\(baseUrl)?limit=20&offset=\(offset)") else {
            print("URL is invalid. Try again.")
            completion(false)
            return
        }

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print("There was an error. Try again!")
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
                self.coinArray += decodedData.data.coins
                completion(true)
            } catch {
                print("There was an error decoding the file")
                completion(false)
            }
        }
        task.resume()
    }
}
