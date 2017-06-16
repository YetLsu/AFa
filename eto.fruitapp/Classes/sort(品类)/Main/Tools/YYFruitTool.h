//
//  YYFruitTool.h
//  eto.fruitapp
//
//  Created by wyy on 15/10/28.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYShopOrderModel;
@interface YYFruitTool : NSObject

/**
 *  判断是否要更新订单信息，yes是要
 */
@property (assign, nonatomic, getter = isUpDate) BOOL upDate;
+ (instancetype)shareFruitTool;
/**
 *  加线条
 */
- (void)addLineViewWithFrame:(CGRect)frame andView:(UIView *)superView;
/**
 *  计算文字size
 */
+ (CGSize)calculateSizeWithText:(NSString *)text andFont:(UIFont *)font andSize:(CGSize)textSize;
/**
 *  获取Documents中的orders
 */
- (NSMutableArray *)ordersFromDocuments;
- (void)addOrders;
/**
 *  把order保存到Documents
 *
 */
- (void)saveOrdersToDocumentsAddOrder:(YYShopOrderModel *)order;
/**
 *  更改Documents中的最后一个model
 *
 */
- (void)changeOrderToDocumentsAddOrder:(YYShopOrderModel *)order;
/**
 *  根据颜色创建图片
 */
+ (UIImage*) createImageWithColor:(UIColor*) color;
/**
 *  把字典保存到沙盒
 */
+ (void)saveDataToSandBoxWithData:(NSDictionary *)dic andKeyPath:(NSString *)keypath;
/**
 *  从沙盒读取字典
 */
+ (void)readDataFromSandBoxWithKeyPath:(NSString *)keyPath;
@end
