//
//  PassengerListViewController.swift
//  Avito Challenge
//
//  Created by Safoine Moncef Amine on 27/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import UIKit

class PassengerListViewController: UIViewController {


    @IBOutlet weak var passengersTableView: UITableView!
    
    var passengers : [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.passengersTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        ISSApi.shared.actualPassengers { (json) in
            self.passengers = Parser.parsePassengers(json: json)
        }
    }
    func configure() {
        self.passengersTableView.dataSource = self
        self.passengersTableView.delegate = self
    }
}

extension PassengerListViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell!.textLabel?.text = passengers[indexPath.row]
        return cell!
    }
}
