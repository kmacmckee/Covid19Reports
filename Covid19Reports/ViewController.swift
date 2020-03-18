//
//  ViewController.swift
//  Covid19Reports
//
//  Created by Kobe McKee on 3/17/20.
//  Copyright © 2020 Kobe McKee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    let dataController = DataController()
    
    var confirmedCases: [DataSet]? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }

    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return confirmedCases?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)
        
        guard let cases = confirmedCases else { return UITableViewCell() }
        let report = cases[indexPath.row]
        if report.state != nil && report.state != "" {
            cell.textLabel!.text = "\(report.state!), \(report.country)"
        } else {
            cell.textLabel!.text = report.country
        }
        
        var currentCount = ""
        if let todaysCount = report.reportsDictionary[Date()] {
            currentCount = todaysCount
        } else {
            
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            
            currentCount = report.reportsDictionary[yesterday] ?? ""
        }
        
        cell.detailTextLabel!.text = currentCount
        
        return cell
    }

    @IBAction func run(_ sender: Any) {
        dataController.fetchConfirmedCases { (data, error) in
            self.confirmedCases = data
        }
    }
}

