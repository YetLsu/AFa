//
//  YYDynamicMessageModel.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/20.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYDynamicMessageModel.h"

@implementation YYDynamicMessageModel
- (instancetype) initWithIconUrlStr:(NSString *)iconurlStr nickName:(NSString *)nickName date:(NSString *)date dynamicMessage:(NSString *)dynamicMessage imageUrlStrsArray:(NSArray *)imagesArray shareNumber:(NSInteger)shareNumber zanNumber:(NSInteger)zanNumber attention:(NSString *)attention andBsid:(int)bsid andCommentnumber:(NSInteger)commentNumber andBuid:(NSString *)buid withFrom:(NSString *)from withTime:(long long)time withUserID:(NSInteger)userID{
    if (self = [super init]) {
        self.iconImageUrlStr = iconurlStr;
        self.nickName = nickName;
        self.date = date;
        self.dynamicMessage = dynamicMessage;
        self.imageUrlStrsArray = imagesArray;
        self.shareNumber = shareNumber;
        self.zanNumber = zanNumber;
        self.attention = attention;
        self.bsid = bsid;
        self.commentNumber = commentNumber;
        self.buid = buid;
        self.from = from;
        self.time = time;
        self.user_id = userID;
    }
    return self;
}
@end
