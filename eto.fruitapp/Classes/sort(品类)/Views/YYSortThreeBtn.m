//
//  YYSortThreeBtn.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/5.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSortThreeBtn.h"

@implementation YYSortThreeBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YYSortThreeBtn" owner:nil options:nil] lastObject];
    }
    return self;
}

@end
