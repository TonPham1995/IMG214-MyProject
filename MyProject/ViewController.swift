//
//  ViewController.swift
//  MyProject
//
//  Created by Townsite Grocery on 2020-03-30.
//  Copyright © 2020 Townsite Grocery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    private var data: [ChampionModel]! = []
    private var realData: [ChampionModel]! = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let url: URL = URL(string: "http://ddragon.leagueoflegends.com/cdn/10.7.1/data/en_US/champion.json")!
//        var request: URLRequest = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        NSURLConnection.sendAsynchronousRequest(request, queue: .main) { (response, data, error) in
//
//            guard let data = data else {
//                print(error)
//                return
//            }
//
//            let responseString: String! = String(data: data, encoding: .utf8)
//
//            do {
//
//                let jsonDecoder: JSONDecoder = JSONDecoder()
//                self.data = try jsonDecoder.decode([ChampionModel].self, from: data)
//
//                self.realData = self.data
//                self.collectionView.reloadData()
//
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
        
        if let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/10.7.1/data/en_US/champion.json") {
                  URLSession.shared.dataTask(with: url) { data, response, error in
                      if let data = data {
                          let dragon = try! JSONDecoder().decode(Dragon.self, from: data)
                           print(dragon)
                      }
                  }.resume()
              }
           }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return self.data.count
      }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let singleCell: SingleCellView = collectionView.dequeueReusableCell(withReuseIdentifier: "singleCell", for: indexPath) as! SingleCellView
      
          singleCell.id.text = self.data[indexPath.item].id
        
          return singleCell
      }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        return searchView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.data.removeAll()
            
        for item in self.realData {
            if (item.id.lowercased().contains(searchBar.text!.lowercased())) {
                self.data.append(item)
            }
        }
            
        if (searchBar.text!.isEmpty) {
            self.data = self.realData
        }
        self.collectionView.reloadData()
    }

}

struct Dragon: Codable {
    var type: String
    var format: String
    var version: String
    var data: Champion
}

struct Champion: Codable {
    var name: String
    var title: String
    var blurb: String
    var key: String
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case aatrox = "Aatrox"
        case alistar = "Alistar"
        case name = "name"
        case title = "title"
        case blurb = "blurb"
        case key = "key"
    }


    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let champion = try container.nestedContainer(keyedBy: CodingKeys.self, forKey:.alistar)
        name = try champion.decode(String.self, forKey: .name)
        title = try champion.decode(String.self, forKey: .title)
        blurb = try champion.decode(String.self, forKey: .blurb)
        key = try champion.decode(String.self, forKey: .key)
        

//        let info = try aatrox.nestedContainer(keyedBy: CodingKeys.self, forKey: .info)
//        attack = try info.decode(String.self, forKey: .attack)
//        defense = try info.decode(String.self, forKey: .defense)
//        magic = try info.decode(String.self, forKey: .magic)
    }
    

    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(title, forKey: .title)
        try container.encode(blurb, forKey: .blurb)
 
    }
}


extension JSONDecoder {

    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyedBy key: String?) throws -> T {
        if let key = key {
            // Pass the top level key to the decoder.
            userInfo[.jsonDecoderRootKeyName] = key

            let root = try decode(DecodableRoot<T>.self, from: data)
            return root.value
        } else {
            return try decode(type, from: data)
        }
    }

}

extension CodingUserInfoKey {

    static let jsonDecoderRootKeyName = CodingUserInfoKey(rawValue: "rootKeyName")!

}

struct DecodableRoot<T>: Decodable where T: Decodable {

    private struct CodingKeys: CodingKey {

        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.intValue = intValue
            stringValue = "\(intValue)"
        }

        static func key(named name: String) -> CodingKeys? {
            return CodingKeys(stringValue: name)
        }

    }

    let value: T

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard
            let keyName = decoder.userInfo[.jsonDecoderRootKeyName] as? String,
            let key = CodingKeys.key(named: keyName) else {
                throw DecodingError.valueNotFound(
                    T.self,
                    DecodingError.Context(codingPath: [], debugDescription: "Value not found at root level.")
                )
        }

        value = try container.decode(T.self, forKey: key)
    }

}

