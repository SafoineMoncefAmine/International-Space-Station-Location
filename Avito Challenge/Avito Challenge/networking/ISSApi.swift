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
    
    let GET_ISS_LOCATION_URL = "http://api.open-notify.org/iss-now.json"
    let GET_ISS_PASSENGER_URL = "http://api.open-notify.org/astros.json"
    
    func getCurrentISSLocation(completion : @escaping ([String :Any]) -> Void) {
        
        guard let requestUrl = URL(string: GET_ISS_LOCATION_URL) else { return }
        let request = URLRequest(url:requestUrl)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as! [String : Any]
                completion(json ?? [:])
            }
        }
        task.resume()
    }
    
    
    func actualPassengers(completion : @escaping ([String : Any]) -> Void) {
        guard let requestUrl = URL(string: GET_ISS_PASSENGER_URL) else { return }
        let request = URLRequest(url:requestUrl)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as? [String: Any]
                completion(json! ?? [:])
            }
        }
        task.resume()
    }
}
