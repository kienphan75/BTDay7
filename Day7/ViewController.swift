//
//  ViewController.swift
//  Day7
//
//  Created by admin on 7/20/18.
//  Copyright © 2018 meosteam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var contacts : [ContactModel]?

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func actionAdd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddViewController") as!  AddViewController
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        DatabaseManager.instanle.coptyToDocument()
        contacts =  DatabaseManager.instanle.getAllContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contacts =  DatabaseManager.instanle.getAllContacts()
        tableView.reloadData()
    }


}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contacts?.count)!
    }
    
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else {
            return UITableViewCell()
        }
        cell.lbName.text = contacts?[indexPath.row].name
        cell.lbContact.text = contacts?[indexPath.row].phone
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

