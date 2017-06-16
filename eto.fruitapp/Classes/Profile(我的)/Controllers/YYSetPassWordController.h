//
//  YYSetPassWordController.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/2.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
//绑定新手机和修改密码用该控制器   tag表示哪个控制器,0修改密码，1修改手机号
@interface YYSetPassWordController : UIViewController
- (instancetype)initWithTag:(NSInteger)tag;
@end
