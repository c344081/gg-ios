//
//  GGBaseRequest.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/11/10.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit
import Alamofire

class GGBaseRequest: GGDataRequest {
    
    override var baseUrl: String {
        return "http://www.guanggoo.com/"
    }
    
    public func start(queue: DispatchQueue? = .main, dataCompletion: @escaping (DataResponse<Data>) -> Void){
        let responseSerializer = DataRequest.dataResponseSerializer()
        start(queue: queue, responseSerializer: responseSerializer, completionHandler: dataCompletion)
    }
    
    public func start(queue: DispatchQueue? = .main, stringCompletion: @escaping (DataResponse<String>) -> Void){
        let responseSerializer = DataRequest.stringResponseSerializer()
        start(queue: queue, responseSerializer: responseSerializer, completionHandler: stringCompletion)
    }
    
    public func start(queue: DispatchQueue? = .main, jsonCompletion: @escaping (DataResponse<Any>) -> Void){
        let responseSerializer = DataRequest.jsonResponseSerializer()
        start(queue: queue, responseSerializer: responseSerializer, completionHandler: jsonCompletion)
    }
    
    public func start(queue: DispatchQueue? = .main, plistCompletion: @escaping (DataResponse<Any>) -> Void){
        let responseSerializer = DataRequest.jsonResponseSerializer()
        start(queue: queue, responseSerializer: responseSerializer, completionHandler: plistCompletion)
    }
    
    public override func start<T>(queue: DispatchQueue? = .main, responseSerializer: T, completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void) where T : DataResponseSerializerProtocol {
        super.start(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

}


