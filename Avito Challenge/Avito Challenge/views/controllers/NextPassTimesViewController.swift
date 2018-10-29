//
//  NextPassTimesViewController.swift
//  Avito Challenge
//
//  Created by Safoine Moncef Amine on 29/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import UIKit

class NextPassTimesViewController: UIViewController {
    
    @IBOutlet weak var nextPassTimesTableView: UITableView!
    
    var nextPassTimesDurations : [Int] = [] {
        didSet {
            DispatchQueue.main.async {
                self.nextPassTimesTableView.reloadData()
            }
        }
    }
    var lan : Double?
    var lon : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        ISSApi.shared.nextPassTime(latitude:lan!, longitude: lon!, numberOfPass: 10) { (json) in
            self.nextPassTimesDurations = Parser.nextPassTimes(json: json)
        }
    }
    func configure() {
        self.nextPassTimesTableView.dataSource = self
        self.nextPassTimesTableView.delegate = self
    }
}

extension NextPassTimesViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nextPassTimesDurations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let durationInMinsandSeconds = calculateDurationInMinAndSec(durationInSec: nextPassTimesDurations[indexPath.row])
        cell!.textLabel?.text = "after \(durationInMinsandSeconds)"
        return cell!
    }
    private func calculateDurationInMinAndSec(durationInSec:Int) -> String{
        let mins = durationInSec / 60
        let seconds = durationInSec % 60
        return "\(mins) mins and \(seconds) seconds "
    }
}
