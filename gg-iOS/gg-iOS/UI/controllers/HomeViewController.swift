//
//  GGHomeViewController.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/10/31.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    /// topic模型数组
    lazy var items = [Topic]()
    lazy var heightCache = NSCache<NSString, NSNumber>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavi()
        self.setupUI()
        self.loadData()
    }
    
    func setupNavi() {
        self.navigationItem.title = "首页"
    }
    
    func setupUI() {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(tableView)
        adjustContentInset(never: tableView, controller: self)
        tableView.contentInset = UIEdgeInsets(top: GGNaviBarMaxY, left: 0, bottom: GGTabBarH, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.estimatedRowHeight = 0
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TopicTableViewCell.self, forCellReuseIdentifier: TopicTableViewCell.reuseId)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        HUDHelper.showInfo(with: "123")
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.0) {
            HUDHelper.showInfo(with: "456")
        }
    }
    
    func loadData() {
        var item = Topic()
        item.title = "同志们，保利时代又堵路了，你们怎么看"
        item.node = "water"
        item.nodeName = "汤逊湖"
        item.topicId = "26738"
        item.userName = "dabaowuda"
        item.avatar = "http://cdn.guanggoo.com/static/avatar/80/m_default.png"
        item.lastTouchedTime = "4分钟前"
        item.lastReplyUserName = "xieyang"
        item.replyNum = 4
        items.append(item)
        
        item = Topic()
        item.title = "你最期待社区组织什么活动？"
        item.node = "lowshine"
        item.nodeName = "汤逊湖"
        item.topicId = "25609"
        item.userName = "ihuoxin"
        item.avatar = "http://cdn.guanggoo.com/static/avatar/98/m_a82fbce6-9a2e-11e7-a0b7-00163e020f08.png"
        item.lastTouchedTime = "11分钟前"
        item.lastReplyUserName = "East_Lake"
        item.replyNum = 37
        items.append(item)
        
        item = Topic()
        item.title = "尚德机构武汉研发中心招聘【大量最新职位发布】"
        item.node = "job"
        item.nodeName = "找工作"
        item.topicId = "26727"
        item.userName = "catnnna"
        item.avatar = "http://cdn.guanggoo.com/static/avatar/59/m_default.png"
        item.lastTouchedTime = "16分钟前"
        item.lastReplyUserName = "zhhw_dev"
        item.replyNum = 9
        items.append(item)

        item = Topic()
        item.title = "新手父母如何给小孩买商业保险？"
        item.node = "qna"
        item.nodeName = "你问我答"
        item.topicId = "26710"
        item.userName = "eleven"
        item.avatar = "http://cdn.guanggoo.com/static/avatar/7/m_e74ad505-5122-53e4-a042-9de9435d7419.png"
        item.lastTouchedTime = "17分钟前"
        item.lastReplyUserName = "kingfrng"
        item.replyNum = 4
        items.append(item)

        item = Topic()
        item.title = "年底想入手一台代步车，落地预算15万，求老司机建议"
        item.node = "auto"
        item.nodeName = "汽车"
        item.topicId = "26675"
        item.userName = "e211e"
        item.avatar = "http://cdn.guanggoo.com/static/avatar/84/m_62c7ed54-c30c-11e5-a0b7-00163e020f08.png"
        item.lastTouchedTime = "17分钟前"
        item.lastReplyUserName = "zhhw_dev"
        item.replyNum = 59
        items.append(item)
        
        items.append(contentsOf: items)
    }

}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableViewCell.reuseId, for: indexPath) as! TopicTableViewCell
        cell.item = items[indexPath.row]
        return cell
    }
    
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let item = items[indexPath.row]
        guard let topicId = item.topicId else {
            return height
        }
        let topicIdStr = NSString(string: topicId)
        if let cachedHeight: NSNumber = heightCache.object(forKey: topicIdStr) {
            height = CGFloat(cachedHeight.floatValue)
        } else {
            let cell = TopicTableViewCell(style: .default, reuseIdentifier: TopicTableViewCell.reuseId)
            cell.width = GGScreenW()
            cell.item = item
            height = cell.cellHeight()
            heightCache.setObject(height as NSNumber, forKey: topicIdStr)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
