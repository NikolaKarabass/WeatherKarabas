//
//  APIManager.swift
//  WeatherKarabas
//
//  Created by Admin on 11/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation


// for func JSONTaskWith(request: URLRequest, completionHandler: ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask
typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void

protocol JSONDecodable {
    init?(JSON: [String: AnyObject])
}

protocol FinalURLPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

// for func fetch<T>(request: URLRequest, parse: ([String: AnyObject]) -> T?, completionHandler: )
enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
    
    //    init(sessionConfiguration: URLSessionConfiguration)
}

extension APIManager {
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: SWINetworkingErrorDomain, code: 100, userInfo: userInfo)
                
                completionHandler(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    print("-3-")
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        print("-4-")
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError{
                        print("-5-")
                        completionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("-555-")
                    print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async(execute: {
                guard let json = json else {
                    if let error = error {
                        print("-6-")
                        completionHandler(.Failure(error))
                    }
                    return
                }
                
                if let value = parse(json) {
                    print("-7-")
                    completionHandler(.Success(value))
                } else {
                    let error = NSError(domain: SWINetworkingErrorDomain, code: 200, userInfo: nil)
                    print("-8-")
                    print("---")
                    completionHandler(.Failure(error))
                }
                
            })
        }
        dataTask.resume()
    }
}

