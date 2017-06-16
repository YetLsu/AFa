//
//  YYPersonCellModel.h
//  圈子_V1
//
//  Created by Apple on 15/12/18.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYPersonCellModel : NSObject

@property (nonatomic,assign) NSInteger personCellID;//id
@property (nonatomic,copy) NSString *leftImageName;//头像名
@property (nonatomic,copy) NSString *userName;//用户名
@property (nonatomic,copy) NSString *time;//时间
@property (nonatomic,copy) NSString *theme; //主题
@property (nonatomic,copy) NSString *content;//内容
@property (nonatomic,strong) NSArray *picArray;//图片集合
@property (nonatomic,assign) NSInteger shareNumber;//分享数
@property (nonatomic,assign) NSInteger zanNumber;//赞数
@property (nonatomic) BOOL att;//是否关注 关注为YES 未关注为NO

+(id)personCellModelWithPersonCellID:(NSInteger)personCellID withLeftImageName:(NSString *)leftImageName withUserName:(NSString *)userName withTime:(NSString *)time withTheme:(NSString *)theme withContent:(NSString *)content withPicArray:(NSArray *)picArray withShareNumber:(NSInteger)shareNumber withZanNumber:(NSInteger)zanNumber withAtt:(BOOL) att;

@end
