//
//  YYGossipViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/20.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYGossipViewController.h"
#import "YYSquareViewController.h"
#import "YYCircleViewController.h"
#import "YYSearchCircleController.h"
#import "YYCircleWriteSomethingViewController.h"
#import "YYCDetailViewController.h"
#import "YYCirclePersonMineViewController.h"

#import "YYMyCircleFriendProfileController.h"

#import "YYCircleDetailTableViewController.h"

#import "YYAccountTool.h"
#import "YYGoLoginController.h"

@interface YYGossipViewController ()<YYSquareViewControllerDelegate,YYCircleViewControllerDelegate>
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, weak) UIView *squareLine;

@property (nonatomic, weak) UIView *circleLine;

@property (nonatomic, strong) YYSquareViewController *squareController;
@property (nonatomic, strong) UITableView *squareTableView;
@property (nonatomic, strong) YYCircleViewController *circleController;
@property (nonatomic, strong) UITableView *circleTableView;

@property (nonatomic, weak) UIButton *sayBtn;
@property (nonatomic, weak) UIButton *addCircleBtn;

@property (nonatomic, strong) UIButton *addCircleView;

@end

@implementation YYGossipViewController

#pragma mark ----- 说说中的图片放大

- (void)enlargeSquarePic:(NSInteger)tag{
    UIImageView *imageView = [self.view viewWithTag:tag];
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 0, widthScreen, heightScreen);
    Btn.backgroundColor = [UIColor clearColor];
    [Btn addTarget:self action:@selector(clickBigPic:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *bigImage = [[UIImageView alloc]initWithFrame:Btn.frame];
    bigImage.image = imageView.image;
    bigImage.contentMode = UIViewContentModeScaleAspectFit;
    bigImage.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    //[self.view addSubview:Btn];
    [[UIApplication sharedApplication].keyWindow addSubview:Btn];
    [Btn addSubview:bigImage];
    //self.navigationController.hidesBottomBarWhenPushed = YES;
    
}
- (void)clickBigPic:(UIButton *)sender{
    [sender removeFromSuperview];
    //self.navigationController.hidesBottomBarWhenPushed = NO;
}

#pragma mark 广场上某单元格被点击
- (void)dynamicMessageClickWithModel:(YYDynamicMessageModel *)model{
    YYCDetailViewController *messageCommentController = [[YYCDetailViewController alloc] initWithModel:model withGoToPerson:@"1" withWhere:@"2"];
    
    [self.navigationController pushViewController:messageCommentController animated:YES];
}
#pragma mark 圈子上的圈子单元格被点击

- (void)CircleModelClickWithModel:(YYCircleModel *)model{
    YYCircleDetailTableViewController *circleDetailTableViewController = [[YYCircleDetailTableViewController alloc] initWithCircleModel:model];
    [self.navigationController pushViewController:circleDetailTableViewController animated:YES];
}

#pragma mark懒加载两个tableView
- (UITableView *)squareTableView{
    if (!_squareTableView) {
        self.squareController = [[YYSquareViewController alloc] init];
        self.squareController.delegate = self;
        _squareTableView = self.squareController.squareTableView;
        _squareTableView.frame = CGRectMake(0, 52, widthScreen, heightScreen - 52 - 49);
        
    }
    return _squareTableView;
}
- (UITableView *)circleTableView{
    if (!_circleTableView) {
        self.circleController = [[YYCircleViewController alloc] initWithFlag:@"1"];
        self.circleController.delegate = self;
        _circleTableView = self.circleController.circleTableView;
        _circleTableView.frame = CGRectMake(0, 44, widthScreen, heightScreen - 44 - 49);
        
    }
    
    YYLog(@"y:%f   ,h:%f",_circleTableView.frame.origin.y,_circleTableView.frame.size.height);
    
    return _circleTableView;
}
- (UIButton *)addCircleView{
    if (!_addCircleView) {
        _addCircleView = [[UIButton alloc] initWithFrame:CGRectMake(0, heightScreen, widthScreen, heightScreen)];
        [[UIApplication sharedApplication].keyWindow addSubview:_addCircleView];
        
//        [_addCircleView addTarget:self action:@selector(circleViewCoverClick) forControlEvents:UIControlEventTouchUpInside];
        
        _addCircleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        
        //增加找圈子按钮
        CGFloat width = 80/375.0*widthScreen;
        CGFloat height = width;
        CGFloat circleX = (widthScreen - width)/2.0;
        CGFloat circleY = 64 + 30/667.0*heightScreen;

        
        UIButton *searchCircleBtn = [self addBtnWithFrame:CGRectMake(circleX, circleY, width, height) andImage:[UIImage imageNamed:@"bgq_add_searchCircle"] andSEL:@selector(searchCircleBtnClick)];
        [_addCircleView addSubview:searchCircleBtn];

        //增加圈友按钮
        CGFloat addCircleY = circleY +height + 75/667.0*heightScreen;
        UIButton *addCircleBtn = [self addBtnWithFrame:CGRectMake(circleX, addCircleY, width, height) andImage:[UIImage imageNamed:@"bgq_add_cirleFriend"] andSEL:@selector(circleFriendBtnClick)];
        [_addCircleView addSubview:addCircleBtn];
        
        //增加取消按钮
        CGFloat previousWidth = 40/375.0*widthScreen;
        CGFloat previousX = (widthScreen - previousWidth)/2.0;
        CGFloat previousY = heightScreen - 96/667.0*heightScreen;
        UIButton *previousBtn = [self addBtnWithFrame:CGRectMake(previousX, previousY, previousWidth, previousWidth) andImage:[UIImage imageNamed:@"bgq_add_close"] andSEL:@selector(circleViewCoverClick)];
        [_addCircleView addSubview:previousBtn];
    }
    return _addCircleView;
}
/**
 *  增加按钮
 */
- (UIButton *)addBtnWithFrame:(CGRect)btnFrame andImage:(UIImage *)image andSEL:(SEL)section{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    
    [btn setImage:image forState:UIControlStateNormal];
    
    [btn addTarget:self action:section forControlEvents:UIControlEventTouchUpInside];
    
    
    return btn;
}
#pragma mark 点击蒙板以及蒙版按钮的事件
//隐藏蒙版
- (void)circleViewCoverClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.addCircleView.y = heightScreen;
    }];
}
/**
 *  增加圈子被点击
 */
- (void)addCircleBtnClick{
    YYLog(@"增加圈子被点击");
    //从下往上弹出
    [UIView animateWithDuration:0.5 animations:^{
        self.addCircleView.y = 0;
    }];
}
/**
 *  找圈子按钮被点击
 */
- (void)searchCircleBtnClick{
   
    self.addCircleView.y = heightScreen;
    YYSearchCircleController *searchCircle = [[YYSearchCircleController alloc] init];
    [self.navigationController pushViewController:searchCircle animated:YES];
}
/**
 *  圈友按钮被点击
 */
- (void)circleFriendBtnClick{
    YYLog(@"圈友按钮被点击");
    self.addCircleView.y = heightScreen;
    YYMyCircleFriendProfileController *circleFriend = [[YYMyCircleFriendProfileController alloc] initWithWhereToHere:@"2"];
    [self.navigationController pushViewController:circleFriend animated:YES];
}
#pragma mark 设置导航条监听两个按钮的点击
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 64)];
        _topView.backgroundColor = YYNavigationBarColor;
        
//导航栏的头像
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, 27, 30, 30)];
        iconView.tag = 100002;
        iconView.layer.cornerRadius = iconView.frame.size.width/2.0;//设置圆的半径
        iconView.layer.masksToBounds = YES;
        [_topView addSubview:iconView];
//        iconView.image = [UIImage imageNamed:@"bgq_circle_leftTopHeadImage"];
        if ([YYAccountTool account].userUID) {
            iconView.image = [YYAccountTool account].userIconImage;
        }else{
            iconView.image = [UIImage imageNamed:@"14"];
        }
        //iconView.image = [YYAccountTool account].userIconImage;
        
        
//给头像加一个透明的按钮，用来跳到个人中心
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = iconView.frame;
        clearBtn.backgroundColor = [UIColor clearColor];
        [clearBtn addTarget:self action:@selector(clickToMine:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:clearBtn];
        
        
        
//       增加广场按钮
        CGFloat btnW = 47;
        CGFloat squareBtnX = (widthScreen - btnW*2 - YY10WidthMargin)/2.0;
        UIButton *squareBtn = [[UIButton alloc] initWithFrame:CGRectMake(squareBtnX, 22, btnW, 42)];
        [squareBtn setTitle:@"广场" forState:UIControlStateNormal];
        [squareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_topView addSubview:squareBtn];
        [squareBtn addTarget:self action:@selector(squareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *squareView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, btnW, 1)];
        [squareBtn addSubview:squareView];
        squareView.backgroundColor = [UIColor blackColor];
        squareView.hidden = YES;
        self.squareLine = squareView;
        
        //增加圈子按钮
        CGFloat circleX = squareBtnX + btnW + YY10WidthMargin;
        UIButton *circleBtn = [[UIButton alloc] initWithFrame:CGRectMake(circleX, 22, btnW, 42)];
        [circleBtn setTitle:@"圈子" forState:UIControlStateNormal];
        [_topView addSubview:circleBtn];
        [circleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [circleBtn addTarget:self action:@selector(circleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, btnW, 1)];
        [circleBtn addSubview:circleView];
        circleView.backgroundColor = [UIColor blackColor];
        circleView.hidden = YES;
        self.circleLine = circleView;
        
        CGFloat sayBtnW = 50;
        CGFloat sayBtnX = widthScreen - sayBtnW - YY16WidthMargin;
        UIButton *sayBtn = [[UIButton alloc] initWithFrame:CGRectMake(sayBtnX, 19, sayBtnW, 45)];
        [_topView addSubview:sayBtn];
        self.sayBtn = sayBtn;
        [sayBtn setTitle:@"说两句" forState:UIControlStateNormal];
        [sayBtn addTarget:self action:@selector(sayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        sayBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [sayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.sayBtn.hidden = YES;
        
        //增加圈子按钮
        UIButton *addCircleBtn = [[UIButton alloc] initWithFrame:CGRectMake(widthScreen - 30 - YY16WidthMargin, 64-37, 30, 30)];
        [_topView addSubview:addCircleBtn];
        self.addCircleBtn = addCircleBtn;
        
        [self.addCircleBtn setImage:[UIImage imageNamed:@"bgq_circle_add"] forState:UIControlStateNormal];
        [self.addCircleBtn addTarget:self action:@selector(addCircleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.addCircleBtn.hidden = YES;
        
    }
    return _topView;
}
#pragma mark ----- 点击头像进入个人主页
- (void)clickToMine:(UIButton *)sender{
    if ([YYAccountTool account].userUID) {
        YYCirclePersonMineViewController *cPVC = [[YYCirclePersonMineViewController alloc] init];
        [self.navigationController pushViewController:cPVC animated:YES];
    }else{
        YYGoLoginController *goLogin = [[YYGoLoginController alloc]init];
        [self.navigationController pushViewController:goLogin animated:YES];
    }
    
}

/**
 *  说两句被点击
 */
- (void)sayBtnClick{
    YYLog(@"说两句被点击");
    
    YYCircleWriteSomethingViewController *write = [[YYCircleWriteSomethingViewController alloc] initWithMode:22];
    
    [self.navigationController pushViewController:write animated:YES];
    
}

/**
 *  点击圈子
 */
- (void)circleBtnClick{
    YYLog(@"点击圈子");
    //[self.circleTableView removeFromSuperview];
    self.circleTableView.hidden = NO;
    self.squareTableView.hidden = YES;
    //[self.view addSubview:self.circleTableView];
    self.circleLine.hidden = NO;
    self.squareLine.hidden = YES;
    self.addCircleBtn.hidden = NO;
    self.sayBtn.hidden = YES;
    
}
/**
 *  点击广场
 *
 */
- (void)squareBtnClick{
    YYLog(@"点击广场");
    //[self.squareTableView removeFromSuperview];
    self.squareTableView.hidden = NO;
    self.circleTableView.hidden = YES;
    
    self.squareLine.hidden = NO;
    self.circleLine.hidden = YES;
    self.addCircleBtn.hidden = YES;
    self.sayBtn.hidden = NO;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.topView];
    [self squareBtnClick];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YYViewBGColor;
    [self.view addSubview:self.circleTableView];
    self.circleTableView.hidden = YES;
    [self.view addSubview:self.squareTableView];
    self.circleTableView.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIcon:) name:@"changeYYGossipViewControllericon" object:nil];
}
- (void)changeIcon:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    UIImageView *imageview = [self.view viewWithTag:100001];
    imageview.image = dic[@"image"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
