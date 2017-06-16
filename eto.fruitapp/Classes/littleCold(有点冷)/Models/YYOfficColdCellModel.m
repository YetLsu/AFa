//
//  YYOfficAndCustomModel.m
//  OfficAndCustomColdModel
//
//  Created by Apple on 15/12/6.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYOfficColdCellModel.h"

@implementation YYOfficColdCellModel

+ (instancetype)officAndCustomModelWithLeftTitle:(NSString *)leftTitle andTitle:(NSString *)title andContentWord:(NSString *)contentWord andPictureImage:(NSString *)pictureImageURLStr andTime:(NSString *)time andNumberZan:(NSInteger)numberZan andNumberComment:(NSInteger)numberComment andEssayURL:(NSString *)essayURLStr andBaid:(NSInteger)baid andRadius:(NSInteger)radius{
    

    return [[YYOfficColdCellModel alloc] initWithLeftTitle:leftTitle andTitle:title andContentWord:contentWord andPictureImage:pictureImageURLStr andTime:time andNumberZan:numberZan andNumberComment:numberComment andEssayURL:essayURLStr andBaid:baid andRadius:radius];
}

- (instancetype)initWithLeftTitle:(NSString *)leftTitle andTitle:(NSString *)title andContentWord:(NSString *)contentWord andPictureImage:(NSString *)pictureImageURLStr andTime:(NSString *)time andNumberZan:(NSInteger)numberZan andNumberComment:(NSInteger)numberComment andEssayURL:(NSString *)essayURLStr andBaid:(NSInteger)baid andRadius:(NSInteger)radius{
    if (self = [super init]) {
        self.leftTitle = leftTitle;
        self.title = title;
        self.contentWord = contentWord;
        self.pictureImageURLStr = pictureImageURLStr;
        self.time = time;
        self.numberZan = numberZan;
        self.numberComment = numberComment;
        self.essayURLStr = essayURLStr;
        self.baid = baid;
        self.radius = radius;
    }
    return self;
}

@end
