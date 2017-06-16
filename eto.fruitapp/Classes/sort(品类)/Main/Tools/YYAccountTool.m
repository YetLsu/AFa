//
//  YYAccountTool.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/16.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYAccountTool.h"
#define YYAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation YYAccountTool
/**
 *  取出账号信息
 */
+ (YYAccount *)account{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:YYAccountPath];
}

/**
 *  保存账号信息
 */
+ (void)saveAccount:(YYAccount *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:YYAccountPath];
}

@end
