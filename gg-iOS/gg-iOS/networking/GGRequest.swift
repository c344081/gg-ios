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

class GGRequest {
    
    func baseUrl() -> String { return "" }
    /// 路径
    func path() -> String { return "" }
    /// 请求方式
    func method() -> GGRequestMethod { return .get }
    /// 参数
    func parameters() -> [String : Any]? { return nil }
    /// 用于服务器校验的通用参数
    func verifyArgument() -> [String : Any]? { return nil }
    /// 自定义的Http头部
    func customHTTPHeaderFields() -> [String: String]? { return nil }
    /// 使用自定义的`URLRequest`
    func customUrlRequest() -> URLRequest? { return nil }
    /// 超时时间
    var timeoutInterval: TimeInterval?
    
    var manager: Alamofire.SessionManager?
    
    var dataTask: URLSessionTask?
    
    // 完成后的回调
    var completion: ((Any) -> Void)?
    
    // 对status code等进行额外校验
    var validators: [Any]?
    
    /// Alamofire用于链式调用的request对象
    fileprivate var dataRequest: DataRequest?
    
    var requestType: GGRequestType {
        return .Data
    }
    
    var responseType: GGResponseSerializerType {
        return .JSON
    }
    
    init(timeoutInterval: TimeInterval? = nil) {
        self.timeoutInterval = timeoutInterval
    }
    
    deinit {
        self.cancel()
    }
    
    public func start(validators: [Any]? = nil, responseQueue: DispatchQueue = .main, completion: @escaping (_ response: Any) -> Void) {
        self.completion = completion
        self.validators = validators
        APIProxy.shared.start(self, responseQueue: responseQueue)
    }
    
    public func cancel() {
        // 移除回调
        self.completion = nil
        self.cancelTask()
    }
    
    fileprivate func cancelTask() {
        if let dataTask = dataRequest?.task,
            dataTask.state != .canceling,
            dataTask.state != .completed {
            dataTask.cancel()
        }
    }
    
    fileprivate func config(_ request: GGRequest) -> Alamofire.SessionManager {
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
}


/// 下载请求
/// - Note: 没写完
class GGDownloadRequest: GGRequest {
    override var requestType: GGRequestType {
        return .Download
    }
    override var responseType: GGResponseSerializerType {
        return .RawData
    }
}

/// 上传请求
/// - Note: 没写完
class GGUploadRequest: GGRequest {
    override var requestType: GGRequestType {
        return .Upload
    }
    override var responseType: GGResponseSerializerType {
        return .RawData
    }
}

/// stream请求
/// - Note: 没写完
class GGStreamRequest: GGRequest {
    override var requestType: GGRequestType {
        return .Stream
    }
    override var responseType: GGResponseSerializerType {
        return .RawData
    }
}
