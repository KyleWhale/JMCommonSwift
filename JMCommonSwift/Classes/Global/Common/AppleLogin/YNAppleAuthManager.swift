//
//  YNAppleAuthManager.swift
//  YNCustomer
//
//  Created by James on 2021/6/4.
//

import Foundation
import UIKit

import AuthenticationServices


class YNAppleAuthManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    typealias YNAppleAuthSuccessHandler = ( _ identityToken:String, _ authorizationCode:String, _ user:String, _ email:String, _ fullName:String)->Void;
    var sucessBlock : YNAppleAuthSuccessHandler?;
    
    typealias YNAppleAuthFailureHandler = ( _ errorInfo:String)->Void
    var failureBlock : YNAppleAuthFailureHandler?
    
    // 单例
    public static let shareManager = YNAppleAuthManager.init()
    private override init(){
        super.init()
    }
    
    // 苹果登录掉起
    public func appleAuthWithSuccess( _ SBlock: @escaping YNAppleAuthSuccessHandler, _ FBlock: @escaping YNAppleAuthFailureHandler) {
        
        self.sucessBlock = SBlock
        self.failureBlock = FBlock
        
        if #available(iOS 13.0, *) {
            
            applePerformRequests()
        } else {
            self.failureBlock?("不支持苹果登录")
        }
    }
    
    @available(iOS 13.0, *)
    func applePerformRequests() {
        
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        let provider = ASAuthorizationAppleIDProvider()
         // 创建新的AppleID 授权请求
        let request = provider.createRequest()
        // 在用户授权期间请求的联系信息
        request.requestedScopes = [ASAuthorization.Scope.fullName,ASAuthorization.Scope.email]
         // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        let vc = ASAuthorizationController.init(authorizationRequests: [request])
         // 设置授权控制器通知授权请求的成功与失败的代理
        vc.delegate = self
         // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        vc.presentationContextProvider = self
         // 在控制器初始化期间启动授权流
        vc.performRequests()
    }
    
    // 苹果登录回调
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return YNKeyWindow() ?? UIWindow()
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if authorization.credential.isKind(of: ASAuthorizationAppleIDCredential.self) {
            let credential = authorization.credential
            if credential.isKind(of: ASAuthorizationAppleIDCredential.self) {
                // 用户登录
                if let apple = credential as? ASAuthorizationAppleIDCredential {
                    
                    let state = apple.state
                    /// 需要使用钥匙串的方式保存用户的唯一信息
                    let user = apple.user
                    let fullName = apple.fullName
                    let email = apple.email
                    /// 用于后台向苹果服务器验证身份信息
                    // refresh token 一定要UTF8的
                    let authorizationCode = String.init(data: apple.authorizationCode ?? Data(), encoding: String.Encoding.utf8)
                    // access token 一定要UTF8的
                    let identityToken = String.init(data: apple.identityToken ?? Data(), encoding: String.Encoding.utf8)
                    
                    let realUserStatus = apple.realUserStatus
                    
                    let name = fullName?.familyName?.appending((fullName?.givenName ?? ""))
                    
                    ///如果授权的时候选择隐藏邮箱，会返回匿名邮箱，
                    ///用户名、邮箱只有第一次授权的时候才会返回
                    print("state: \(String(describing: state))")
                    print("userID: \(String(describing: user))")
                    print("fullName: \(String(describing: fullName))")
                    print("email: \(String(describing: email))")
                    print("authorizationCode: \(String(describing: authorizationCode))")
                    print("identityToken: \(String(describing: identityToken))")
                    print("realUserStatus: \(String(describing: realUserStatus))")
                    print("userName: \(String(describing: name))")
                    
                    self.sucessBlock?(identityToken ?? "",authorizationCode ?? "", user , email ?? "", name ?? "")
                }
  
            }
            ///暂时不支持这种方式
            else if credential.isKind(of: ASPasswordCredential.self)
            {
                //用户登录使用现有的密码凭证
                if let passwordCredential = credential as? ASPasswordCredential {
                    
                    //密码凭证对象的用户标识 用户的唯一标识
                    let user = passwordCredential.user
                    // 密码凭证对象的密码
                    let password = passwordCredential.password
                    
                    print("user>>>\(user)password>>\(password)")
                }
            }
            else
            {
                self.failureBlock?("授权信息均不符")
            }
        }
        
    }
}
