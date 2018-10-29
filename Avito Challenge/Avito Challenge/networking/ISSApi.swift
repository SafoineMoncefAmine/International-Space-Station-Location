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
    let GET_ISS_NEXT_PASSES_BASE_URL = "http://api.open-notify.org/iss-pass.json"
    
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
    
    func nextPassTime(latitude:Double, longitude:Double, numberOfPass: Int , completion : @escaping ([String : Any]) -> Void) {
        
        guard let configurePassTimesURL = configureNextPassesURL(parameters:["lat":latitude,"lon":longitude,"n":"\(numberOfPass)"]) else {
            return
        }
        let request = URLRequest(url: configurePassTimesURL)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as? [String: Any]
                completion(json! ?? [:])
            }
        }
        task.resume()
    }
    
    private func configureNextPassesURL(parameters:[String:Any]) -> URL?  {
        let request = GET_ISS_NEXT_PASSES_BASE_URL + "?lat=\(parameters["lat"]!)&lon=\(parameters["lon"]!)&n=\(parameters["n"]!)"
        return URL(string:request)
    }
}
