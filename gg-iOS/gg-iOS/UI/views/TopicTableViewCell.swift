//
//  TopicTableViewCell.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/11/4.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

fileprivate let avatarImageWH: CGFloat = 48
fileprivate let avatarImageTop: CGFloat = GGCommonSpace

class TopicTableViewCell: UITableViewCell {
    
    static let reuseId: String = "topicCellReuseId"
    
    public var item: Topic? {
        didSet {
            self.bind(item)
        }
    }
    
    /// 头像
    var avatarImageView: UIImageView!
    /// 节点标签
    var nodeLabel: UILabel!
    /// 标题标签
    var titleLabel: UILabel!
    
    /// 最后回复时间标签
    var timelabel: UILabel!
    /// 回复数量标签
    var replyNumLabel: UILabel!
    /// 回复数量背景
    var replyBackgroundView:UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    func setupUI() {
        avatarImageView = UIImageView()
        self.contentView.addSubview(avatarImageView)
        
        titleLabel = UILabel()
        self.contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = UIColor.darkText
        titleLabel.numberOfLines = 0
        
        nodeLabel = UILabel()
        self.contentView.addSubview(nodeLabel)
        nodeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        nodeLabel.textColor = UIColor.black
        
        timelabel = UILabel()
        self.contentView.addSubview(timelabel)
        timelabel.textColor = UIColor.lightGray
        timelabel.font = nodeLabel.font
        
        replyBackgroundView = UIImageView()
        self.contentView.addSubview(replyBackgroundView)
        let radius: CGFloat = 10.0
        replyBackgroundView.image = UIImage.resizableRoundCorner(with: UIColor.darkGray, radius: radius)
        
        replyNumLabel = UILabel()
        self.contentView.addSubview(replyNumLabel)
        replyNumLabel.font = timelabel.font
        replyNumLabel.textColor = UIColor.white
        replyNumLabel.textAlignment = .center
        
        avatarImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(avatarImageTop)
            make.width.height.equalTo(avatarImageWH)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(GGCommonSpace)
            make.trailing.lessThanOrEqualToSuperview().offset(-60)
        }
        nodeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
        }
        timelabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(nodeLabel)
        }
        replyNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel)
            make.center.equalTo(replyBackgroundView)
        }
        replyBackgroundView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-GGCommonSpace)
            make.width.equalTo(replyNumLabel).offset(15)
            make.height.equalTo(replyNumLabel).offset(4)
        }
    }
    
    // MARK: public
    
    public func cellHeight() -> CGFloat {
        self.layoutIfNeeded()
        return max(avatarImageView.frame.maxY, nodeLabel.frame.maxY) + avatarImageTop
    }
    
    // MARK: - private
    
    func bind(_ item: Topic?) {
        guard let item = item else {
            return
        }
        let avartar: String = item.avatar ?? ""
        avatarImageView.kf.setImage(with: URL(string: avartar))
        titleLabel.text = item.title
        nodeLabel.text = item.nodeName
        timelabel.text = item.lastTouchedTime
        let replyNum = item.replyNum ?? 0
        replyNumLabel.text = "\(replyNum)"
        replyNumLabel.isHidden = replyNum == 0
        replyBackgroundView.isHidden = replyNumLabel.isHidden
    }
}
