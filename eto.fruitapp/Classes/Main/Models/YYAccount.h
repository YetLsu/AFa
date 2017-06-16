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

@end
