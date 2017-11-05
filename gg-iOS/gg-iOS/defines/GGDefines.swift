//
//  GGDefines.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/10/31.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit

/// 当前宽度, 受旋转影响
public func GGScreenW() -> CGFloat {
   return UIScreen.main.bounds.width
}

/// 当前高度, 受旋转影响
public func GGScreenH() -> CGFloat {
    return UIScreen.main.bounds.height
}

/// 5s 高度
public let TAScreenH_5S: CGFloat = 568.0
/// 4s 高度
public let TAScreenH_4S: CGFloat = 480.0
/// iPhone X 高度
public let TAScreenH_X: CGFloat = 812.0

/// 屏幕竖直放置时的高度
public let phoneHeight: CGFloat = {
    return max(GGScreenW(), GGScreenH())
}()

/// 是否是iPhone X
public let isiPhoneX: Bool = {
    return phoneHeight == TAScreenH_X
}()

/// 是否是4S
public let is4S: Bool = {
    return phoneHeight == TAScreenH_4S
}()

/// 是否是5S
public let is5S: Bool = {
    return phoneHeight == TAScreenH_5S
}()

/// 导航栏高度
public let GGNaviBarH: CGFloat = 44.0

/// 状态栏高度
public let GGStatusBarH: CGFloat = {
    return isiPhoneX ? 44.0 : 20.0
}()

/// 导航栏最大Y值
public let GGNaviBarMaxY: CGFloat = {
    return isiPhoneX ? 88.0 : 64.0
}()

/// tabbar高度
public let GGTabBarH: CGFloat = {
    return isiPhoneX ? 83.0 : 49.0
}()

/// iPhone X 底部多余的高度
public let GGSafeAeraH: CGFloat = {
    return isiPhoneX ? 34.0 : 0
}()

/// 常用小间距
public let GGCommonSmallSpace: CGFloat = 5.0
/// 常用间距
public let GGCommonSpace: CGFloat = 10.0

enum Color {
    
}
