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
    
    #if DEBUG
    let file = (file as NSString).lastPathComponent;
    
    print("\(file):(\(lineNum))--\(message)");
    
    #endif
    
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

///适配iPad比例 ( iPhone 1.  iPad 1.3)
var kIpadScale:Float {
    var scale:Float = 1.0
    
    if UIDevice.current.userInterfaceIdiom == .phone {
        scale = 1.0
    }else if UIDevice.current.userInterfaceIdiom == .pad {
        scale = 1.3
    }
    return scale
}

///适配iPad尺寸
func FitIpad(num:Float) -> Float {
    
    if UIDevice.current.userInterfaceIdiom == .phone {
        return num * 1.0
    }else{
        return num * 1.5
    }
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
    
    APPColorDefine.colorHexString(color:color, alpha:alpha)
}

///红绿蓝 三色 数值 —> UIColor
func RGB(r:Int, g:Int, b:Int, alpha:CGFloat = 1.0) -> UIColor {
    
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
}

///动态颜色
func DynamicColor(lightStylecolor:UIColor, darkStylecolor:UIColor) -> UIColor {
    
    APPColorDefine.colorDynamicColor(lightStylecolor:lightStylecolor, darkStylecolor:darkStylecolor)
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
    
    APPImageLoad.ImageViewLoadImage(imgView: imgView, url: url)
}

///加载图片 && 占位图
func ImageViewLoadImage(imgView:UIImageView, url:String, _ placeholderImgName:String) {
    APPImageLoad.ImageViewLoadImage(imgView: imgView, url: url, placeholderImgName: placeholderImgName)
}

///常规获取图片 （图片会缓存到 内存中）
func ImageGet(name:String) -> UIImage {
    return UIImage(named: name) ?? UIImage()
}

///通过文件路径加载图片 （不会缓存到内存中）
func ImageGet(path:String) -> UIImage {
    return UIImage(contentsOfFile: path) ?? UIImage()
}

//MARK: ************************* JSON 转换 Model *************************

///JSON 转 Model
func JsonToModel(json:Any, Model:BaseModel.Type) -> Any? {
    APPNetTool.jsonToModel(json: json, Model: Model)
}

///Model 转 DicJson
func modelToJsonObject(model:BaseModel) -> [String : Any] {
    APPNetTool.modelToJsonObject(model: model)
}

///Model 转 String
func modelToJsonString(model:BaseModel) -> String {
    APPNetTool.modelToJsonString(model: model)
}
