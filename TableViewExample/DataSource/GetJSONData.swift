//
//  GetJSONData.swift
//  CryptoCoinProject
//
//  Created by Lucy Chetalam on 28/04/2025.
//

import Foundation

class GetJSONData {
  
    let urlString = "https://api.coinranking.com/v2/coins"
    
    var coinArray:[Coin] = []
    
    func getData(completion : @escaping () -> () ){
        
        //Valid URL
        
        guard let url  = URL(string: urlString)else{
            print("URL is invalid. Try again.")
            completion()
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url){data, response, error in
            if error != nil{
                print("There was an error, Try again!")
                
            }
            
            do{
                
                let decodedData = try JSONDecoder().decode(Root.self, from: data!)
                print(decodedData)
                self.coinArray += decodedData.data.coins
            }catch{
                print("There was an error decoding the file")
            }
            completion()
        }.resume()
        
        
    }
}
