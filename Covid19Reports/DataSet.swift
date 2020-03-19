//
//  DataSet.swift
//  Covid19Reports
//
//  Created by Kobe McKee on 3/17/20.
//  Copyright © 2020 Kobe McKee. All rights reserved.
//

import Foundation

struct DataSet {
    
    var state: String?
    var country: String
    var lat: String
    var long: String
    var dailyCounts: [DailyCount]
}
