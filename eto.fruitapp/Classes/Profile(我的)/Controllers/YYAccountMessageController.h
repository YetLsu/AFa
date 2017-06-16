//
//  YYAccountMessageController.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/1.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYAccountMessageController;

@protocol YYAccountMessageControllerDelegate <NSObject>

@optional
- (void)setUserIcon:(UIImage *)image;

@end
@interface YYAccountMessageController : UIViewController

@property (nonatomic, weak) id<YYAccountMessageControllerDelegate> delegate;
@end
