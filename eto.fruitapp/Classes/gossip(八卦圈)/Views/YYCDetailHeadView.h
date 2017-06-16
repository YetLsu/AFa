//
//  YYCDetailHeadView.h
//  圈子_V1
//
//  Created by Apple on 15/12/19.
//  Copyright © 2015年 Apple. All rights reserved.
//  修改：添加了协议，并在点击事件中实现了协议方法

#import <UIKit/UIKit.h>
//修改
@class YYCDetailHeadViewDelegate,YYDynamicMessageModel;
@protocol YYCDetailHeadViewDelegate <NSObject>

- (void)pushToPersonViewControl:(YYDynamicMessageModel *)model;
- (void)attationBtnGuanZhuWith:(NSString *)attation bfuid:(NSString *)bfuid;

- (void)attationBtnQuGuanWith:(NSString *)attation bfuid:(NSString *)bfuid;
/** 图片放大 */
- (void)enlargePicture:(NSInteger)tag;

@end

@class YYDynamicMessageModel;
@interface YYCDetailHeadView : UIView
@property (nonatomic,strong) YYDynamicMessageModel *model;
@property (nonatomic,assign) CGFloat viewHeight;
@property (nonatomic,weak) UIButton *goToPersonBtn;
@property (nonatomic,weak) id<YYCDetailHeadViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame;


@end
