//
//  VegetarianTypeViewController.swift
//  DetailExample
//
//  Created by 박상욱 on 2020/10/04.
//  Copyright © 2020 강민구. All rights reserved.
//

import UIKit



class VegetarianTypeViewController: UITableViewController {

    var selectedCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VegetarianTypeCell", for: indexPath)

        let veget0 = Vegetarian(type: "vegan", description: "비건(vegan) : 적극적인 의미의 채식주의자. 동물성 제품 섭취도 자제할 뿐만 아니라 동물성 재료도 사용하지 않는다. (예 : 가죽, 양모, 오리털 등을 사용하지 않으며 동물실험한 제품도 보이콧) 동물의 알, 유제품을 먹지 않는 것에 더해 동물을 착취해 얻는 꿀도 대체로 먹지 않는다. 팜유, 아보카도, 코코넛 등 동물을 착취할 여지가 있는 부분에까지 범위를 넓혀 비거니즘을 실천하기도 한다. 전시동물을 관람하지 않는 운동 역시 비건 생활의 연장선이다.")
        let veget1 = Vegetarian(type: "fruitarian", description: "프루테리언(Fruitarian) :  식물의 생명과 직접적인 관련이 있는 줄기나 뿌리는 제외하고 열매를 섭취한다. 프루테리언 중에도 자연적으로 저절로 떨어진 열매만을 섭취하는 유형도 있다.")
        let veget2 = Vegetarian(type: "pollo", description: "저는 폴로 별로 안 좋아합니다.")
        let veget3 = Vegetarian(type: "lacto", description: "락토핏")
        let veget4 = Vegetarian(type: "ovo", description: "오보... 이름 귀엽다 오보... 오보...")
        let veget5 = Vegetarian(type: "lacto", description: "달걀을 제외한 유제품까지는 먹는 단계")
        let veget6 = Vegetarian(type: "flexitarian", description: "FLEX해버ㄹ")
        let veget7 = Vegetarian(type: "pesco", description: "채식을 하면서 생선, 달걀, 유제품을 먹는 단계")
        
        vegets.append(veget0)
        vegets.append(veget1)
        vegets.append(veget2)
        vegets.append(veget3)
        vegets.append(veget4)
        vegets.append(veget5)
        vegets.append(veget6)
        vegets.append(veget7)
                
        cell.textLabel?.text = "\(vegets[indexPath.row].type)"
        
        selectedCell = indexPath.row


        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let cell = sender as? UITableViewCell {
            if let index = tableView.indexPath(for: cell){
                
                selectedCell = index.row
            }
        }
        
        
        if let vc = segue.destination as? VegetarianDetailViewController {
            vc.data = vegets[selectedCell].description
        }
    }
}
