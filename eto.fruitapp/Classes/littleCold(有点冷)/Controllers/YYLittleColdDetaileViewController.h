//
//  YYLittleColdDetaileViewController.h
//  YYLittleColdDetailTableView
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYLittleColdDetaileViewController : UIViewController
@property (nonatomic,assign) NSInteger value;

- (instancetype)initWithEssayUrl:(NSString *)essayUrlStr andessayID:(NSInteger)baid andRadius:(NSInteger)radius;

@end
