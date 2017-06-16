//
//  YYPersonCellModel.m
//  圈子_V1
//
//  Created by Apple on 15/12/18.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYPersonCellModel.h"

@implementation YYPersonCellModel

+ (id)personCellModelWithPersonCellID:(NSInteger)personCellID withLeftImageName:(NSString *)leftImageName withUserName:(NSString *)userName withTime:(NSString *)time withTheme:(NSString *)theme withContent:(NSString *)content withPicArray:(NSArray *)picArray withShareNumber:(NSInteger)shareNumber withZanNumber:(NSInteger)zanNumber withAtt:(BOOL) att{
    return [[self alloc] initWithPersonCellID:personCellID withLeftImageName:leftImageName withUserName:userName withTime:time withTheme:theme withContent:content withPicArray:picArray withShareNumber:shareNumber withZanNumber:zanNumber withAtt:att];
}

- (id)initWithPersonCellID:(NSInteger)personCellID withLeftImageName:(NSString *)leftImageName withUserName:(NSString *)userName withTime:(NSString *)time withTheme:(NSString *)theme withContent:(NSString *)content withPicArray:(NSArray *)picArray withShareNumber:(NSInteger)shareNumber withZanNumber:(NSInteger)zanNumber withAtt:(BOOL) att{
    if (self = [super init]) {
        self.personCellID = personCellID;
        self.leftImageName = leftImageName;
        self.userName = userName;
        self.time = time;
        self.theme = theme;
        self.content = content;
        self.picArray = picArray;
        self.shareNumber =shareNumber;
        self.zanNumber = zanNumber;
        self.att = att;
        
    }
    return self;
}


@end
