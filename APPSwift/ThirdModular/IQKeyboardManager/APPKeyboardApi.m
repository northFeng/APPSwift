//
//  APPKeyboardApi.m
//  APPSwift
//
//  Created by 峰 on 2020/7/10.
//  Copyright © 2020 north_feng. All rights reserved.
//

#import "APPKeyboardApi.h"

#import <IQKeyboardManager/IQKeyboardManager.h>//键盘框架

@implementation APPKeyboardApi

///设置键盘弹出
+ (void)setKeyBoardlayout {
    
    //******** 系统键盘做处理 ********
    //默认为YES，关闭为NO
    [IQKeyboardManager sharedManager].enable = YES;
    //键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //隐藏键盘上面的toolBar,默认是开启的
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
}

@end
