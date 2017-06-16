//
//  YYOfficAndCustomModel.h
//  OfficAndCustomColdModel
//
//  Created by Apple on 15/12/6.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYOfficColdCellModel : NSObject

@property (nonatomic,copy) NSString *leftTitle;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *contentWord;
@property (nonatomic,copy) NSString *pictureImageURLStr;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,assign) NSInteger numberZan;
@property (nonatomic,assign) NSInteger numberComment;
@property (nonatomic, copy) NSString *essayURLStr;
@property (nonatomic, assign) NSInteger baid;
@property (nonatomic,assign) NSInteger radius;

+ (instancetype)officAndCustomModelWithLeftTitle:(NSString *)leftTitle andTitle:(NSString *)title andContentWord:(NSString *)contentWord andPictureImage:(NSString *)pictureImageURLStr andTime:(NSString *)time andNumberZan:(NSInteger)numberZan andNumberComment:(NSInteger)numberComment andEssayURL:(NSString *)essayURLStr andBaid:(NSInteger)baid andRadius:(NSInteger) radius;

@end
