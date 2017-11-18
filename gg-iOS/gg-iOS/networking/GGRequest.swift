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

protocol GGRequestTypeable {
    /// 包含的数据类型
    associatedtype DataType
    
    /// 发起请求的泛型版
    ///
    /// - Parameters:
    ///   - queue: 响应的队列
    ///   - completion: 完成后的回调
    func startRequest(queue: DispatchQueue?, with completion: @escaping (Error?, DataType?) -> Void)
}

protocol GGRequestConvertible {
    
    var baseUrl: String { get }
    var path: String { get }
    var method: GGRequestMethod { get }
    var parameters: [String : Any]? { get }
    var verifyArgument: [String : Any]? { get }
    var customHTTPHeaderFields: [String: String]? { get }
    var timeoutInterval: TimeInterval { get set }
    var customurlRequest: URLRequest? { get }
}

protocol GGRequestable {
    var manager: Alamofire.SessionManager? { get set }
    var internalRequest: Alamofire.Request? { get set }
    
    func start<T>(queue: DispatchQueue?, responseSerializer: T, completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void) where T: DataResponseSerializerProtocol
    
    /// 取消请求
    func cancel()
}

extension GGRequestable {
    func start<T>(queue: DispatchQueue?, responseSerializer: T, completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void) where T: DataResponseSerializerProtocol {
        fatalError("请实现相应方法后调用:\(#function)")
    }
}

class GGRequest: GGRequestConvertible, GGRequestable {
    
    var baseUrl: String {
        return ""
    }
    /// 路径
    var path: String {
        return ""
    }
    /// 请求方式
    var method: GGRequestMethod {
        return .get
    }
    /// 参数
    var parameters: [String: Any]? {
        return nil
    }
    /// 用于服务器校验的通用参数
    var verifyArgument: [String: Any]? {
        return nil
    }
    /// 自定义的HTTP头部
    var customHTTPHeaderFields: [String: String]? {
        return nil
    }
    /// 自定义的请求
    var customurlRequest: URLRequest? {
        return nil
    }
    /// 请求的超时时间, 默认为60
    var timeoutInterval: TimeInterval
    /// urlsession 管理对象
    var manager: Alamofire.SessionManager?
    /// Alamofire中的请求对象
    var internalRequest: Request?
    /// 用于避免提前结束时的回调
    fileprivate var sentinel: OSAtomic_int64_aligned64_t = 0
    
    init(timeoutInterval: TimeInterval = 60) {
        self.timeoutInterval = timeoutInterval
    }
    
    deinit {
        cancel()
    }
    
    func cancel() {
        // increase
        OSAtomicIncrement64(&sentinel)
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
    
    func start<T>(
        queue: DispatchQueue? = nil,
        responseSerializer: T,
        completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void)
        where T: DataResponseSerializerProtocol
    {
        // increase first
        OSAtomicIncrement64(&sentinel)
        let currentValue = self.sentinel
        let canceledClosure: () -> Bool = { [weak self] () -> Bool in
            var canceled = true
            if let strongSelf = self {
                canceled = strongSelf.sentinel != currentValue
            }
            return canceled
        }
        
        APIProxy.shared.start(
            request: self,
            responseQueue: queue,
            responseSerializer: responseSerializer,
            completionHandler: completionHandler,
            canceled: canceledClosure)
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
    
}
