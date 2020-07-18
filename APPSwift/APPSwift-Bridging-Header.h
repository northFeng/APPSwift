//  桥头文件
//  Use this file to import your target's public headers that you would like to expose to Swift.
//  Swift调OC的桥头文件  或者 Build Settings - Swift Compiler - Code Generation下的Objective-C Bridging Header选项。
//  1、把需要引用OC的类的头文件 在此进行引用
/**
 自动创建：桥头文件，添加OC文件  / 添加Swift 文件 编译器自动创建，
 
 手动创建：先删除已有的桥头文件 ！ 找到taget ----> build setting ----> object-c Bridging-Header (双击打开)直接拖到这个位置 ——> 删除里面的路劲！！ 再次走 自动创建方法 / 或者 创建 .h文件，然后 设置路径 APPSwift/APPSwift-Bridging-Header.h
 */

#import "APPHttpTool.h"//网络请求类

#import "APPXYColorApi.h"//CGColor 动态颜色

#import "APPAlertApi.h"//吐字

//OC中SDK
#import <MJRefresh/MJRefresh.h>

//键盘管理退出
#import "APPKeyBoardApi.h"

//YYCache
#import <YYCache/YYCache.h>
