//
//  YYShopViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/6.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYShopViewController.h"
#import "YYFruitModel.h"
#import "YYFruitCell.h"
#import "YYSelectFruitView.h"
#import "YYEvaluateView.h"
#import "YYShopView.h"
#import "YYSureOrderController.h"

#import "YYMapViewController.h"
#import <MapKit/MapKit.h>



@interface YYShopViewController ()<UIScrollViewDelegate, YYSelectFruitViewDelegate, YYShopViewDelegate>

//三页共同的属性
@property (nonatomic, weak) UIScrollView *scroller;
@property (nonatomic, weak)UIButton *selectFruitBtn;
@property (nonatomic, weak)UIButton *evaluateBtn;//评价
@property (nonatomic, weak)UIButton *shopMessageBtn;//店铺
@property (nonatomic, weak) UIView *greenViewLine;//按钮下方的竖线
@property (nonatomic, weak) UIView *btnView;
@property (nonatomic, strong) NSArray *priceArray;//点了的模型
                /*------------scrollerView中第一页的属性--------------*/


@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *leftView;//存放左侧按钮的view;
//第一页的数据
@property (nonatomic, strong) NSArray *fruitKeys;//存放组标题
@property (nonatomic, strong) NSMutableDictionary *fruitDatas;//以组标题为key,每组的单元格为key对应的数组
                /*------------scrollerView中第二页的属性--------------*/

//第二页数据
@property (nonatomic,strong) NSMutableArray *evaluateArrays;

@end



@implementation YYShopViewController
/**
 *  点击选好了按钮之后进入确认订单界面
 */
- (void)gotoSureOrder:(NSArray *)array{
    self.priceArray = array;
    YYSureOrderController *sureController = [[YYSureOrderController alloc] initWithArray:self.priceArray andShopName:self.title];
    [self.navigationController pushViewController:sureController animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}
/**
 *  自定义创建控制器
 */
- (instancetype)initWithShopName:(NSString *)shopName{
    if (self = [super init]) {
        self.title = shopName;
    }
    return self;
}
//在ViewDidLoad中加载UI界面
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addThreeBtnView];
    //给控制器添加一个scrollerView
    [self addScrollerView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //进入之后先选择第一页的头部第一个按钮
    [self selectFruitBtnClick:self.selectFruitBtn];
    
}

#pragma mark设置三个页面共有的部分
/**
 *  增加顶部的三个按钮
 */
- (void)addThreeBtnView{
    
    UIView *threeBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 375, 44)];
    self.btnView = threeBtn;
    
    //增加下面的竖线
    UIView *greenView = [[UIView alloc] init];
    greenView.width = 125;
    greenView.height = 2;
    greenView.x = 0;
    greenView.y = 43;
    greenView.backgroundColor = YYGreenColor;
    [threeBtn addSubview:greenView];
    self.greenViewLine = greenView;
    
    CGFloat btnY = 0;
    CGFloat btnH = 43;
    CGFloat btnW = 125;
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] init];
        CGFloat btnX = i * widthScreen/3;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [threeBtn addSubview:btn];
        
        switch (i) {
            case 0:
                [btn setTitle:@"选果" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(selectFruitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                self.selectFruitBtn = btn;
                break;
            case 1:
                [btn setTitle:@"评价" forState:UIControlStateNormal];
                self.evaluateBtn = btn;
                [btn addTarget:self action:@selector(selectFruitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            case 2:
                [btn setTitle:@"店铺" forState:UIControlStateNormal];
                self.shopMessageBtn = btn;
                [btn addTarget:self action:@selector(selectFruitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            default:
                break;
        }
        
        [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:117/255.0 green:183/255.0 blue:66/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor colorWithRed:117/255.0 green:183/255.0 blue:66/255.0 alpha:1.0] forState:UIControlStateSelected];
    }
    [self.view addSubview:threeBtn];
    
}
/**
 *  点击其中一个按钮
 */
- (void)selectFruitBtnClick:(UIButton *)sender{
    
    for (UIView *btn in self.btnView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)btn;
            button.selected = NO;
        }
    }

    sender.selected = YES;
    NSInteger index = sender.origin.x / 125;
    //到指定的页数
    [UIView animateWithDuration:0.5 animations:^{
        self.greenViewLine.x = index * widthScreen/3;
        self.scroller.contentOffset = CGPointMake(index * widthScreen, 0);

    }];
    
}
/**
 *  添加scrollerView
 */
- (void)addScrollerView{
    CGFloat height = 559;
    CGFloat width = 375;
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, width, height)];
    [self.view addSubview:scroller];
    
    scroller.pagingEnabled = YES;
    scroller.contentSize = CGSizeMake(width * 3, height);
    self.scroller = scroller;
    self.scroller.delegate = self;
    
    YYSelectFruitView *selectFruitView = [[YYSelectFruitView alloc] initWithDatas:self.fruitDatas andkeys:self.fruitKeys andFrame:CGRectMake(0, 0, widthScreen, height)];
    [self.scroller addSubview:selectFruitView];
    //设置选择水果页面的代理
    selectFruitView.delegate = self;

    
    YYEvaluateView *evaluateView = [[YYEvaluateView alloc] initWithFrame:CGRectMake(widthScreen, 0, widthScreen, height)];
    [scroller addSubview:evaluateView];
    
    YYShopView *shopView = [[YYShopView alloc] initWithFrame:CGRectMake(widthScreen * 2, 0, widthScreen, height)];
    shopView.delegate = self;
    [scroller addSubview:shopView];
  
}

                /*------------scrollerView中第一页的方法--------------*/

#pragma mark 懒加载数据
- (NSArray *)fruitKeys{
    if (!_fruitKeys) {
        _fruitKeys = @[@"今日特惠", @"热带水果", @"精品水果"];
    }
    return _fruitKeys;
}
- (NSMutableDictionary *)fruitDatas{
    if (!_fruitDatas) {
        _fruitDatas = [NSMutableDictionary dictionary];
        
         NSMutableArray *array = [NSMutableArray array];
        
        YYFruitModel *model0 = [[YYFruitModel alloc] init];
        model0.fruitIconImage = [UIImage imageNamed:@"sort_cherry"];
        model0.fruitName = @"意大利大樱桃";
        model0.fruitPreice = @"18";
        model0.saleNumber = @"888份";
        [array addObject:model0];
        
        YYFruitModel *model1 = [[YYFruitModel alloc] init];
        model1.fruitIconImage = [UIImage imageNamed:@"sort_cherry"];
        model1.fruitName = @"意大利";
        model1.fruitPreice = @"15";
        model1.saleNumber = @"128份";
        [array addObject:model1];
        
        YYFruitModel *model2 = [[YYFruitModel alloc] init];
        model2.fruitIconImage = [UIImage imageNamed:@"sort_cherry"];
        model2.fruitName = @"意大";
        model2.fruitPreice = @"12";
        model2.saleNumber = @"188份";
        [array addObject:model2];
        
        YYFruitModel *model3 = [[YYFruitModel alloc] init];
        model3.fruitIconImage = [UIImage imageNamed:@"sort_cherry"];
        model3.fruitName = @"樱桃";
        model3.fruitPreice = @"10";
        model3.saleNumber = @"828份";
        [array addObject:model3];
        
        YYFruitModel *model4 = [[YYFruitModel alloc] init];
        model4.fruitIconImage = [UIImage imageNamed:@"sort_cherry"];
        model4.fruitName = @"利";
        model4.fruitPreice = @"20";
        model4.saleNumber = @"128份";
        [array addObject:model4];
        
        YYFruitModel *model5 = [[YYFruitModel alloc] init];
        model5.fruitIconImage = [UIImage imageNamed:@"sort_cherry"];
        model5.fruitName = @"意";
        model5.fruitPreice = @"30";
        model5.saleNumber = @"188份";
        [array addObject:model5];
        
        YYFruitModel *model6 = [[YYFruitModel alloc] init];
        model6.fruitIconImage = [UIImage imageNamed:@"sort_cherry"];
        model6.fruitName = @"意大樱桃";
        model6.fruitPreice = @"40";
        model6.saleNumber = @"888份";
        [array addObject:model6];
        
        YYFruitModel *model7 = [[YYFruitModel alloc] init];
        model7.fruitIconImage = [UIImage imageNamed:@"sort_cherry"];
        model7.fruitName = @"意大ww利";
        model7.fruitPreice = @"50";
        model7.saleNumber = @"128份";
        [array addObject:model7];
        
        YYFruitModel *model8 = [[YYFruitModel alloc] init];
        model8.fruitIconImage = [UIImage imageNamed:@"sort_cherry"];
        model8.fruitName = @"意大qq";
        model8.fruitPreice = @"60";
        model8.saleNumber = @"188份";
        [array addObject:model8];

        
    
        for (int i = 0; i < 3; i++) {
            NSString *key = self.fruitKeys[i];
            _fruitDatas[key] = array;
        }
    }
    return _fruitDatas;
}
//scroller View移动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.greenViewLine.x = scrollView.contentOffset.x / 3;
}
//商店信息中的指路按钮点击
- (void)selectWayInShopViewClick{
    CLLocationCoordinate2D coordinate =  CLLocationCoordinate2DMake(30.096494, 120.497649);
    YYMapViewController *mapVC = [[YYMapViewController alloc] initWithCoordinate:coordinate];
    [self.navigationController pushViewController:mapVC animated:YES];
}
@end
