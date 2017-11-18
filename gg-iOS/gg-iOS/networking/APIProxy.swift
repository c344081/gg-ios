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
    
    let semaphore = DispatchSemaphore(value: 1)
    
    static var shared: APIProxy  = {
        return APIProxy()
    }()
    
    public func start<S, R>(
        request: R,
        responseQueue: DispatchQueue?,
        responseSerializer: S,
        completionHandler: @escaping (DataResponse<S.SerializedObject>) -> Void,
        canceled: @escaping () -> Bool)
        where R: GGRequestable & GGRequestConvertible, S: DataResponseSerializerProtocol
    {
        if canceled() { return }
        guard let manager = self.config(request) else { return }
        
        var dataRequest: DataRequest?
        if let customUrlRequest = request.customurlRequest {
            dataRequest = manager.request(customUrlRequest)
        } else {
            let url = URL(string: request.path, relativeTo: URL(string: request.baseUrl)!)!
            
            var argumentsM = [String: Any]()
            
            // verify arguments
            if let verifyArguments = request.verifyArgument, verifyArguments.count > 0 {
                verifyArguments.forEach { argumentsM[$0] = $1 }
            }
            
            // query arguments
            if let parameters = request.parameters, parameters.count > 0  {
                parameters.forEach { argumentsM[$0] = $1 }
            }
            dataRequest = manager.request(url, method: request.method, parameters: request.parameters, headers: request.customHTTPHeaderFields)
        }
        
        // startRequestsImmediately and response
        dataRequest?.response(queue: responseQueue, responseSerializer: responseSerializer) { (responseObject) in
            if canceled() { return }
            completionHandler(responseObject)
        }
       
    }
    
    func config<T: GGRequestable & GGRequestConvertible>(_ request: T) -> Alamofire.SessionManager? {
        var request = request
        var manager = request.manager
        if manager == nil {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            if request.timeoutInterval > 0 {
                config.timeoutIntervalForRequest = request.timeoutInterval
            }
            manager = Alamofire.SessionManager(configuration: config)
            request.manager = manager
        }
        return manager
    }
    
}

class Adapter: Alamofire.RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return urlRequest
    }
}


