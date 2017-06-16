//
//  YYFruitDatabaseTool.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/7.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYFruitDatabaseTool.h"
#import "FMDB.h"

#import "YYLittleColdHotCellmodel.h"
#import "YYOfficColdCellModel.h"

@interface YYFruitDatabaseTool ()
/**
 *  有点冷置顶数据库存放置顶数据以及是否评论数据
 */
@property (nonatomic, strong) FMDatabase *littleCold_topdb;
/**
 *  有点冷推荐数据库
 */
@property (nonatomic, strong) FMDatabase *littleCold_hotdb;
/**
 *  有点冷官方冷数据库
 */
@property (nonatomic, strong) FMDatabase *littleCold_offic_alldb;
@end
@implementation YYFruitDatabaseTool
/**
 *  有点冷置顶数据库
 */
- (FMDatabase *)littleCold_topdb{
    if (!_littleCold_topdb) {
        
        // 1.打开数据库
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"littleColdTops.sqlite"];
       
        _littleCold_topdb = [FMDatabase databaseWithPath:path];
        
        [_littleCold_topdb open];
        
        // 2.创表
        
        [_littleCold_topdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_littleCold_top (id integer PRIMARY KEY, title text NOT NULL);"];
        //创建是否评论表
        [_littleCold_topdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_littleCold_userCommentBool (id integer PRIMARY KEY, commentID integer NOT NULL, commentBOOL integer);"];
        [_littleCold_topdb close];

    }
    return _littleCold_topdb;
}
/**
 *  是否赞过某条评论的数据库
 *
 */
/**
 *  赞一条评论纪录该评论id和1或0(插入一条数据)设为1
 *
 */
- (void)addZanCommentWithCommentID:(NSInteger)commentID{
    [self.littleCold_topdb open];
    
    [self.littleCold_topdb executeUpdateWithFormat:@"INSERT INTO t_littleCold_userCommentBool(commentID, commentBOOL) VALUES (%ld, 1);",commentID];
    
    [self.littleCold_topdb close];
}
/**
 *  查询当前用户是否赞过该评论(即该评论是否为1）
 *
 */
- (BOOL)selectZanCommentWithCommentID:(NSInteger)commentID{
    [self.littleCold_topdb open];
    
    NSString *str = [NSString stringWithFormat:@"SELECT * FROM t_littleCold_userCommentBool WHERE commentID=%ld;",commentID];
    // 得到结果集
    FMResultSet *set = [self.littleCold_topdb executeQuery:str];
    BOOL commentBOOL = NO;
    if (set.next) {
        commentBOOL = [set intForColumn:@"commentBOOL"];
    }
    [self.littleCold_topdb close];
    
    return commentBOOL;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static YYFruitDatabaseTool *databaseTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseTool = [super allocWithZone:zone];
    });
    return databaseTool;
}
+ (instancetype)shareFruitTool{
    return [[self alloc] init];
}
/********---------------------有点冷数据库*****************/
/**
 *  五个置顶数据
 */
//取出五个数据
- (NSArray *)littleCold_tops{
    [self.littleCold_topdb open];
    // 得到结果集
    FMResultSet *set = [self.littleCold_topdb executeQuery:@"SELECT * FROM t_littleCold_top;"];
    
    // 不断往下取数据
    NSMutableArray *titles = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        NSString *title = [set stringForColumn:@"title"];
        [titles addObject:title];
    }
    [self.littleCold_topdb close];
    return titles;

}
//存入五个数据
- (void)addLittleCold_topsWithLittleColds:(NSArray *)array{
    [self.littleCold_topdb open];
    for (NSString *title in array) {
        [self.littleCold_topdb executeUpdateWithFormat:@"INSERT INTO t_littleCold_top(title) VALUES (%@);",title];
    }
    [self.littleCold_topdb close];
}
//删除五个数据
- (void)deleteLittleCold_topData{
    [self.littleCold_topdb open];
    BOOL isSuccess = [self.littleCold_topdb executeUpdate:@"delete from t_littleCold_top"];
    if (!isSuccess) {
        NSLog(@"top删除失败:%@",[self.littleCold_topdb lastError]);
    }
    
    [self.littleCold_topdb close];

}
/**
 *  热门推荐数据
 */
/**
 *  有点冷推荐数据库
 */
- (FMDatabase *)littleCold_hotdb{
    if (!_littleCold_hotdb) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"littleColdHots.sqlite"];
        
        _littleCold_hotdb = [FMDatabase databaseWithPath:path];
        
        [_littleCold_hotdb open];
        
        [_littleCold_hotdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_littleCold_hot (id integer PRIMARY KEY, leftImage blob, sortTitle text, title text, textBody text, date text, zan integer, commentNumber integer);"];
        
        [_littleCold_hotdb close];
    }
    return _littleCold_hotdb;
}

/**
 *  取出所有数据
 */
- (NSArray *)littleCold_hots{
    [self.littleCold_hotdb open];
    FMResultSet *set = [self.littleCold_hotdb executeQuery:@"SELECT * FROM t_littleCold_hot;"];
    
    NSMutableArray *hotsArray = [NSMutableArray array];
    
    while (set.next) {
        NSData *imageData = [set dataForColumn:@"leftImage"];
        UIImage *leftImage = [[UIImage alloc]initWithData:imageData];
        
        YYLittleColdHotCellmodel *model = [[YYLittleColdHotCellmodel alloc] initWithLittleColdDownCellmodel:leftImage withLeftLabel:[set stringForColumn:@"sortTitle"] withTitle:[set stringForColumn:@"title"] withContent:[set stringForColumn:@"textBody"] withNumberOfZan:[set intForColumn:@"zan"] withNumberOfComment:[set intForColumn:@"commentNumber"] withTime:[set stringForColumn:@"date"]];
        
        [hotsArray addObject:model];
    }
    [self.littleCold_hotdb close];
    
    return hotsArray;
}
/**
 *  存入一个模型数据
 */
- (void)addLittleCold_hotsWithHotCellModel:(YYLittleColdHotCellmodel *)HotCellModel{
    [self.littleCold_hotdb open];
    NSData *imageData = UIImagePNGRepresentation(HotCellModel.leftImage);
    [self.littleCold_hotdb executeUpdateWithFormat:@"INSERT INTO t_littleCold_hot(leftImage, sortTitle, title, textBody, date, zan, commentNumber) VALUES (%@, %@, %@, %@, %@, %ld, %ld);", imageData, HotCellModel.leftTitle, HotCellModel.title, HotCellModel.content, HotCellModel.time, (long)HotCellModel.numberOfComment, (long)HotCellModel.numberOfZan];
    
    [self.littleCold_hotdb close];
    
    
}
/**
 *  删除所有数据
 */
- (void)deleteLittleCold_hotsData{
    [self.littleCold_hotdb open];
    BOOL isSuccess = [self.littleCold_hotdb executeUpdate:@"DELETE from t_littleCold_hot;"];
    if (!isSuccess) {
        if (!isSuccess) {
            NSLog(@"hot删除失败:%@",[self.littleCold_hotdb lastError]);
        }

    }
    
    [self.littleCold_hotdb close];
}
/**
 *  官方冷数据库
*/
- (FMDatabase *)littleCold_offic_alldb{
    if (!_littleCold_offic_alldb) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"littleColdOfficAll.sqlite"];
        
        _littleCold_offic_alldb = [FMDatabase databaseWithPath:path];
        
        BOOL open = [_littleCold_offic_alldb open];
        if (!open) {
            YYLog(@"error");
        }
        
        [_littleCold_offic_alldb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_littleCold_offic_all (id integer PRIMARY KEY, leftTitle text, title text, contentWord text, pictureImage blob , time text, numberZan integer, numberComment integer);"];
        
        [_littleCold_offic_alldb close];
    }
    return _littleCold_offic_alldb;
}
/**
 *  全部模块取出所有数据
 */
//- (NSArray *)littleCold_offic_alls{
//    [self.littleCold_offic_alldb open];
//    
//    FMResultSet *set = [self.littleCold_offic_alldb executeQuery:@"SELECT * FROM t_littleCold_offic_all;"];
//    
//    NSMutableArray *allsArray = [NSMutableArray array];
//    
//    while (set.next) {
//        NSData *imageData = [set dataForColumn:@"pictureImage"];
//        UIImage *pictureImage = [[UIImage alloc]initWithData:imageData];
//        
//        
//        YYOfficColdCellModel *model = [YYOfficColdCellModel officAndCustomModelWithLeftTitle:[set stringForColumn:@"leftTitle"] andTitle:[set stringForColumn:@"title"] andContentWord:[set stringForColumn:@"contentWord"] andPictureImage:pictureImage andTime:[set stringForColumn:@"time"] andNumberZan:[set intForColumn:@"numberZan"] andNumberComment:[set intForColumn:@"numberComment"]];
//        
//        [allsArray addObject:model];
//    }
//    [self.littleCold_offic_alldb close];
//    
//    return allsArray;
//
//}
/**
 *  全部模块存入一个模型数据(id integer PRIMARY KEY, leftTitle text, title text, contentWord, text, pictureImage blob , time text, numberZan integer, numberComment integer);"];

 */
- (void)addLittleCold_offic_allWithOfficColdCellModel:(YYOfficColdCellModel *)model{
    [self.littleCold_offic_alldb open];
//    NSData *imageData = UIImagePNGRepresentation(model.pictureImage);
    
//    [self.littleCold_offic_alldb executeUpdateWithFormat:@"INSERT INTO t_littleCold_offic_all(leftTitle, title, contentWord, pictureImage, time, numberZan, numberComment) VALUES (%@, %@, %@, %@, %@, %ld, %ld);", model.leftTitle,model.title, model.contentWord, imageData, model.time, model.numberZan, model.numberComment];
//    
    [self.littleCold_offic_alldb close];
}
/**
 *  删除所有全部模块数据
 */
- (void)deleteLittleCold_offic_alls{
    [self.littleCold_offic_alldb open];
    BOOL isSuccess = [self.littleCold_offic_alldb executeUpdate:@"DELETE from t_littleCold_offic_all"];
    if (!isSuccess) {
        if (!isSuccess) {
            NSLog(@"t_littleCold_offic_all删除失败:%@",[self.littleCold_offic_alldb lastError]);
        }
        
    }
    
    [self.littleCold_offic_alldb close];
}
@end
