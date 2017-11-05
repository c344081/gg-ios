//
//  GGFunctions.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/11/4.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit

/// 设备系统版本
public struct GGOSVersion {
    public static let currentVersion: String = UIDevice.current.systemVersion
    
    public static func betweenOrEqual(from: String, to: String) -> Bool {
        let fromRet = currentVersion.compare(from, options: .numeric)
        let result = fromRet == .orderedDescending || fromRet == .orderedSame
        if result == false { return false }
        let toRet = currentVersion.compare(to, options: .numeric)
        return toRet == .orderedAscending || toRet == .orderedSame
    }
    
    public static func greaterThan(_ value: String) -> Bool {
        let ret = currentVersion.compare(value, options: .numeric)
        return ret == .orderedDescending
    }
    
    public static func greaterThanOrEqualTo(_ value: String) -> Bool {
        let ret = currentVersion.compare(value, options: .numeric)
        return ret == .orderedDescending || ret == .orderedSame
    }
    
    public static func lessThan(_ value: String) -> Bool {
        let ret = currentVersion.compare(value, options: .numeric)
        return ret == ComparisonResult.orderedAscending
    }
    
    public static func lessThanOrEqualTo(_ value: String) -> Bool {
        let ret = currentVersion.compare(value, options: .numeric)
        return ret == .orderedAscending || ret == .orderedSame
    }
    
    public static func inOpenInterval(from: String, to: String) -> Bool {
        let fromRet = currentVersion.compare(from, options: .numeric)
        let result = fromRet == .orderedDescending
        if result == false { return false }
        let toRet = currentVersion.compare(to, options: .numeric)
        return toRet == .orderedAscending
    }
    
    public static func inRightClosedInterval(from: String, to: String) -> Bool {
        let fromRet = currentVersion.compare(from, options: .numeric)
        let result = fromRet == .orderedDescending
        if result == false { return false }
        let toRet = currentVersion.compare(to, options: .numeric)
        return toRet == .orderedAscending || toRet == .orderedSame
    }
    
    public static func inLeftClosedInterval(from: String, to: String) -> Bool {
        let fromRet = currentVersion.compare(from, options: .numeric)
        let result = fromRet == .orderedDescending || fromRet == .orderedSame
        if result == false { return false }
        let toRet = currentVersion.compare(to, options: .numeric)
        return toRet == .orderedAscending
    }
}

//========== scrollView content adjust =============
public func adjustContentInset(for scrollView: UIScrollView, automatic: Bool) {
    adjustContentInset(for: scrollView, controller: nil, automatic: automatic);
}

public func adjustContentInset(never scrollView: UIScrollView, controller: UIViewController) {
    adjustContentInset(for: scrollView, controller: controller, automatic: false);
}

public func adjustContentInset(for scrollView: UIScrollView, controller: UIViewController?, automatic: Bool) {
    if #available(iOS 11.0, *) {
        var option: UIScrollViewContentInsetAdjustmentBehavior = .never
        if automatic { option = .automatic }
        scrollView.contentInsetAdjustmentBehavior = option
    } else {
        controller?.automaticallyAdjustsScrollViewInsets = automatic ? true : false
    }
}
