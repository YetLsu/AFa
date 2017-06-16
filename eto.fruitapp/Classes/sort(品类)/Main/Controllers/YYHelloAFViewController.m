//
//  YYHelloAFViewController.m
//  eto.fruitapp
//
//  Created by Apple on 15/12/28.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYHelloAFViewController.h"
#import "YYGoLoginController.h"
#import "YYTabBarController.h"

@interface YYHelloAFViewController () <UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrolView;//滚动视图

@property (nonatomic,strong) NSArray *imageArray;//图片的数组

@end

@implementation YYHelloAFViewController

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSArray alloc]init];
        
        _imageArray = @[@"welcome1",@"welcome2",@"welcome3"];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *view1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen)];
    [self.view addSubview:view1];
    for (int i=0; i < self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageArray[i]]];
        CGRect rect = self.view.bounds;
        //rect 0,0  屏幕宽  屏幕高
        rect.origin.x = i*rect.size.width;
        [view1 addSubview:imageView];
        imageView.frame = rect;
        // NSLog(@"%@", NSStringFromCGRect(rect));
        //当循环到最后一页时，添加一个透明按钮到界面上
        if (i == self.imageArray.count-1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = rect;
            [view1 addSubview:btn];
            //[btn setBackgroundColor:[UIColor redColor]];
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    view1.contentSize = CGSizeMake(self.imageArray.count*widthScreen, heightScreen);
    view1.delegate = self;
    view1.pagingEnabled = YES;
    view1.showsHorizontalScrollIndicator = NO;
    view1.showsVerticalScrollIndicator = NO;
    self.scrolView = view1;
    
    
    //添加页数指示
    UIPageControl *pageControl = [UIPageControl new];
    //设置点的个数
    pageControl.numberOfPages = self.imageArray.count;
    //设置位置
    pageControl.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 30);
    [self.view addSubview:pageControl];
    
    pageControl.tag = 100;
    
 
}
- (void)changeScroll:(id)sender{
    UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:100];
    
    [self.scrolView setContentOffset:CGPointMake(self.view.frame.size.width *((pageControl.currentPage==2)?0:pageControl.currentPage+1), 0) animated:YES];
    
}

//当滚动视图发生滚动时 就触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取内容的偏移量，向左移动为正
    CGPoint offSet = scrollView.contentOffset;
    //把值进行四舍五入，使用round()函数
    NSInteger index = round(offSet.x/scrollView.frame.size.width);
    UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:100];
    //设置当前页
    pageControl.currentPage = index;
}

- (void)click:(id)sender{
    YYLog(@"进入");
    YYTabBarController *tabbar = [[YYTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
