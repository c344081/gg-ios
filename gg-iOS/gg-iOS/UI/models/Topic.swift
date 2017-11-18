//
//  Topic.swift
//  gg-iOS
//
//  Created by chenhao on 2017/11/4.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit

class Topic {
   
    /// 头像
    public var avatar: String?
    /// 节点
    public var node: String?
    /// 节点名
    public var nodeName: String?
    /// 话题Id
    public var topicId: String?
    /// 发布时间
    public var time: String?
    /// 用户名
    public var userName: String?
    /// 标题
    public var title: String?
    /// 回复数量
    public var replyNum: Int?
    /// 最后回复时间
    public var lastTouchedTime: String?
    /// 最后回复用户名
    public var lastReplyUserName: String?
    
    /// 最后回复时间+用户名
    public var lastTouchedDesc: String {
        guard let time = lastTouchedTime, let userName = lastReplyUserName else {
            return ""
        }
        return "\(time)·\(userName)"
    }
    
}
