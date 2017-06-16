//
//  YYDynamicMessageModel.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/20.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYDynamicMessageModel : NSObject
//头像图片的URL字符串
@property (nonatomic, copy) NSString *iconImageUrlStr;
//昵称
@property (nonatomic, copy) NSString *nickName;
//时间
@property (nonatomic, copy) NSString *date;
//用户发的动态
@property (nonatomic, copy) NSString *dynamicMessage;
//用户图片URL字符串的数组
@property (nonatomic, strong) NSArray *imageUrlStrsArray;
//被转发次数
@property (nonatomic, assign) NSInteger shareNumber;
//被赞次数
@property (nonatomic, assign) NSInteger zanNumber;
//是否已关注
@property (nonatomic, copy) NSString *attention;
//说说ID 或者  帖子ID
@property (nonatomic, assign) int bsid;
//评论数
@property (nonatomic,assign)NSInteger commentNumber;
//发说说的那个人的id
@property (nonatomic,copy) NSString *buid;
//判断从是说说还是帖子:1.来自说说 2.来自帖子
@property (nonatomic,copy) NSString *from;

//从1970.0.0到现在的秒数
@property (nonatomic,assign) long long int time;

//用户在数据库中的数字id

@property (nonatomic,assign) NSInteger user_id;



- (instancetype) initWithIconUrlStr:(NSString *)iconurlStr nickName:(NSString *)nickName date:(NSString *)date dynamicMessage:(NSString *)dynamicMessage imageUrlStrsArray:(NSArray *)imagesArray shareNumber:(NSInteger)shareNumber zanNumber:(NSInteger)zanNumber attention:(NSString *)attention andBsid:(int)bsid andCommentnumber:(NSInteger)commentNumber andBuid:(NSString *)buid withFrom:(NSString *)from withTime:(long long int)time withUserID:(NSInteger)userID;
@end
