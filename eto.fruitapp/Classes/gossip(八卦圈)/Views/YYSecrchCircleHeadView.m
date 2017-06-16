//
//  YYSecrchCircleHeadView.m
//  圈子_V1
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYSecrchCircleHeadView.h"
#define YY5HeightMargin 5/667.0*heightScreen
#define YY15HeightMargin 15/667.0*heightScreen

@interface YYSecrchCircleHeadView ()
@property (nonatomic,weak) UISearchBar *searchBar;
@property (nonatomic,weak) UIButton *headImageBtn;

@end

@implementation YYSecrchCircleHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:206/255.0 alpha:1];
        //搜索框
        UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY10HeightMargin, widthScreen-2*YY16WidthMargin, 25)];
        search.backgroundColor = [UIColor clearColor];
        search.placeholder = @"搜索圈子";
        [self addSubview:search];
        self.searchBar = search;
        
        //图片
        UIButton *imageView = [[UIButton alloc]initWithFrame:CGRectMake(0, YY10HeightMargin*2+25, widthScreen, frame.size.height - YY10HeightMargin*3 - 25)];
        [imageView setImage:[UIImage imageNamed:@"bgq_searchCircle_headViewImage"] forState:UIControlStateNormal];
        [self addSubview:imageView];
        self.headImageBtn = imageView;
        [self.headImageBtn addTarget:self action:@selector(applyForSettledBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)applyForSettledBtnClick{
    YYLog(@"申请入驻");
}

@end
