//
//  DataController.swift
//  Covid19Reports
//
//  Created by Kobe McKee on 3/17/20.
//  Copyright © 2020 Kobe McKee. All rights reserved.
//

import Foundation


class DataController {
    
    private let confirmedCasesURL = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")!
    
    private let fataCasesURL = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv")!
    
    private let recoveredCasesURL = URL(string: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv")!
    
    
    
    func fetchConfirmedCases(completion: @escaping ([DataSet]?, Error?) -> Void) {
        
        URLSession.shared.dataTask(with: confirmedCasesURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching confirmed cases: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned when fetching confirmed cases")
                completion(nil, NSError())
                return
            }
            
            let results = self.parseCSVData(data: data)
            completion(results, nil)
            return
        }.resume()
    }
    
    
    func fetchFatalCases(completion: @escaping ([DataSet]?, Error?) -> Void) {
        
        URLSession.shared.dataTask(with: fataCasesURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching fatal cases: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned when fetching fata cases")
                completion(nil, NSError())
                return
            }
            
            let results = self.parseCSVData(data: data)
            completion(results, nil)
            return
        }.resume()
        
        
        
    }
    
    func fetchRecoveredCases(completion: @escaping ([DataSet]?, Error?) -> Void) {
     
        URLSession.shared.dataTask(with: recoveredCasesURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching recovered cases: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned when fetching recovered cases")
                completion(nil, NSError())
                return
            }
            
            let results = self.parseCSVData(data: data)
            completion(results, nil)
            return
        }.resume()
    }
    
    
    func parseCSVData(data: Data) -> [DataSet]? {
        guard let csvData = String(bytes: data, encoding: .utf8) else { return nil }
        var results = csvData.components(separatedBy: "\n")
        
        guard let keywords = results.first else { return nil }
        var dates = keywords.components(separatedBy: ",")
        dates.removeFirst(4) //removing state, country, lat and long from dates
        
        results.removeFirst() //removing the keywords from results
        
        for i in 0...results.count-1 {
            var country = results[i]
            if country.components(separatedBy: ",").count > (results.first?.components(separatedBy: ",").count)! {
                country.remove(at: country.firstIndex(of: ",")!)
            }
            results[i] = country
        }
        
        let areas = results.map { $0.components(separatedBy: ",") }
        
        var coronaResults: [DataSet] = []
        
        for area in areas {
            let state = area[0]
            let country = area[1]
            let lat = area[2]
            let long = area[3]
            var reports = area
            reports.removeFirst(4)
            
            var dailyDictionary: [String : String] = [:]
            
            for (index, date) in dates.enumerated() {
                dailyDictionary[date] = reports[index]
            }
            
            coronaResults.append(DataSet(state: state, country: country, lat: lat, long: long, reportsDictionary: dailyDictionary))
        }
        return coronaResults
    }
    
    
    
    
}
