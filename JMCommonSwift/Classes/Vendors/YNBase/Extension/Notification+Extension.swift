//
//  Notification+Extension.swift
//  YNBase
//
//  Created by guo hongquan on 2021/6/15.
//  Notification 扩展

import Foundation

/**
 * 用例
 * NotificationCenter.default.post(name: Notification.Name.YN.logout, object: nil)
 */

extension Notification.Name {
    
    /// YN - 自定义通知 YN namespace
    public struct YN {
        /// 退出登录
        public static let logout = Notification.Name("app.yunniao.firmiana.customer.logout")
        /// 接待列表刷新
        public static let receptionList = Notification.Name("app.yunniao.firmiana.customer.receptionList")
        /// 在跑列表刷新
        public static let ongoingList = Notification.Name("app.yunniao.firmiana.customer.ongoingList")
        /// 消息红点数量
        public static let msgRedCount = Notification.Name("app.yunniao.firmiana.customer.msgRedCount")
        
        /// 跳转发布页面通知
        public static let YNPublishAction = NSNotification.Name("app.yunniao.firmiana.customer.YNPublishAction")
        /// 跳转接待未报名页面
        public static let YNReceptionUnApplyAction = NSNotification.Name("app.yunniao.firmiana.customer.YNReceptionUnApplyAction")
        
        /// 首次注册选择仓位置成功后通知
        public static let YNLoginWarehouseLocationSelectComplete = NSNotification.Name("app.yunniao.firmiana.customer.YNLoginWarehouseLocationSelectComplete")
        /// 城市搜索切换:
        public static let YNRCitySearchAction = NSNotification.Name("app.yunniao.firmiana.customer.YNRCitySearchAction")
        
    }
    
}
