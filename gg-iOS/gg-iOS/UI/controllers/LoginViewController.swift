//
//  LoginViewController.swift
//  gg-iOS
//
//  Created by zoxuner on 2017/10/31.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import Kanna
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    var nameField: UITextField!
    var passwordField: UITextField!
    var signInButton: UIButton!
    var forgotPwdButton: UIButton!
    var signUpButton: UIButton!
    
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.initialize()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.lightGray
        nameField = UITextField(frame: .zero)
        self.view.addSubview(nameField)
        nameField.placeholder = "用户名"
        
        passwordField = UITextField(frame: .zero)
        self.view.addSubview(passwordField)
        passwordField.placeholder = "密码"
        
        signInButton = UIButton(type: .custom)
        self.view.addSubview(signInButton)
        signInButton.setTitle("登陆", for: .normal)
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.setTitleColor(UIColor.orange, for: .disabled)
        
        forgotPwdButton = UIButton(type: .custom)
        self.view.addSubview(forgotPwdButton)
        forgotPwdButton.setTitle("忘记密码", for: .normal)
        
        signUpButton = UIButton(type: .custom)
        self.view.addSubview(signUpButton)
        signUpButton.setTitle("注册新用户", for: .normal)
        
        nameField.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.centerY).offset(-GGCommonSmallSpace)
            make.leading.equalToSuperview().offset(35.0)
            make.trailing.equalToSuperview().offset(-35.0)
            make.height.equalTo(50.0)
        }
        passwordField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(nameField)
            make.top.equalTo(self.view.snp.centerY).offset(GGCommonSmallSpace)
            make.height.equalTo(nameField)
        }
        signInButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(15)
            make.height.equalTo(50)
            make.leading.equalTo(passwordField).offset(15)
            make.trailing.equalTo(passwordField).offset(-15)
        }
        forgotPwdButton.snp.makeConstraints { (make) in
            make.top.equalTo(signInButton.snp.bottom).offset(15)
            make.leading.trailing.equalTo(nameField)
        }
        signUpButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            } else {
                make.bottom.equalTo(self.view).offset(-30)
            }
        }
    }
    
    // MARK: - actions
    
    // MARK: - private
    
    func initialize() {
        Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(3)
            return Disposables.create()
        }
        Observable.combineLatest(nameField.rx.text, passwordField.rx.text) { (name, password) in
            return name!.count > 0 && password!.count > 0
        }.bind(to: signInButton.rx.isEnabled).disposed(by: disposebag)
        
        // MARK: - sign in
        signInButton.rx.controlEvent(.touchUpInside)
            .flatMap{ (_) -> Observable<Any> in
                if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: "http://www.baidu.com")!) {
                    for cookie in cookies {
                        if cookie.name == "_xsrf" {
                            return Observable.just(cookie.value)
                        }
                    }
                }
                return Observable.create({ observer in
                    Alamofire.request("http://www.guanggoo.com/login", method: .get).responseData { response in
                        switch response.result {
                        case .success:
                            if let data = response.data,
                                let html = String(data: data, encoding: .utf8),
                                let doc = HTML(html: html, encoding: .utf8),
                                let xsrf = doc.xpath("//input[@name='_xsrf']").first?["value"]
                            {
                                observer.onNext(xsrf)
                                
                            } else {
                                observer.onNext(RxCocoaError.unknown)
                            }
                        case .failure:
                            observer.onNext(response.error!)
                        }
                    }
                    return Disposables.create()
                }).catchError({ (e) -> Observable<Any> in
                    return Observable.just(e)
                })
            }
            .flatMap({ (xsrf) -> Observable<Any> in
                return Observable.create({ observer in
                    Alamofire.request("http://www.guanggoo.com/login",
                                      method: .post,
                                      parameters: ["email": "45167966@qq.com",
                                                   "password": "12345678",
                                                   "_xsrf": xsrf])
                        .responseData { response in
                        switch response.result {
                        case .success:
                            if let data = response.data, let html = String(data: data, encoding: .utf8) {
                                observer.onNext(html)
                            } else {
                                observer.onNext(RxCocoaError.unknown)
                            }
                        case .failure:
                            observer.onNext(response.error!)
                        }
                    }
                    return Disposables.create()
                }).catchError({ (e) -> Observable<Any> in
                    return Observable.just(e)
                })
            })
            .subscribe(onNext: { htmldoc in
                print("----\(htmldoc)")
            }).disposed(by: disposebag)
    }
    
}
