//
//  GGRequest.swift
//  gg-iOS
//
//  Created by chenhao on 2017/11/4.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

/// 请求方法
typealias GGRequestMethod = Alamofire.HTTPMethod

protocol GGRequestConvertible {
    
    var baseUrl: String { get }
    var path: String { get }
    var method: GGRequestMethod { get }
    var parameters: [String : Any]? { get }
    var verifyArgument: [String : Any]? { get }
    var customHTTPHeaderFields: [String: String]? { get }
    var timeoutInterval: TimeInterval { get set }

    var urlRequest: URLRequest? { get }
}

protocol GGRequestable {
    var manager: Alamofire.SessionManager? { get set }
    var dataTask: URLSessionTask? { get set }
    var internalRequest: Alamofire.Request? { get set }
    
    func start<T: DataResponseSerializerProtocol>(queue: DispatchQueue?, responseSerializer: T, completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void)
    
    func cancel()
}

class GGRequest: GGRequestConvertible, GGRequestable {
    
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
    
    var timeoutInterval: TimeInterval
    
    var manager: Alamofire.SessionManager?
    
    var dataTask: URLSessionTask?
    
    var internalRequest: Request?
    
    init(timeoutInterval: TimeInterval = 60) {
        self.timeoutInterval = timeoutInterval
    }
    
    deinit {
        print(".....")
    }
    
    func start<T: DataResponseSerializerProtocol>(queue: DispatchQueue? = nil, responseSerializer: T, completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void) {
        APIProxy.shared.start(request: self, responseQueue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    func cancel() {
        internalRequest?.cancel()
    }
}

class GGDataRequest: GGRequest {
    
    private var dataRequest: Alamofire.DataRequest?
    override var internalRequest: Alamofire.Request? {
        set {
            dataRequest = newValue as? Alamofire.DataRequest
        }
        get {
            return dataRequest
        }
    }
    
}

class GGDownloadRequest: GGRequest {
    
    private var downloadRequest: Alamofire.DownloadRequest?
    override var internalRequest: Alamofire.Request? {
        set {
            downloadRequest = newValue as? Alamofire.DownloadRequest
        }
        get {
            return downloadRequest
        }
    }
    
//    func request() -> Alamofire.DownloadRequest? {
//        return APIProxy.shared.start(request: self, responseQueue: DispatchQueue.main)
//    }

}

class GGUploadRequest: GGDataRequest {
    
    override var method: GGRequestMethod {
        return .post
    }
    
    var uploadRequest: Alamofire.UploadRequest?
    override var internalRequest: Alamofire.Request? {
        set {
            uploadRequest = newValue as? Alamofire.UploadRequest
        }
        get {
            return uploadRequest
        }
    }
    
//    override func request() -> Alamofire.UploadRequest? {
//        return APIProxy.shared.start(request: self, responseQueue: DispatchQueue.main)
//    }
//
}

@available(iOS 9.0, *)
class GGStreamRequest: GGDataRequest {
    typealias RequestItem = StreamRequest
    override var method: GGRequestMethod {
        return .get
    }
    
    var streamRequest: Alamofire.StreamRequest?
    override var internalRequest: Alamofire.Request? {
        set {
            streamRequest = newValue as? Alamofire.StreamRequest
        }
        get {
            return streamRequest
        }
    }
    
//    override func request() -> Alamofire.StreamRequest? {
//        return APIProxy.shared.start(request: self, responseQueue: DispatchQueue.main)
//    }

}
