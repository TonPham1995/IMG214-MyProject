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
        
        let url: URL = URL(string: "http://ddragon.leagueoflegends.com/cdn/10.7.1/data/en_US/champion.json")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
       
        NSURLConnection.sendAsynchronousRequest(request, queue: .main) { (response, data, error) in
            
            guard let data = data else {
                print(error)
                return
            }
            
            let responseString: String! = String(data: data, encoding: .utf8)
            
            do {
                
                let jsonDecoder: JSONDecoder = JSONDecoder()
                self.data = try jsonDecoder.decode([ChampionModel].self, from: data)
                
                self.realData = self.data
                self.collectionView.reloadData()
                
            } catch {
                print(error.localizedDescription)
            }
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

