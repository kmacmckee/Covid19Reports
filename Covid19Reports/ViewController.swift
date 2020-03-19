//
//  ViewController.swift
//  Covid19Reports
//
//  Created by Kobe McKee on 3/17/20.
//  Copyright © 2020 Kobe McKee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    let dataController = DataController()
    var displayedData: [DataSet]?
    
    var confirmedCases: [DataSet]? {
        didSet {
            updateViews()
        }
    }
    
    var fatalCases: [DataSet]? {
        didSet {
            updateViews()
        }
    }
    
    var recoveredCases: [DataSet]? {
        didSet {
            updateViews()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.dataSource = self
        
        dataController.fetchConfirmedCases { (data, error) in
            if let error = error {
                NSLog("Error fetching confirmed cases: \(error)")
                return
            }
            self.displayedData = data
            self.confirmedCases = data
        }
        
    }

    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedData?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)
        
        guard let cases = displayedData else { return UITableViewCell() }
        let report = cases[indexPath.row]
        if report.state != nil && report.state != "" {
            cell.textLabel!.text = "\(report.state!), \(report.country)"
        } else {
            cell.textLabel!.text = report.country
        }
        
        if let latestReport = report.dailyCounts.last {
            let count = latestReport.count
            cell.detailTextLabel!.text = count
        } else {
            cell.detailTextLabel!.text = "n/a"
        }
        
        return cell
    }
    
    @IBAction func segmentDidChange(_ sender: Any) {
        
        switch categorySegmentedControl.selectedSegmentIndex {
        case 0:
            if confirmedCases == nil {
                dataController.fetchConfirmedCases { (data, error) in
                    if let error = error {
                        NSLog("Error fetching confirmed cases: \(error)")
                        return
                    }
                    self.displayedData = data
                    self.confirmedCases = data
                }
            } else {
                self.displayedData = self.confirmedCases
                self.updateViews()
            }
        case 1:
            if fatalCases == nil {
                dataController.fetchFatalCases { (data, error) in
                    if let error = error {
                        NSLog("Error fetching fatal cases: \(error)")
                        return
                    }
                    self.displayedData = data
                    self.fatalCases = data
                }
            } else {
                self.displayedData = self.fatalCases
                self.updateViews()
            }
        case 2:
            if recoveredCases == nil {
                dataController.fetchRecoveredCases { (data, error) in
                    if let error = error {
                        NSLog("Error fetching recovered cases: \(error)")
                        return
                    }
                    self.displayedData = data
                    self.recoveredCases = data
                }
            } else {
                self.displayedData = self.recoveredCases
                self.updateViews()
            }
        default:
            return
        }
    }
    
    
}

