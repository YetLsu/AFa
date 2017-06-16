//
//  YYHomeNewBigTestModel.h
//  eto.fruitapp
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 wyy. All rights reserved.
//  逼格测试与格调指南的模型

#import <Foundation/Foundation.h>

@interface YYHomeNewBigTestModel : NSObject
@property (nonatomic,strong) NSURL *iconUrl;//头像
@property (nonatomic,copy) NSString *authorName;//用户名
@property (nonatomic,copy) NSString *title;//主题
@property (nonatomic,strong) NSURL *imagePicUrl;//内容图片
@property (nonatomic,assign) NSInteger bid;//id：哪一期
@property (nonatomic,strong) NSURL *contentURL;//包含的URL
@property (nonatomic,copy) NSString *intro;//介绍

@property (nonatomic,assign) long long date;

- (instancetype)initWithIcon:(NSString *)icon withAuthorName:(NSString *)authorName withTItle:(NSString *)title withImagePic:(NSString *)imagePic withBid:(NSInteger)bid withContentURL:(NSString *)content withIntro:(NSString *)intro withDate:(long long)date;


@end
