//
//  YYofficColdController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/8.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYofficColdController.h"
#import "YYLoginController.h"
#import "YYNavigationController.h"

#import "YYOfficColdAllController.h"
#import "YYOfficColdLifeController.h"
#import "YYOfficColdCookController.h"
#import "YYOfficColdHealthController.h"
#import "YYOfficColdCookBookController.h"
#import "YYAccountTool.h"

/**
 *  顶部按钮宽52
 */
@interface YYofficColdController ()<UIScrollViewDelegate, YYOfficColdAllControllerDelegate,YYOfficColdLifeControllerDelegate,YYOfficColdCookControllerDelegate,YYOfficColdHealthControllerDelegate,YYOfficColdCookBookControllerDelegate>

@property (nonatomic, strong)YYOfficColdAllController *allController;
@property (nonatomic, strong)YYOfficColdLifeController *lifeController;
@property (nonatomic, strong)YYOfficColdCookController *cookController;
@property (nonatomic, strong)YYOfficColdHealthController *healthController;
@property (nonatomic, strong)YYOfficColdCookBookController *cookBookController;
@property (nonatomic, assign, getter=isFirst) BOOL first;//第一次进入
//顶部五个按钮的view
@property (nonatomic, weak) UIView *topView;
//第一个按钮
@property (nonatomic, weak) UIButton *firstBtn;

@property (nonatomic, weak) UIScrollView *scrollerView;
//按钮下方的线
@property (nonatomic, weak) UIView *bottomLineView;

@end

@implementation YYofficColdController


- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        UIView *bottomView = [[UIView alloc] init];
        [self.topView addSubview:bottomView];
        _bottomLineView = bottomView;
        
        _bottomLineView.backgroundColor = [UIColor colorWithRed:177/255.0 green:50/255.0 blue:37/255.0 alpha:1];
        
    }
    return _bottomLineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YYViewBGColor;
    
    //增加顶部的五个按钮的view
    [self addTopViewWithBtnWithFrame:CGRectMake(0, 64, widthScreen, 30)];
    [self selectOntBtnOnTop:self.firstBtn];
    self.bottomLineView.frame = CGRectMake(YY16WidthMargin, 28, 52, 2);
    //增加线条
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(0, 94, widthScreen, 0.5) andView:self.view];
    
    //增加scrollerView
    [self addScrollerViewWithFrame:CGRectMake(0, 94.5, widthScreen, heightScreen - 94.5)];
}
/**
 *  增加顶部的五个按钮的view
 */
- (void)addTopViewWithBtnWithFrame:(CGRect)topViewFrame{
    UIView *topView = [[UIView alloc] initWithFrame:topViewFrame];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    self.topView = topView;
    
    CGFloat btnX;
    CGFloat btnY = 0;
    CGFloat btnW = 52;
    CGFloat btnH = 30;
    
    for (int i = 0; i < 5; i ++) {
        btnX = YY16WidthMargin + btnW*i;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.tag = i;
        [topView addSubview:btn];
        switch (i) {
                case 0:
                [self setBtnWithBtn:btn andTitle:@"全部"];
                self.firstBtn = btn;
                break;
                
            case 1:
                [self setBtnWithBtn:btn andTitle:@"养生"];
                break;
                
            case 2:
                [self setBtnWithBtn:btn andTitle:@"烹饪"];
                break;
                
            case 3:
                [self setBtnWithBtn:btn andTitle:@"健康"];
                break;

            case 4:
                [self setBtnWithBtn:btn andTitle:@"食谱"];
                break;
                
            default:
                break;

        }
    }
    
}
/**
 *  设置按钮
 *
 */
- (void)setBtnWithBtn:(UIButton *)btn andTitle:(NSString *)title{
 
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
    [btn setTitleColor:YYYellowTextColor forState:UIControlStateSelected];
    [btn setTitleColor:YYYellowTextColor forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(selectOntBtnOnTop:) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  点击顶部其中一个按钮
 *
 */
- (void)selectOntBtnOnTop:(UIButton*) btn{
   
    for (UIButton *button in self.topView.subviews) {
        if([button isKindOfClass:[UIButton class]]){
            button.selected = NO;
            if (btn.tag == button.tag) {
                 button.selected = YES;
            }
        }
    }

    NSInteger tag = btn.tag;
    if (!self.isFirst) {
        self.first = YES;
        return;
    }
    //根据tag设置scrollerView的偏移量
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollerView.contentOffset = CGPointMake(tag * widthScreen, 0);
        YYLog(@"%ld",tag);
        self.bottomLineView.frame = CGRectMake(tag * 52 + YY16WidthMargin, 28, 52, 28);
        
    }];
    
}
/**
 *  增加scrollerView
 */
- (void)addScrollerViewWithFrame:(CGRect)scrollerFrame{
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:scrollerFrame];
    scrollerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollerView];
    self.scrollerView = scrollerView;
    scrollerView.contentSize = CGSizeMake(widthScreen * 5, scrollerFrame.size.height);
    scrollerView.delegate = self;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.pagingEnabled = YES;
    
    //增加五个控制器的view进scroller View
    CGFloat viewY = 0;
    CGFloat viewW = widthScreen;
    CGFloat viewH = scrollerFrame.size.height;
    
    YYOfficColdAllController *all = [[YYOfficColdAllController alloc] initWithTableViewHeight:viewH];
    self.allController = all;
    self.allController.delegate = self;
    all.allTableView.frame = CGRectMake(0, viewY, viewW, viewH);
    [scrollerView addSubview:all.allTableView];
    
    YYOfficColdLifeController *life = [[YYOfficColdLifeController alloc] initWithTableViewHeight:viewH];
    self.lifeController = life;
    self.lifeController.delegate = self;
    life.lifeTableView.frame = CGRectMake(widthScreen, viewY, viewW, viewH);
    [scrollerView addSubview:life.lifeTableView];
    
    YYOfficColdCookController *cook = [[YYOfficColdCookController alloc] initWithTableViewHeight:viewH];
    self.cookController = cook;
    self.cookController.delegate = self;
    cook.cookTableView.frame = CGRectMake(2 * widthScreen, viewY, viewW, viewH);
    [scrollerView addSubview:cook.cookTableView];
    
    YYOfficColdHealthController *health = [[YYOfficColdHealthController alloc] initWithTableViewHeight:viewH];
    self.healthController = health;
    self.healthController.delegate = self;
    health.healthTableView.frame = CGRectMake(3* widthScreen, viewY, viewW, viewH);
    [scrollerView addSubview:health.healthTableView];
    
    YYOfficColdCookBookController *cookbook = [[YYOfficColdCookBookController alloc] initWithTableViewHeight:viewH];
    self.cookBookController = cookbook;
    self.cookBookController.delegate = self;
    cookbook.cookBookTableView.frame = CGRectMake(4 * widthScreen, viewY, viewW, viewH);
    [scrollerView addSubview:cookbook.cookBookTableView];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint contentOffset = scrollView.contentOffset;
    NSInteger index = (NSInteger)(contentOffset.x/375/375.0*widthScreen + 0.5);

    self.bottomLineView.x = YY16WidthMargin + contentOffset.x/widthScreen * 52;
    
    for (UIButton *button in self.topView.subviews) {
        if([button isKindOfClass:[UIButton class]]){
            button.selected = NO;
            if (index == button.tag) {
                button.selected = YES;
            }
        }
    }
}
- (void)pushControllerWithController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
