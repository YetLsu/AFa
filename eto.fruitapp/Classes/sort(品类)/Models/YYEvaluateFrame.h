//
//  YYEvaluateFrame.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYEvaluateModel;
@interface YYEvaluateFrame : NSObject

@property (nonatomic, strong)YYEvaluateModel *model;

@property (nonatomic, assign) CGRect evaluateLabelFrame;
@property (nonatomic, assign) CGFloat rowHeight;
@end
