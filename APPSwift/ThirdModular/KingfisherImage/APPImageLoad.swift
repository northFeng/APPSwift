//
//  APPImageLoad.swift
//  APPSwift
//
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

import Kingfisher//图片加载

struct APPImageLoad {
    
    ///加载图片
    static func ImageViewLoadImage(imgView:UIImageView, url:String) {

        if let urlUrl = URL(string: url) {
            imgView.kf.setImage(with:urlUrl)
        }
    }

    ///加载图片+占位图
    static func ImageViewLoadImage(imgView:UIImageView, url:String, placeholderImgName:String) {

        if let urlUrl = URL(string: url) {
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(
                with: urlUrl,
                placeholder: UIImage(named: placeholderImgName),
                //options参数 是对图片操作的参数选项，里面是个数组，可以设置各种参数放进去！！！
                options: [.transition(.fade(0.4))]//过渡动画，渐变效果
                )
        }
        
        /**
         { (image, error, cacheType, imageUrl) in
             
             //image       // 为 nil 时，表示下载失败
             
             //error       // 为 nil 时，表示下载成功， 非 nil 时，就是下载失败的错误信息
             
             //cacheType   // 缓存类型，是个枚举，分以下三种：
                         // .none    图片还没缓存（也就是第一次加载图片的时候）
                         // .memory  从内存中获取到的缓存图片（第二次及以上加载）
                         // .disk    从磁盘中获取到的缓存图片（第二次及以上加载）
             
             //imageUrl    // 所要下载的图片的url
         })
         */
    }
}
