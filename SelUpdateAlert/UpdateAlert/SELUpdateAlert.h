//
//  SELUpdateAlert.h
//  test
//
//  Created by GTO on 2018/8/27.
//  Copyright © 2018年 GTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SELUpdateAlert : UIView
/**
 添加版本更新提示
 
 @param version 版本号
 @param descriptions 版本更新内容（数组）
 
 descriptions 格式如 @[@"1.xxxxxx",@"2.xxxxxx"]
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version Descriptions:(NSArray *)descriptions;

/**
 添加版本更新提示
 
 @param version 版本号
 @param description 版本更新内容（字符串）
 
 description 格式如 @"1.xxxxxx\n2.xxxxxx"
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version Description:(NSString *)description updateType:(BOOL)type;


@end
