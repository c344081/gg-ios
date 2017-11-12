////
////  APIProxy.swift
////  gg-iOS
////
////  Created by zoxuner on 2017/11/9.
////  Copyright © 2017年 c344081. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//class APIProxy {
//    
//    let semaphore = DispatchSemaphore(value: 1)
//    
//    static var shared: APIProxy  = {
//        return APIProxy()
//    }()
//    
//    public func start<T: GGRequestible>(_ request: T, responseQueue: DispatchQueue) where T: NSObjectProtocol {
//        let manager = self.config(request:request)
//        
//        let url = URL(string: request.path, relativeTo: URL(string: request.baseUrl)!)!
//        
//        var argumentsM = [String: Any]()
//        
//        // verify arguments
//        if let verifyArguments = request.verifyArgument, verifyArguments.count > 0 {
//            verifyArguments.forEach { argumentsM[$0] = $1 }
//        }
//        
//        // query arguments
//        if let parameters = request.parameters, parameters.count > 0  {
//            parameters.forEach { argumentsM[$0] = $1 }
//        }
//        
//        var internalRequest: Alamofire.Request!
//        switch request.requestType {
//        case .Data:
//            internalRequest = manager.request(url, method: request.method, parameters: argumentsM, headers: request.customHTTPHeaderFields)
//            
//            manager.request(<#T##urlRequest: URLRequestConvertible##URLRequestConvertible#>)
//            
//        case .Download:
//            internalRequest = manager.download(url, headers: request.customHTTPHeaderFields)
//        case .Upload:
//            internalRequest = manager.upload(Data(), to: url, headers: request.customHTTPHeaderFields)
//        case .Stream:
//            fatalError("暂未支持")
//        }
//        
//        // start request
//        internalRequest.resume()
//        
//        // response
//        let completionHandler: (DefaultDataResponse) -> Void = { [weak request] (dataResponse) in
//            if var request = request, let completion = request.completion {
////                completion(dataResponse)
////                request.completion = nil
////                map to GGResponse
//                //            switch request.responseType {
//                //            case .RawData:
//                //
//                //            case .JSON:
//                //
//                //            }
//            }
//        }
//        
//        switch request.requestType {
//        case .Data, .Upload, .Stream:
//            let dataRequest = internalRequest as! DataRequest
//            dataRequest.response(queue: responseQueue, completionHandler: completionHandler)
//        case .Download:
//            let downloadRequest = internalRequest as! DownloadRequest
//            DefaultDownloadResponse
//            downloadRequest.response(queue: <#T##DispatchQueue?#>, completionHandler: <#T##(DefaultDownloadResponse) -> Void#>)
//        }
//    }
//    
//    func config<T: GGRequestible>(request: T) -> Alamofire.SessionManager {
//        var request = request
//        var manager = request.manager
//        if manager == nil {
//            let config = URLSessionConfiguration.default
//            config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
//            if request.timeoutInterval > 0 {
//                config.timeoutIntervalForRequest = request.timeoutInterval
//            }
//            manager = Alamofire.SessionManager(configuration: config)
//            manager?.startRequestsImmediately = false
//            request.manager = manager
//        }
//        return manager!
//    }
//    
//}
//
//class Adapter: Alamofire.RequestAdapter {
//    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
//        return urlRequest
//    }
//}
//
