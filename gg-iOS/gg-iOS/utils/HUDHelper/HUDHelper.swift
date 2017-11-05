//
//  HUDHelper.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/11/3.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate func defaultFont() -> UIFont {
    return UIFont.preferredFont(forTextStyle: .subheadline)
}

fileprivate func customImage(_ imageName: String) -> UIImage {
    let bundle = Bundle(for: HUDHelper.self)
    guard let url = bundle.url(forResource: "HUDHelper", withExtension: "bundle") else {
        fatalError("HUDHelper bundle not found")
    }
    guard let imageBundle = Bundle(url: url) else {
        fatalError("image bundle not found")
    }
    guard let path = imageBundle.path(forResource: imageName, ofType: "png") else {
        fatalError("image not found")
    }
    let image: UIImage! = UIImage(contentsOfFile: path)?.withRenderingMode(.alwaysTemplate)
    
    return image
}

fileprivate let minimumShowTme: TimeInterval = 0.15

class HUDHelper: MBProgressHUD {
    /// 加载状态
    enum HUDLoadingState {
        /// 加载中
        case loading
        /// 加载成功
        case succ
        /// 加载失败
        case error
        /// 加载出现警告
        case warn
    }
    
    
    /// 同步等待返回
    ///
    /// - Returns: 显示的HUD
    @discardableResult
    public class func show() -> HUDHelper {
        return self.show(with: nil)
    }
    
    /// 显示HUD, 添加到窗口上
    ///
    /// - Parameter removeFromSuperViewOnHide: 隐藏时是否从父视图移除
    /// - Returns: hud实例
    @discardableResult
    public class func showWithRemoveFlag(_ removeFromSuperViewOnHide: Bool) -> HUDHelper {
        return self.show(with: nil, should: removeFromSuperViewOnHide)
    }
    
    /// 同步等待返回
    ///
    /// - Parameter status: 提示文字, 状态改变后调用对应方法改变文字
    /// - Returns: HUD实例
    @discardableResult
    public class func show(with status: String?) -> HUDHelper {
        return self.show(with: status, should: true)
    }
    
    /// 只适用于以下情形(均为同步,显示在窗口上),其他情况灵活使用
    /// * 操作失败\成功后不适合带图标的提示
    ///
    /// - Note: 根据文字自动计算显示时间
    /// - Parameter msg: 显示提示信息
    public class func showMessage(_ msg: String) {
        self.showMessage(msg, hideAfter: self.duration(forDisplay: msg))
    }
    
    public class func showMessage(_ msg: String, hideAfter delay: TimeInterval) {
        let hud = HUDHelper.defaultHud()
        hud.mode = .text
        hud.detailsLabel.text = msg
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: delay)
    }
    
    /// - Note: 不要与`showWithStatus`或`showInfoWithStatus`连用
    ///
    /// - Parameter status: 提示文字
    public class func showInfoWithStatus(_ status: String) {
        self.showImage(self.infoImage, with: status)
    }
    
    /// - Note: 不要与`showWithStatus`或`showInfoWithStatus`连用
    ///
    /// - Parameter status: 提示文字
    public class func showSuccessWithStatus(_ status: String) {
        self.showImage(self.successImage, with: status)
    }
    
    /// - Note: 不要与`showWithStatus`或`showInfoWithStatus`连用
    ///
    /// - Parameter status: 提示文字
    public class func showErrorWithStatus(_ status: String) {
        self.showImage(self.errorImage, with: status)
    }
    
    /// 隐藏添加到视图上的所有`hudhelper`生成的实例, 会忽略`MBProgressHUD`实例
    ///
    /// - Parameters:
    ///   - view: 要操作的视图
    ///   - animated: 是否需要动画
    /// - Returns: 计数
    public class func hideAll(for view: UIView, _ animated: Bool) -> Int {
        var huds = [HUDHelper]()
        let subviews = view.subviews
        for aView in subviews {
            if aView.isKind(of: self) {
                let aHud = aView as! HUDHelper
                huds.append(aHud)
                aHud.removeFromSuperViewOnHide = true
                if animated {
                    aHud.hideAfterRecommendDuration()
                } else {
                    aHud.hide(animated: animated)
                }
            }
        }
        return huds.count
    }
    
    public func onStatusChange(_ status: String) {
        self.setStatus(status, state: .loading)
    }
    
    /// 成功完成加载时提示的信息
    ///
    /// - Parameter msg: 提示信息
    public func onSuccess(_ msg: String) {
        self.setStatus(msg, state: .succ)
    }
    
    /// 加载失败后的提示信息
    ///
    /// - Parameter msg: 提示信息
    public func onError(_ msg: String) {
        self.setStatus(msg, state: .error)
    }
    
    /// 加载失败后的警告信息, 调用后`status`在一段时间后会终止
    ///
    /// - Parameter msg: 警告信息
    public func onWarning(_ msg: String) {
        self.setStatus(msg, state: .warn)
    }
    
    /// 动画隐藏, 时间由内部计算
    public func hideAfterRecommendDuration() {
        self.hide(animated: true, afterDelay: HUDHelper.recommendDuration(for: self.detailsLabel.text))
    }
    
    /// 推荐的显示时间(最短不低于0.15s)
    ///
    /// - Parameter string: 要显示的文字
    /// - Returns: 推荐的显示时间
    public class func recommendDuration(for msg: String?) -> TimeInterval {
        if let msg = msg {
            return max(minimumShowTme, self.duration(forDisplay: msg))
        } else {
            return minimumShowTme
        }
    }
    
    private class func duration(forDisplay msg: String) -> TimeInterval {
        return TimeInterval(msg.count) * 0.06 + 0.5
    }
    
    // MARK: - getter
    
    static var infoImage: UIImage = {
        var image: UIImage!;
        if image == nil {
            image = customImage("info")
        }
        return image
    }()
    
    static var successImage: UIImage = {
        var image: UIImage!;
        if image == nil {
            image = customImage("success")
        }
        return image
    }()
    
    static var errorImage: UIImage = {
        var image: UIImage!;
        if image == nil {
            image = customImage("error")
        }
        return image
    }()
}

extension HUDHelper {
    private static func defaultHud() -> HUDHelper {
        let hud = self.showAdded(to: UIApplication.shared.delegate!.window!!, animated: true)
        hud.detailsLabel.font = defaultFont()
        return hud
    }
    
    @discardableResult
    private static func show(with status: String?, should removefromSuperViewOnHide: Bool) -> HUDHelper {
        let hud = self.defaultHud()
        hud.removeFromSuperViewOnHide = removefromSuperViewOnHide
        hud.detailsLabel.text = status
        return hud
    }
    
    private static func customImageView() -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        imageView.tintColor = UIColor.white
        return imageView
    }
    
    private static func showImage(_ image: UIImage?, with status: String) {
        let hud = self.showAdded(to: UIApplication.shared.delegate!.window!!, animated: true)
        hud.detailsLabel.font = defaultFont()
        hud.detailsLabel.text = status
        if let image = image {
            hud.mode = .customView
            let imageView = self.customImageView()
            imageView.image = image
            hud.customView = imageView
        }
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: self.recommendDuration(for: status))
    }
    
    private func setStatus(_ status: String?, state loadingState: HUDLoadingState) {
        var isComplete = true
        var image: UIImage?
        
        switch loadingState {
        case .loading:
            self.mode = .indeterminate
            isComplete = false
        case .succ:
            image = HUDHelper.successImage
        case .error:
            image = HUDHelper.errorImage
        case .warn:
            image = HUDHelper.infoImage
        }
        
        self.detailsLabel.text = status
        
        // cancel previous hideAfterDelay
        // if`removeFromSuperViewOnHide` == NO, it will be visible on screen again
        self.show(animated: false)
        
        if isComplete {
            self.mode = .customView
            let imageView = HUDHelper.customImageView()
            imageView.image = image
            self.customView = imageView
            self.hide(animated: true, afterDelay: HUDHelper.recommendDuration(for: status))
        }
    }
}
