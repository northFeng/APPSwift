//
//  APPCustomDefine.swift
//  APPSwift
//  自定义宏
//  Created by 峰 on 2020/6/19.
//  Copyright © 2020 north_feng. All rights reserved.
//
import UIKit

//MARK: ************************* 系统宏 *************************

///全局打印函数
func Print<T>(_ message:T, file:String = #file, funcName:String = #function, lineNum:Int = #line){
    
    //#if DEBUG
    let file = (file as NSString).lastPathComponent;
    
    print("\(file):(\(lineNum))--\(message)");
    
    //#endif
    
    //debugPrint("系统debugPrint输出")
}

//--------------------------------------- 手机型号 && 系统版本 ---------------------------------------

let iPhone5:Bool = __CGSizeEqualToSize(CGSize(width: 640, height: 1136), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))

let iPhone6:Bool = __CGSizeEqualToSize(CGSize(width: 750, height: 1334), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))

let iPhone6Plus:Bool = __CGSizeEqualToSize(CGSize(width: 1242, height: 2208), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))

let iPhoneX:Bool = __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))

let iPhoneXR:Bool = __CGSizeEqualToSize(CGSize(width: 828, height: 1792), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))

let iPhoneXMax:Bool = __CGSizeEqualToSize(CGSize(width: 1242, height: 2688), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))

///小于iOS10
let IOSLess10:Bool = ((UIDevice.current.systemVersion as NSString).integerValue < 10)

///大于iOS13
let IOSAbove13:Bool = ((UIDevice.current.systemVersion as NSString).integerValue > 13)

///是否为手机（用来判断是iPhone && iPad）
let kIsiPhone:Bool = true

//--------------------------------------------------------------------------------------------


//--------------------------------------- 手机沙盒路径 ---------------------------------------
//FileManager.SearchPathDirectory.documentDirectory

///获取沙盒Document路径
let kAPP_File_DocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

///获取沙盒Library路径
let kAPP_File_LibraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first

///获取沙盒Cache路径
let kAPP_File_CachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first

///获取沙盒temp路径
let kAPP_File_TempPath = NSTemporaryDirectory()

///获取沙盒home路径
let kAPP_File_HomePath = NSHomeDirectory()


//--------------------------------------------------------------------------------------------


//MARK: ************************* 自定常量宏 *************************

///屏幕宽
let kScreenWidth = UIScreen.main.bounds.size.width

///屏幕高
let kScreenHeight = UIScreen.main.bounds.size.height

///状态栏高度
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height

///一般 屏幕宽度比例
let KSCALE = UIScreen.main.bounds.size.width / 375.0

///比例高度
func kScaleHeight(x:Float, y:Float, width:Float) -> Float {
    return width * (x/y)
}

///屏幕宽度比例
let kScaleW = kScreenWidth/375.0

///屏幕高度比例
let kScaleH = kScreenHeight/667.0

///适配iPad比例 ( iPhone 1.  iPad 1.5)
let kIpadScale = 1.0//APPManager.iPhoneAndIpadTextAdapter()

///适配iPad尺寸
func FitIpad(num:CGFloat) -> Float {
    return 1.0
}

//MARK: ******************************** NaviBar && TabBar 常量宏  ********************************

///导航条ItemBar的高度
let kNaviBar_ItemBarHeight = 44.0

///底部TabBarItem的高度
let kTabBar_ItemsHeight = 49.0

///导航条高度
let kTopNaviBarHeight = kStatusBarHeight > 20 ? 88.0 : 64.0

///底部TabBar高度
let kTabBarHeight = kStatusBarHeight > 20 ? 83.0 : 49.0

///刘海屏手机 弧边安全高度
let kBottomSafeHeight = kStatusBarHeight > 20 ? 34.0 : 0.0


//MARK: ******************************** 定义颜色函数 && 动态颜色 *********************************

///颜色16进制字符串 —> UIColor
func COLOR(color:String, alpha:CGFloat = 1.0) -> UIColor {
    // return APPColorFunction.color(withHexString: color, alpha: 1.0)
    
    // 存储转换后的数值
    var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
    
    var hex = color
    // 如果传入的十六进制颜色有前缀，去掉前缀
    if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
        hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
    } else if hex.hasPrefix("#") {
        hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
    }
    // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
    if hex.count < 6 {
        for _ in 0..<6-hex.count {
            hex += "0"
        }
    }

    // 分别进行转换
    // 红
    Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt32(&red)
    // 绿
    Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt32(&green)
    // 蓝
    Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)...])).scanHexInt32(&blue)

    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
}

///红绿蓝 三色 数值 —> UIColor
func RGB(r:Int, g:Int, b:Int, alpha:CGFloat = 1.0) -> UIColor {
    
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
}

///动态颜色
func DynamicColor(lightStylecolor:UIColor, darkStylecolor:UIColor) -> UIColor {
    
    var color:UIColor = lightStylecolor
    
    if #available(iOS 13.0, *) {
        color = UIColor { (traitCollection:UITraitCollection) -> UIColor in
        
            if traitCollection.userInterfaceStyle == .light {
                //浅色模式
                return lightStylecolor
            } else if traitCollection.userInterfaceStyle == .dark  {
                //黑暗模式
                return darkStylecolor
            } else {
                //默认浅色模式
                return lightStylecolor
            }
        }
    }
    
    return color
}

//MARK: ******************************** 定义字体 *********************************

///标准字体
let kRegularFont = "PingFangSC-Regular"

///中等字体
let kMediumFont = "PingFangSC-Medium"

///半黑体
let kSemiboldFont = "PingFangSC-Semibold"

///系统字体
func kFontOfSystem(font:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font)
}

///非系统字体
func kFontOfCustom(name:String,font:CGFloat) -> UIFont? {

    return UIFont(name: name, size: font)
}


//MARK: ************************* 图片加载框架 *************************
///加载图片
func ImageViewLoadImage(imgView:UIImageView, url:String) {

    if let urlUrl = URL(string: url) {
        imgView.kf.setImage(with:urlUrl)
    }
}

///加载图片+占位图
func ImageViewLoadImage(imgView:UIImageView, url:String, placeholderImgName:String) {

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
