//
//  YYSearchCircleController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/21.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSearchCircleController.h"
#import "YYAllSearchCircleController.h"
#import "YYLifeSearchCircleController.h"
#import "YYCookSearchViewController.h"
#import "YYHealthSearchViewController.h"
#import "YYRecipeSearchViewController.h"
#import "YYCircleDetailTableViewController.h"
#import "YYCircleModel.h"

@interface YYSearchCircleController ()<UIScrollViewDelegate, YYAllSearchCircleControllerDelegate,YYLifeSearchCircleControllerDelegate,YYCookSearchViewControllerDelegate,YYHealthSearchViewControllerDelegate,YYRecipeSearchViewControllerDelegate>
//按钮下方的黄线
@property (nonatomic, strong) UIView *lineView;
//存放五个按钮的View
@property (nonatomic, weak) UIView *btnsView;

@property (nonatomic, weak) UIScrollView *scrollerView;

@property (nonatomic, strong) YYAllSearchCircleController *allController;
@property (nonatomic, weak) UITableView *allTableView;

@property (nonatomic, strong) YYLifeSearchCircleController *lifeController;
@property (nonatomic, weak) UITableView *lifeTableView;

@property (nonatomic,strong) YYCookSearchViewController *cookController;
@property (nonatomic,weak) UITableView *cookTableView;

@property (nonatomic,strong) YYHealthSearchViewController *healthController;
@property (nonatomic,weak) UITableView *headthTableView;

@property (nonatomic,strong) YYRecipeSearchViewController *recipeController;
@property (nonatomic,weak) UITableView *recipeTableView;
@end

@implementation YYSearchCircleController
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(YY16WidthMargin, 38, 55, 2)];
        _lineView.backgroundColor = [UIColor colorWithRed:194/255.0 green:166/255.0 blue:51/255.0 alpha:1];
    }
    return _lineView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找圈子";
    self.view.backgroundColor = YYViewBGColor;
    UIImage *image = [UIImage imageNamed:@"bgq_searchCircle_search"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchRightCircle)];
    
    //增加顶部的五个按钮
    [self addBtnsTopViewWithFrame:CGRectMake(0, 64, widthScreen, 40)];
    //增加下面的灰线
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(0, 104, widthScreen, 0.5) andView:self.view];
    
    //增加scroller View
    [self addScrollerViewWithScrollerViewFrame:CGRectMake(0, 104.5, widthScreen, heightScreen-104.5)];
    
    
}
#pragma mark 找圈子页面右边按钮被点击
- (void)searchRightCircle{
    YYLog(@"找圈子页面右边按钮被点击");
}
#pragma mark 增加scroller View
- (void)addScrollerViewWithScrollerViewFrame:(CGRect)scrollerFrame{
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:scrollerFrame];
    [self.view addSubview:scrollerView];
    self.scrollerView = scrollerView;
    
    scrollerView.delegate = self;
    scrollerView.pagingEnabled = YES;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;
    
    scrollerView.contentSize = CGSizeMake(widthScreen * 5, scrollerFrame.size.height);
    //增加全部
    self.allController = [[YYAllSearchCircleController alloc] init];
    self.allController.delegate = self;
    self.allTableView = self.allController.allTableView;
    self.allTableView.frame = CGRectMake(0, 0, widthScreen, heightScreen - 104);
    [scrollerView addSubview:self.allTableView];
    //增加养生
    self.lifeController = [[YYLifeSearchCircleController alloc] init];
    self.lifeController.delegate = self;
    self.lifeTableView = self.lifeController.lifeTableView;
    self.lifeTableView.frame = CGRectMake(widthScreen, 0, widthScreen, heightScreen - 104);
    [scrollerView addSubview:self.lifeTableView];
    //增加美食
    self.cookController = [[YYCookSearchViewController alloc] init];
    self.cookController.delegate = self;
    self.cookTableView = self.cookController.cookTableView;
    self.cookTableView.frame = CGRectMake(widthScreen*2, 0, widthScreen, heightScreen - 104);
    [scrollerView addSubview:self.cookTableView];
    //增加健康
    self.healthController = [[YYHealthSearchViewController alloc] init];
    self.healthController.delegate = self;
    self.headthTableView = self.healthController.headlthTableView;
    self.headthTableView.frame = CGRectMake(widthScreen*3, 0, widthScreen, heightScreen - 104);
    [scrollerView addSubview:self.headthTableView];
    //增加美食
    self.recipeController = [[YYRecipeSearchViewController alloc] init];
    self.recipeController.delegate = self;
    self.recipeTableView = self.recipeController.recipeTableView;
    self.recipeTableView.frame = CGRectMake(widthScreen*4, 0, widthScreen, heightScreen - 104);
    [scrollerView addSubview:self.recipeTableView];
    
}
#pragma mark增加顶部的五个按钮
- (void)addBtnsTopViewWithFrame:(CGRect)btnsViewFrame{
    UIView *btnsView = [[UIView alloc] initWithFrame:btnsViewFrame];
    [self.view addSubview:btnsView];
    self.btnsView = btnsView;
    btnsView.backgroundColor = [UIColor whiteColor];
    //增加线
    [btnsView addSubview:self.lineView];
    
    //按钮宽53，高40
    CGFloat btnW = 55;
    CGFloat btnH = 38;
    CGFloat btnX = YY16WidthMargin;
    CGFloat btnY = 0;
    for (int i = 0; i < 5; i++) {
        btnX = YY16WidthMargin + i * btnW;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.tag = i;
        [btnsView addSubview:btn];
        switch (i) {
            case 0:
                [self btnSetTitleWithBtn:btn andTitle:@"全部"];
                break;
            case 1:
                [self btnSetTitleWithBtn:btn andTitle:@"养生"];
                break;
            case 2:
                [self btnSetTitleWithBtn:btn andTitle:@"烹饪"];
                break;
            case 3:
                [self btnSetTitleWithBtn:btn andTitle:@"健康"];
                break;
            case 4:
                [self btnSetTitleWithBtn:btn andTitle:@"食谱"];
                break;
                
            default:
                break;
        }
    }
    
}
#pragma mark 设置按钮
- (void)btnSetTitleWithBtn:(UIButton *)btn andTitle:(NSString *)title{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:YYYellowTextColor forState:UIControlStateHighlighted];
    [btn setTitleColor:YYYellowTextColor forState:UIControlStateSelected];
    
    [btn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnsClickOneWithBtn:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark五个按钮其中一个被点击
- (void)btnsClickOneWithBtn:(UIButton *)btn{
    NSInteger index = btn.tag;

    CGFloat contentOffsetX = index * widthScreen;
    CGFloat lineViewX = YY16WidthMargin + index * 55;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollerView.contentOffset = CGPointMake(contentOffsetX, 0);
        self.lineView.x = lineViewX;
    }];
    for (UIView *btn0 in self.btnsView.subviews) {
        if ([btn0 isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)btn0;
            button.selected = NO;
            if (btn.tag == button.tag) {
                button.selected = YES;
            }
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    YYLog(@"%f",scrollView.contentOffset.x);
    self.lineView.x = scrollView.contentOffset.x*(55/widthScreen)+YY16WidthMargin;
    NSInteger index = (scrollView.contentOffset.x + widthScreen /2.0) /widthScreen;
    YYLog(@"%ld",(long)index);
    for (UIView *btn in self.btnsView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)btn;
            button.selected = NO;
            if (button.tag == index) {
                button.selected = YES;
            }
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//全部中按钮被点击
- (void)detailCellClickWithModel:(YYCircleModel *)model{
    YYCircleDetailTableViewController *controller = [[YYCircleDetailTableViewController alloc] initWithCircleModel:model];
    [self.navigationController pushViewController:controller animated:YES];
}
//养生中的cell被点击
- (void)lifeCellClickWithModel:(YYCircleModel *)model{
    YYCircleDetailTableViewController *controller = [[YYCircleDetailTableViewController alloc] initWithCircleModel:model];
    [self.navigationController pushViewController:controller animated:YES];
}
//美食的cell被点击

- (void)cookCellClickWithModel:(YYCircleModel *)model{
    YYCircleDetailTableViewController *controller = [[YYCircleDetailTableViewController alloc] initWithCircleModel:model];
    [self.navigationController pushViewController:controller animated:YES];
}
//健康的cell被点击
- (void)healthCellClickWithModel:(YYCircleModel *)model{
    YYCircleDetailTableViewController *controller = [[YYCircleDetailTableViewController alloc] initWithCircleModel:model];
    [self.navigationController pushViewController:controller animated:YES];
}

//食谱的cell被点击
- (void)recipeCellClickWithModel:(YYCircleModel *)model{
    YYCircleDetailTableViewController *controller = [[YYCircleDetailTableViewController alloc] initWithCircleModel:model];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
