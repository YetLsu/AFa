//
//  YYCircleWriteSomethingViewController.h
//  圈子_V1
//
//  Created by Apple on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYCircleModel;
@interface YYCircleWriteSomethingViewController : UIViewController
//@property (nonatomic,copy) NSString* theme;//主题



- (instancetype)initWithModel:(YYCircleModel *)model;
- (instancetype)initWithMode:(NSInteger)mode;
@end
