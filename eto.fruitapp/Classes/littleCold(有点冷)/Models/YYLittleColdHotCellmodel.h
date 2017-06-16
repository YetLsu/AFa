//
//  YYLittleColdDownCellmodel.h
//  Model12_5
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYLittleColdHotCellmodel : NSObject

@property (nonatomic,strong) UIImage *leftImage;//左图
@property (nonatomic,copy) NSString *leftTitle;//左标题
@property (nonatomic,copy) NSString *title;//标题
@property (nonatomic,copy) NSString *content;//内容
#warning 时间可以改的话改成NSDate
@property (nonatomic,copy) NSString *time;//时间
@property (nonatomic,assign) NSInteger numberOfZan;//赞数
@property (nonatomic,assign) NSInteger numberOfComment;//评论数


- (instancetype)initWithLittleColdDownCellmodel:(UIImage *)leftImage withLeftLabel:(NSString *)leftTitle withTitle:(NSString *)title withContent:(NSString *)content withNumberOfZan:(NSInteger)numberOfZan withNumberOfComment:(NSInteger)numberOfComment withTime:(NSString *)time;


@end
