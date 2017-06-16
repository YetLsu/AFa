//
//  threeBtnView.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/4.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "threeBtnView.h"


@interface threeBtnView ()

@end

@implementation threeBtnView

- (instancetype)initWithThreeBtn{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"threeBtnView" owner:nil options:nil] lastObject];
    }
    return self;
}

@end
