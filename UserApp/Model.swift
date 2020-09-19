//
//  Model.swift
//  UserApp
//
//  Created by Gag Mkrtchyan on 9/11/20.
//  Copyright © 2020 Gag Mkrtchyan. All rights reserved.
//

import Foundation

struct InfoModel {
    var picture : DataModel?
    var name : String
    
}

struct DataModel {
    var height : Int
    var url : URL
    var width : Int
}
