//
//  YYProfileDataBase.m
//  eto.fruitapp
//
//@property (nonatomic,copy) NSString *titleNotic;
//@property (nonatomic,copy) NSString *userSay;
//@property (nonatomic,copy) NSString *contentNotic;
//@property (nonatomic,copy) NSString *date;
//@property (nonatomic,assign, getter=isRead) BOOL read;

//  Created by wyy on 15/12/14.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYProfileDataBase.h"

#import "YYNoticCenterModel.h"

@interface YYProfileDataBase ()
/**
 *  我的数据库
 */
@property (nonatomic, strong) FMDatabase *profileCacheDB;

@end

@implementation YYProfileDataBase
- (FMDatabase *)profileCacheDB{
    if(!_profileCacheDB){
        // 1.打开数据库
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"profileCacheDataBase.sqlite"];
        
        _profileCacheDB = [FMDatabase databaseWithPath:path];
        
        [_profileCacheDB open];
        
        // 2.创表
        
        [_profileCacheDB executeUpdate:@"CREATE TABLE IF NOT EXISTS t_profile_notifications (id integer PRIMARY KEY, titleNotic text NOT NULL, userSay text NOT NULL, contentNotic text, date text NOT NULL, read integer NOT NULL);"];
        
        [_profileCacheDB close];
    }
 
    return _profileCacheDB;
}
//取出所有数据
- (NSMutableArray *)profile_notifications{
    [self.profileCacheDB open];
    FMResultSet *set = [self.profileCacheDB executeQuery:@"SELECT * FROM t_profile_notifications;"];
    
    NSMutableArray *notificationsArray = [NSMutableArray array];
    
    while (set.next) {
        
        YYNoticCenterModel *model = [YYNoticCenterModel noticWithTiTle:[set stringForColumnIndex:1] withUserSay:[set stringForColumnIndex:2] withContentNotic:[set stringForColumnIndex:3] withDate:[set stringForColumnIndex:4] withRead:[set intForColumnIndex:5] withNoticID:0];
        [notificationsArray addObject:model];
    }
    [self.profileCacheDB close];
    
    return notificationsArray;
}
//存入一个数据
- (void)addprofile_notification:(YYNoticCenterModel *)model{
    [self.profileCacheDB open];
   
    [self.profileCacheDB executeUpdateWithFormat:@"INSERT INTO t_profile_notifications(id, titleNotic, userSay, contentNotic, date, read) VALUES (%ld, %@, %@, %@, %@, %d);",model.noticID, model.titleNotic, model.userSay, model.contentNotic, model.date, model.read];
    
    [self.profileCacheDB close];
}
//删除一个数据
- (void)deleteprofile_notification:(YYNoticCenterModel *)model{
    [self.profileCacheDB open];
    NSString *str = [NSString stringWithFormat:@"DELETE FROM t_profile_notifications WHERE id=%ld",model.noticID];
    BOOL isSuccess = [self.profileCacheDB executeUpdate:str];
    if (!isSuccess) {
        if (!isSuccess) {
            NSLog(@"hot删除失败:%@",[self.profileCacheDB lastError]);
        }
        
    }
    
    [self.profileCacheDB close];

}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static YYProfileDataBase *databaseTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseTool = [super allocWithZone:zone];
    });
    return databaseTool;
}
+ (instancetype)shareProfileDataBase{
    return [[self alloc] init];
}
@end
