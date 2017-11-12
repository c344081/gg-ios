//
//  GGRequest.swift
//  gg-iOS
//
//  Created by chenhao on 2017/11/4.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit
import Alamofire

/// 请求方法
typealias GGRequestMethod = Alamofire.HTTPMethod

enum GGRequestType {
    case Data
    case Download
    case Upload
    case Stream
}

enum GGResponseSerializerType {
    case RawData
    case JSON
}

protocol GGRequestible {
    
    associatedtype ResponseItem

    var baseUrl: String { get }
    var path: String { get }
    var method: GGRequestMethod { get }
    var parameters: [String : Any]? { get }
    var verifyArgument: [String : Any]? { get }
    var customHTTPHeaderFields: [String: String]? { get }
    var timeoutInterval: TimeInterval { get set }

    var urlRequest: URLRequest? { get }
    var dataTask: URLSessionTask? { get }
    var requestType: GGRequestType { get }
    var responseType: GGResponseSerializerType { get }
    var manager: Alamofire.SessionManager? { get set }
    /// 完成后的回调
    var completion: ((ResponseItem) -> Void)? { get set }
    
    mutating func config(request: Self) -> Alamofire.SessionManager
    
    func start(validators: [Any]?, responseQueue: DispatchQueue, completion: @escaping (_ response: ResponseItem) -> Void)
    
}

extension GGRequestible {
    var baseUrl: String {
        return ""
    }
    var path: String {
        return ""
    }
    var method: GGRequestMethod {
        return .get
    }
    var parameters: [String: Any]? {
        return nil
    }
    var verifyArgument: [String: Any]? {
        return nil
    }
    var customHTTPHeaderFields: [String: String]? {
        return nil
    }

    var urlRequest: URLRequest? {
        return nil
    }
    var dataTask: URLSessionTask? {
        return nil
    }
}


class GGRequest<Value>: GGRequestible {
    
    typealias GGNetworkCompletion = (DataResponse<Value>) -> Void
  
    var timeoutInterval: TimeInterval = 60
    
    var manager: Alamofire.SessionManager?
    /// Alamofire用于链式调用的request对象
    var dataRequest: DataRequest?

    /// 完成后的回调
    var completion: GGNetworkCompletion?

    /// 对status code等进行额外校验
    var validators: [Any]?

    var requestType: GGRequestType {
        return .Data
    }

    var responseType: GGResponseSerializerType {
        return .JSON
    }

    init(timeoutInterval: TimeInterval) {
        if timeoutInterval > 0 {
            self.timeoutInterval = timeoutInterval
        }
    }

    deinit {
        self.cancel()
    }
    
    func config(request: GGRequest<Value>) -> SessionManager {
        var manager = request.manager
        if manager == nil {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            if request.timeoutInterval > 0 {
                config.timeoutIntervalForRequest = request.timeoutInterval
            }
            manager = Alamofire.SessionManager(configuration: config)
            manager?.startRequestsImmediately = false
            request.manager = manager
        }
        return manager!
    }

    public func start(validators: [Any]? = nil, responseQueue: DispatchQueue = .main, completion: @escaping GGNetworkCompletion) {
        self.completion = completion
        self.validators = validators
//        APIProxy.shared.start(self, responseQueue: responseQueue)
    }
    
    public func cancel() {
        // 移除回调
        self.completion = nil
        self.cancelTask()
    }
    
    fileprivate func cancelTask() {
        if let dataTask = dataTask,
            dataTask.state != .canceling,
            dataTask.state != .completed {
            dataTask.cancel()
        }
    }

}

class GGDataRequest: GGRequest<Data> {
    override var requestType: GGRequestType {
        return .Data
    }
    override var responseType: GGResponseSerializerType {
        return .RawData
    }
}

///// 下载请求
///// - Note: 没写完
//class GGDownloadRequest: GGRequest {
//    override var requestType: GGRequestType {
//        return .Download
//    }
//    override var responseType: GGResponseSerializerType {
//        return .RawData
//    }
//}
//
///// 上传请求
///// - Note: 没写完
//class GGUploadRequest: GGRequest {
//    override var requestType: GGRequestType {
//        return .Upload
//    }
//    override var responseType: GGResponseSerializerType {
//        return .RawData
//    }
//}
//
///// stream请求
///// - Note: 没写完
//class GGStreamRequest: GGRequest {
//    override var requestType: GGRequestType {
//        return .Stream
//    }
//    override var responseType: GGResponseSerializerType {
//        return .RawData
//    }
//}

