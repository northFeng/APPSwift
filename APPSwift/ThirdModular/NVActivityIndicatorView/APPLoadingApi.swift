//
//  APPLoadingApi.swift
//  APPSwift
//  加载动画loading
//  Created by 峰 on 2020/7/4.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

import NVActivityIndicatorView

class APPLoadingApi {
    
    ///加载动画
    static func loadingAnimition(onView:UIView, loadingType:NVActivityIndicatorType = .ballClipRotate) {
        
        let loadingView = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 50, height: 50)), type: NVActivityIndicatorType.ballClipRotate, color: UIColor.red, padding: 0)
        
        onView.addSubview(loadingView)
        
        loadingView.startAnimating()
        //loadingView.stopAnimating()
        //loadingView.isAnimating
    }
}
