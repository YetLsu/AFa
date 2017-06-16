//
//  YYWelcomeViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/30.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYWelcomeViewController.h"

@interface YYWelcomeViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *welcomeScrollerView;

@end

@implementation YYWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat scrollerWidth = [UIScreen mainScreen].bounds.size.width *3;
    CGFloat scrollerHeight = [UIScreen mainScreen].bounds.size.height;
    self.welcomeScrollerView.contentSize = CGSizeMake(scrollerWidth, 0);
    
    CGFloat imageHeight = scrollerHeight;
    CGFloat imageWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageY = 0;
    for (int i = 0; i < 2; i++) {
        NSString *imageName = [NSString stringWithFormat:@"welcome%d",i + 1];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        CGFloat imageX = imageWidth * i;
        
        [self.welcomeScrollerView addSubview:imageView];
        imageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
        
        
    }
    UIView *threeView = [[[NSBundle mainBundle] loadNibNamed:@"threeWelcomeView" owner:nil options:nil] lastObject];
    CGFloat imageX = imageWidth *2;
    threeView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
   
    [self.welcomeScrollerView addSubview:threeView];
    
    for (id view in threeView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
           
            //点击进入按钮添加事件
            UIButton *btn = (UIButton *)view;
            [btn addTarget:self action:@selector(enterMain) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.welcomeScrollerView.showsHorizontalScrollIndicator = NO;
    self.welcomeScrollerView.showsVerticalScrollIndicator = NO;
    self.welcomeScrollerView.pagingEnabled = YES;
    
}
- (void)enterMain{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id vc = [mainStoryboard instantiateInitialViewController];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    
}

 

@end
