//
//  ISSApi.swift
//  Avito Challenge
//
//  Created by Safoine Moncef Amine on 27/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import Foundation

class ISSApi {
    
    private init() {}
    static let shared : ISSApi = ISSApi()
    
    func getCurrentISSLocation(completion : @escaping (String, String) -> Void) {
        let urlString = "http://api.open-notify.org/iss-now.json"
        guard let requestUrl = URL(string:urlString) else { return }
        let request = URLRequest(url:requestUrl)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                guard let dictionary = json as? [String: Any] else{
                    return
                }
                guard let coordonates = dictionary["iss_position"] as? [String: Any] else{
                    return
                }
                
                completion(coordonates["latitude"]! as! String,coordonates["longitude"]! as! String)
            }
            
        }
        task.resume()
    }
    
    
    func actualPassengers(completion : @escaping ([String]) -> Void) {
        let urlString = "http://api.open-notify.org/astros.json"
        guard let requestUrl = URL(string:urlString) else { return }
        let request = URLRequest(url:requestUrl)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                guard let dictionary = json as? [String: Any] else{
                    return
                }
               
                let passengers = dictionary["people"] as! NSArray
                var passengerNames : [String] = []
                for passenger  in passengers {
                    let passengerDict = passenger as? [String: String]
                    let passengerName = passengerDict!["name"]
                    passengerNames.append(passengerName!)
                }
                completion(passengerNames)
            }
        }
        task.resume()
    }
}
