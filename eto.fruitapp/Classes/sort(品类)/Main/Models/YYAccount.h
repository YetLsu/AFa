//
//  YYAccount.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/16.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define YYUserUID @"YYUserUID"
#define YYUserPhone @"YYUserPhone"
#define YYUserIconImage @"YYUserIconImage"
#define YYUserNickName @"YYUserNickName"
#define YYUserIconStr @"YYUserIconStr"
#define YYUserBackgroundUrlStr @"YYUserBackgroundUrlStr"
#define YYUserBackgroundImage @"YYUserBackgroundImage"
#define YYUserLanded @"YYUserLanded"
@interface YYAccount : NSObject<NSCoding>
//用户昵称
@property (nonatomic, copy) NSString *userNickName;
//用户手机号
@property (nonatomic, copy) NSString *userPhone;
//用户头像
@property (nonatomic, strong) UIImage *userIconImage;
//用户UID
@property (nonatomic, copy) NSString *userUID;

//用户头像URLStr
@property (nonatomic, copy) NSString *userIconUrlStr;

//用户个人中心的背景颜色URLStr
@property (nonatomic, copy) NSString *userBackgroundUrlStr;

//用户个人中心的背景图片
@property (nonatomic, strong) UIImage *userBackgroundImage;

//用户是否第一次登陆过
@property (nonatomic, copy) NSString *landed;

@end
