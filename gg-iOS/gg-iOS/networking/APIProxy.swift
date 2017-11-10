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
    
    public func start(_ request: GGRequest, responseQueue: DispatchQueue) {
        let manager = self.config(request:request)
        
        let url = URL(string: request.path(), relativeTo: URL(string: request.baseUrl())!)!
        
        var argumentsM = [String: Any]()
        
        // verify arguments
        if let verifyArguments = request.verifyArgument(), verifyArguments.count > 0 {
            verifyArguments.forEach { argumentsM[$0] = $1 }
        }
        
        // query arguments
        if let parameters = request.parameters(), parameters.count > 0  {
            parameters.forEach { argumentsM[$0] = $1 }
        }
        
        var internalRequest: Alamofire.Request!
        switch request.requestType {
        case .Data:
            internalRequest = manager.request(url, method: request.method(), parameters: argumentsM, headers: request.customHTTPHeaderFields())
        case .Download:
            internalRequest = manager.download(url, headers: request.customHTTPHeaderFields())
        case .Upload:
            internalRequest = manager.upload(Data(), to: url, headers: request.customHTTPHeaderFields())
        case .Stream:
            fatalError("暂未支持")
        }
        
        // start request
        internalRequest.resume()
        
        // response
        let completionHandler: (Any) -> Void = { [unowned request] (dataResponse) in
            if let completion = request.completion {
                completion(dataResponse)
                request.completion = nil
            }
        }
        switch request.requestType {
            
            
        case .Data, .Upload, .Stream:
            let dataRequest = internalRequest as! DataRequest
            switch request.responseType {
            case .RawData:
                dataRequest.responseData(queue: responseQueue, completionHandler: completionHandler)
            case .JSON:
                dataRequest.responseJSON(queue: responseQueue, options: .mutableContainers, completionHandler: completionHandler)
            }
        case .Download:
            let downloadRequest = internalRequest as! DownloadRequest
            switch request.responseType {
            case .RawData:
                downloadRequest.responseData(queue: responseQueue, completionHandler: completionHandler)
            case .JSON:
                downloadRequest.responseJSON(queue: responseQueue, options: .mutableContainers, completionHandler: completionHandler)
            }
        }
    }
    
    func config(request: GGRequest) -> Alamofire.SessionManager {
        var manager = request.manager
        if manager == nil {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            if let timeoutInterval = request.timeoutInterval, timeoutInterval > 0 {
                config.timeoutIntervalForRequest = timeoutInterval
            }
            manager = Alamofire.SessionManager(configuration: config)
            manager?.startRequestsImmediately = false
            request.manager = manager
        }
        return manager!
    }
    
}

class Adapter: Alamofire.RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return urlRequest
    }
}
