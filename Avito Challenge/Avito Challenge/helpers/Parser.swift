//
//  Parser.swift
//  Avito Challenge
//
//  Created by Safoine Moncef Amine on 29/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import Foundation

class Parser {
    
    static func parsePassengers(json : [String:Any]) -> [String] {
        let passengers = json["people"] as! NSArray
        var passengerNames : [String] = []
        for passenger  in passengers {
            let passengerDict = passenger as? [String: String]
            let passengerName = passengerDict!["name"]
            passengerNames.append(passengerName!)
        }
        return passengerNames
    }
    
    static func parseIssLocationCoordonate(json : [String:Any]) -> (String,String) {
        guard let coordonates = json["iss_position"] as? [String: Any] else{
            return ("","")
        }
        let issCoordonate = (coordonates["latitude"]!,coordonates["longitude"]!)
        return issCoordonate as! (String, String)
    }
}
