//
//  VegetarianTypeViewController.swift
//  DetailExample
//
//  Created by 박상욱 on 2020/10/04.
//  Copyright © 2020 강민구. All rights reserved.
//

import UIKit

class VegetarianTypeViewController: UITableViewController {
    
    let types = [
        VegetarianTypeModel(type: "vegan", description: "this is vegan"),
        VegetarianTypeModel(type: "fruitarian", description: "this is fruitarian"),
        VegetarianTypeModel(type: "pollo", description: "this is pollo"),
        VegetarianTypeModel(type: "lacto", description: "this is lacto"),
        VegetarianTypeModel(type: "ovo", description: "this is ovo"),
        VegetarianTypeModel(type: "lacto-ovo", description: "this is lacto-ovo"),
        VegetarianTypeModel(type: "flexitarian", description: "this is flexitarian"),
        VegetarianTypeModel(type: "pesco", description: "this is pesco")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VegetarianTypeCell", for: indexPath)

        cell.textLabel?.text = types[indexPath.row].type

        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail", let detailVC = segue.destination as? DetailViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                detailVC.list = types[indexPath.row]
            }
            
        }
    }
    

}
