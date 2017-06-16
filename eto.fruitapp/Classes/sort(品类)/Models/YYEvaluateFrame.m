//
//  YYEvaluateFrame.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYEvaluateFrame.h"
#import "YYEvaluateModel.h"
#define boundingFont [UIFont systemFontOfSize:17]

@implementation YYEvaluateFrame
- (void)setModel:(YYEvaluateModel *)model{
    _model = model;
    
    if (model.evaluate) {
        NSString *evaluate = model.evaluate;
        CGSize evaluateSize = [evaluate boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : boundingFont} context:nil].size;
        
        self.evaluateLabelFrame = CGRectMake(60, 58, evaluateSize.width, evaluateSize.height);
        self.rowHeight = 58 + evaluateSize.height + 12;
    }else{
        self.rowHeight = 58 + 12;
    }
   
}
@end
