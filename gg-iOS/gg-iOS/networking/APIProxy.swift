//
//  APIProxy.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/11/9.
//  Copyright © 2017年 c344081. All rights reserved.
//

import Foundation
import Alamofire


class APIProxy {
    
    lazy var requestCache = [String: Alamofire.Request]()
    
    let semaphore = DispatchSemaphore(value: 1)
    
    static var shared: APIProxy  = {
        return APIProxy()
    }()
    
    public func start(request: GGRequest) -> GGRequest {
        let manager = self.config(request:request)
        
        let url = URL(string: request.path, relativeTo: URL(string: request.baseUrl)!)!
        
        var argumentsM = [String: Any]()
        
        // verify arguments
        if let verfyArguments = request.verifyArgument, verfyArguments.count > 0 {
            verfyArguments.forEach { argumentsM[$0] = $1 }
        }
        
        // query arguments
        if let parameters = request.parameters, parameters.count > 0  {
            parameters.forEach { argumentsM[$0] = $1 }
        }
        
        var internalRequest: Alamofire.Request?
        switch request.requestType {
        case .Data:
            internalRequest = manager.request(url, method: request.method, parameters: argumentsM, headers: request.customHTTPHeaderFields)
        case .Download:
            internalRequest = nil
        case .Upload:
            internalRequest = nil
        case .Stream:
            internalRequest = nil
        default:
            fatalError("unknown request type")
        }
        
        self.addRequest(internalRequest!)
        
        return request
    }
    
    func config(request: GGRequest) -> Alamofire.SessionManager {
        var manager = request.manager
        if manager == nil {
            let config = URLSessionConfiguration()
            if let timeoutInterval = request.timeoutInterval, timeoutInterval > 0 {
                config.timeoutIntervalForRequest = timeoutInterval
            }
            manager = Alamofire.SessionManager(configuration: config)
            manager!.adapter = Adapter()
            request.manager = manager
        }
        return manager!
    }
    
    func hashKey(for task: Alamofire.Request) -> String {
        return ""
    }
    
    func addRequest(_ request: Alamofire.Request) {
        
    }
    
}

class Adapter: Alamofire.RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return urlRequest
    }
}
