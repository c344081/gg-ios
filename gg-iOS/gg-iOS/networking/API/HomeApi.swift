//
//  HomeApi.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/11/10.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class HomeApi: GGBaseRequest, GGRequestTypeable {
   
    override var path: String {
        return "/"
    }
    
    func startRequest(queue: DispatchQueue? = .main, with completion: @escaping (Error?, [Topic]?) -> Void) {
        start(queue: queue, dataCompletion: { (response) in
            switch response.result {
            case .success:
                var topics = DataType()
                guard let data = response.value else {
                    completion(nil, topics)
                    return
                }
                
                if let html = String(data: data, encoding: .utf8),
                    let doc = HTML(html: html, encoding: .utf8)
                {
                    let itemNodes = doc.xpath("//div[@class='topic-item']")
                    for itemNode in itemNodes {
                        let topic = Topic(itemNode)
                        // add topic
                        topics.append(topic)
                    }
                    completion(nil, topics)
                }
            case .failure:
                completion(response.error, nil)
            }
        })
    }
}

extension Topic {
    convenience init(_ itemNode: XMLElement) {
        self.init()
        self.title = itemNode.xpath(".//*[@class='title']/a").first?.text
        let nodeDoc = itemNode.xpath(".//*[@class='node']/a").first
        self.node = nodeDoc?["href"]?.replacingOccurrences(of: "/node/", with: "", options: .caseInsensitive)
        self.nodeName = nodeDoc?.text
        let titleRef = itemNode.xpath(".//*[@class='title']/a").first?["href"]
        let idRange = titleRef?.range(of: "(?<=/)([\\d]*?)(?=#)", options: .regularExpression)
        if let idRange = idRange, let topicId = titleRef?[idRange] {
            self.topicId = String(topicId)
        }
        self.userName = itemNode.xpath(".//*[@class='username']/a").first?.text
        self.avatar = itemNode.xpath(".//*[@class='avatar']").first?["src"]
        self.lastTouchedTime = itemNode.xpath(".//*[@class='last-touched']").first?.text
        let lastReplyUserName = itemNode.xpath(".//*[@class='last-reply-username']/a").first?["href"]
        self.lastReplyUserName = lastReplyUserName?.replacingOccurrences(of: "/u/", with: "", options: .caseInsensitive)
        self.replyNum = Int(itemNode.xpath(".//*[@class='count']/a").first?.text ?? "0")
    }
}


