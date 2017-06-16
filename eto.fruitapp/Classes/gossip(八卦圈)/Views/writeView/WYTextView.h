//
//  WYTextView.h
//  发表消息的框
//
//  Created by Apple on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYTextView : UITextView

@property (nonatomic , copy) NSString *placeholder;
@property (nonatomic , strong) UIColor *placeholderColor;

@end
