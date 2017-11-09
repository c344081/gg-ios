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

class GGRequest {
    
    let baseUrl = ""
    
    /// 路径
    let path = ""
    
    /// 请求方式
    let method: GGRequestMethod = .get
   
    /// 参数
    var parameters: [String : Any]?
    
    /// 用于服务器校验的通用参数
    var verifyArgument: [String : Any]?
    
    var customHTTPHeaderFields: [String: String]?
    
    var customUrlRequest: URLRequest?
    
    var manager: Alamofire.SessionManager?
    
    var timeoutInterval: TimeInterval?
    
    var requestType: GGRequestType {
        return .Data
    }
    
    init(timeoutInterval: TimeInterval) {
        self.timeoutInterval = timeoutInterval
    }
    
    deinit {
        self.cancel()
    }
    
    public func start() -> Self {
        return self
    }
    
    func cancel() {
        
    }
}

extension GGRequest: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let customHTTPHeaderFields = customHTTPHeaderFields, customHTTPHeaderFields.count > 0 {
            for (field, value) in customHTTPHeaderFields {
                urlRequest.setValue(value, forHTTPHeaderField: field)
            }
        }
        return urlRequest
    }
    
}

class GGDownloadRequest: GGRequest {
    override var requestType: GGRequestType {
        return .Download
    }
}

class GGUploadRequest: GGRequest {
    override var requestType: GGRequestType {
        return .Upload
    }
}

class GGStreamRequest: GGRequest {
    override var requestType: GGRequestType {
        return .Stream
    }
}
