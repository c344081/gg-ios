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
    
    func start(queue: DispatchQueue? = .main, completion: @escaping (DataResponse<Data>) -> Void){
        let responseSerializer = DataRequest.dataResponseSerializer()
        start(queue: queue, responseSerializer: responseSerializer, completionHandler: completion)
    }
    
    func start(queue: DispatchQueue? = .main, stringCompletion: @escaping (DataResponse<String>) -> Void){
        let responseSerializer = DataRequest.stringResponseSerializer()
        start(queue: queue, responseSerializer: responseSerializer, completionHandler: stringCompletion)
    }
    
    func start(queue: DispatchQueue? = .main, jsonCompletion: @escaping (DataResponse<Any>) -> Void){
        let responseSerializer = DataRequest.jsonResponseSerializer()
        start(queue: queue, responseSerializer: responseSerializer, completionHandler: jsonCompletion)
    }
    
    func start(queue: DispatchQueue? = .main, plistCompletion: @escaping (DataResponse<Any>) -> Void){
        let responseSerializer = DataRequest.jsonResponseSerializer()
        start(queue: queue, responseSerializer: responseSerializer, completionHandler: plistCompletion)
    }
    
    override func start<T>(queue: DispatchQueue? = .main, responseSerializer: T, completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void) where T : DataResponseSerializerProtocol {
        super.start(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

}


