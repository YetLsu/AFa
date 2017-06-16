//
//  YYFruitDatabaseTool.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/7.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYLittleColdHotCellmodel, YYOfficColdCellModel;
@interface YYFruitDatabaseTool : NSObject

+ (instancetype)shareFruitTool;
/********---------------------有点冷数据库*****************/
/**
 *  五个置顶数据
 */
//取出五个数据
- (NSArray *)littleCold_tops;
//存入五个数据
- (void)addLittleCold_topsWithLittleColds:(NSArray *)array;
//删除五个数据
- (void)deleteLittleCold_topData;
/**
 *  热门推荐数据
 */
/**
 *  取出所有数据
 */
- (NSArray *)littleCold_hots;
/**
 *  存入一个模型数据
 */
- (void)addLittleCold_hotsWithHotCellModel:(YYLittleColdHotCellmodel *)HotCellModel;
/**
 *  删除所有数据
 */
- (void)deleteLittleCold_hotsData;
/**
 *  官方冷数据库
 */
/**
 *  全部模块取出所有数据
 */
- (NSArray *)littleCold_offic_alls;
/**
 *  全部模块存入一个模型数据
 */
- (void)addLittleCold_offic_allWithOfficColdCellModel:(YYOfficColdCellModel *)model;
/**
 *  删除所有全部模块数据
 */
- (void)deleteLittleCold_offic_alls;
/**
 *  查询当前用户是否赞过该评论(即该评论是否为1）
 *
 */
- (BOOL)selectZanCommentWithCommentID:(NSInteger)commentID;
/**
 *  赞一条评论纪录该评论id和1或0(插入一条数据)设为1
 *
 */
- (void)addZanCommentWithCommentID:(NSInteger)commentID;

@end
