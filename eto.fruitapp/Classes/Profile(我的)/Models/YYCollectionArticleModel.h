//
//  YYCollectionArticleModel.h
//  eto.fruitapp
//
//  Created by Apple on 16/1/21.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCollectionArticleModel : NSObject
@property (nonatomic,copy) NSString *bccid;//收藏的文章，在文章表中的id
@property (nonatomic,copy) NSString *bcid;//收藏的id
@property (nonatomic,copy) NSString *time;//收藏的时间
@property (nonatomic,strong) NSURL *headimg;//头像的url
@property (nonatomic,strong) NSURL *img;//图片
@property (nonatomic,copy) NSString *intro;//介绍
@property (nonatomic,copy) NSString *title;//标题
@property (nonatomic,copy) NSString *userName;//作者的名字
@property (nonatomic,copy) NSString *leftTitle;//左标题

- (instancetype)initWithBccid:(NSString *)bccid withBcid:(NSString *)bcid withTime:(NSString *)time withHeadimg:(NSString *)headimg withImg:(NSString *)img withIntro:(NSString *)intro withTitle:(NSString *)title withUserName:(NSString *)userName;

@end
