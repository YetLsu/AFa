//
//  YYAccountTool.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/16.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYAccount.h"
@interface YYAccountTool : NSObject
/**
 *  取出账号信息
 */
+ (YYAccount *)account;

/**
 *  保存账号信息
 */
+ (void)saveAccount:(YYAccount *)account;
@end
