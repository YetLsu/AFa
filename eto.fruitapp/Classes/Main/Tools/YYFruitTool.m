//
//  YYFruitTool.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/28.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYFruitTool.h"
#import "YYShopOrderModel.h"
#define YYOrderStatePath @"orderState.achieve"

@implementation YYFruitTool
#pragma mark 根据颜色创建图片
+ (UIImage*)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0, 0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static YYFruitTool *fruitTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fruitTool = [super allocWithZone:zone];
    });
    return fruitTool;
}
+ (instancetype)shareFruitTool{
    return [[self alloc] init];
}

#pragma mark 计算文字size
+ (CGSize)calculateSizeWithText:(NSString *)text andFont:(UIFont *)font andSize:(CGSize)textSize{
    NSDictionary *attr = @{
                           NSFontAttributeName : font
                           };
    return [text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;

}
#pragma mark 添加线条
- (void)addLineViewWithFrame:(CGRect)frame andView:(UIView *)superView{
    UIView *view = [[UIView alloc] init];
    [superView addSubview:view];
    view.frame = frame;
    view.backgroundColor = YYGrayLineColor;
}
/**
 *  获取Documents中的orders
 */
- (NSMutableArray *)ordersFromDocuments{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    NSString *docPath = [path stringByAppendingPathComponent:YYOrderStatePath];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:docPath];
    
}
/**
 *  把order保存到Documents
 *
 */
- (void)saveOrdersToDocumentsAddOrder:(YYShopOrderModel *)order{
    NSMutableArray *orders = [self ordersFromDocuments];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    NSString *docPath = [path stringByAppendingPathComponent:YYOrderStatePath];
    
    [orders addObject:order];
    [NSKeyedArchiver archiveRootObject:orders toFile:docPath];
}
/**
 *  更改Documents中的最后一个model
 *
 */
- (void)changeOrderToDocumentsAddOrder:(YYShopOrderModel *)order{
    NSMutableArray *orders = [self ordersFromDocuments];
    
    [orders removeLastObject];
    
    [self saveOrdersToDocumentsAddOrder:order];
}
/**
 *  添加订单
 */
- (void)addOrders{
    YYShopOrderModel *model = [[YYShopOrderModel alloc] init];
    model.orderState = YYOrderStateNeedPay;
    model.shopImage = [UIImage imageNamed:@"sort_cherry"];
    model.shopName = @"老王水果店";
    model.orderDate = @"2015-10-28 17:40:33";
    model.number = 2;
    model.price = 15.00;
    
    YYShopOrderModel *model1 = [[YYShopOrderModel alloc] init];
    model1.orderState = YYOrderStateCancel;
    model1.shopImage = [UIImage imageNamed:@"sort_cherry"];
    model1.shopName = @"老王水果店";
    model1.orderDate = @"2015-10-28 17:40:33";
    model1.number = 1;
    model1.price = 15.00;
   
    
    YYShopOrderModel *model2 = [[YYShopOrderModel alloc] init];
    model2.orderState = YYORderStateFinishOrder;
    model2.shopImage = [UIImage imageNamed:@"sort_cherry"];
    model2.shopName = @"老王水果店";
    model2.orderDate = @"2015-10-28 17:40:33";
    model2.number = 1;
    model2.price = 15.00;
    
    
    YYShopOrderModel *model3 = [[YYShopOrderModel alloc] init];
    model3.orderState = YYOrderStateFinishPay;
    model3.shopImage = [UIImage imageNamed:@"sort_cherry"];
    model3.shopName = @"老王水果店";
    model3.orderDate = @"2015-10-28 17:40:33";
    model3.number = 1;
    model3.price = 15.00;
    
    
    YYShopOrderModel *model4 = [[YYShopOrderModel alloc] init];
    model4.orderState = YYOrderStateWaitSaller;
    model4.shopImage = [UIImage imageNamed:@"sort_cherry"];
    model4.shopName = @"老王水果店";
    model4.orderDate = @"2015-10-28 17:40:33";
    model4.number = 1;
    model4.price = 15.00;
   
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    NSString *docPath = [path stringByAppendingPathComponent:YYOrderStatePath];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:model];
    [array addObject:model1];
    [array addObject:model2];
    [array addObject:model3];
    [array addObject:model4];
    [NSKeyedArchiver archiveRootObject:array toFile:docPath];
}
/**
 *  把字典保存到沙盒
 */
+ (void)saveDataToSandBoxWithData:(NSDictionary *)dic andKeyPath:(NSString *)keypath{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setValue:dic forKeyPath:keypath];
    [userDefault synchronize];
}
/**
 *  从沙盒读取字典
 */
+ (void)readDataFromSandBoxWithKeyPath:(NSString *)keyPath{
    
}
@end
