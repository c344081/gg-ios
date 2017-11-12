//
//  GGBaseRequest.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/11/10.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit
import Alamofire

class GGBaseRequest: GGRequest<Data> {
    var baseUrl: String {
        return "http://www.guanggoo.com/"
    }
    override var responseType: GGResponseSerializerType {
        return .RawData
    }
}

