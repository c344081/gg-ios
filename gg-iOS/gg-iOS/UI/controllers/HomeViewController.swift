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
    
    var tableView: UITableView!
    /// topic模型数组
    lazy var items = [Topic]()
    lazy var heightCache = NSCache<NSString, NSNumber>()
    
    lazy var homeApi: HomeApi = HomeApi()

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
        tableView = UITableView(frame: self.view.bounds, style: .plain)
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
    }
    
    func loadData() {
        homeApi.startRequest { [weak self] (error, topics) in
            guard let strongSelf = self else { return }
            guard error == nil else {
                return
            }
            guard let topics = topics else {
                return
            }
            strongSelf.items.append(contentsOf: topics)
            strongSelf.tableView.reloadData()
        }
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
