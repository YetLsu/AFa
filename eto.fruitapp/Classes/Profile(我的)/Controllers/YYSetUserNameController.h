//
//  YYSetUserNameController.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/2.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
//修改用户名和输入原密码用该控制器
@class YYSetUserNameController;

@protocol YYSetUserNameControllerDelegate <NSObject>

@optional
- (void)setNickNameOnProfile;

@end

@interface YYSetUserNameController : UIViewController

@property (nonatomic, weak)id<YYSetUserNameControllerDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title placedor:(NSString *)placedor footTexe:(NSString *)footText andTag:(NSInteger)tag;
@end
