//
//  YYShopMessageFrame.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/10.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYShopMessageFrame.h"
#import "YYShopMessageModel.h"
@implementation YYShopMessageFrame
- (void)setModel:(YYShopMessageModel *)model{
//    10.40
    _model = model;
    
    NSString *label = model.text;
    //label宽度左边减掉40，右边减掉110
    CGSize labelSize = [label boundingRectWithSize:CGSizeMake(225, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}context:nil].size;
    //label的x为40固定
    if (labelSize.height > 40) {//上边间距短一点Y ＝ 6
        self.labelFrame = CGRectMake(40, 6, 225, labelSize.height);
        self.rowHeight = 6 + labelSize.height + 6;
    }else{//只有一行文字，高为40
        self.labelFrame = CGRectMake(40, 10, 225, 20);
        self.rowHeight = 40;
    }
    
    if (model.rightIcon) {//宽高都为26；
        self.rightIconFrame = CGRectMake(333, 10, 26, 26);
    }
}
@end
