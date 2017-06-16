//
//  YYEvaluateView.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYEvaluateView.h"
#import "YYEvaluateCell.h"
#import "YYEvaluateModel.h"
#import "YYEvaluateFrame.h"

@interface YYEvaluateView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UIView *buttomView; //下面部分的评价

@property (nonatomic,strong) NSMutableArray *evaluateArrays;//评论数据
@end

@implementation YYEvaluateView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = YYGrayColor;
        
        [self addEvaluateView];
        [self addButtomView];
    }
    return self;
}

//设置文字字体
- (void)setTextWithFrame:(CGRect )frame andSuperView:(UIView *)superView andTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [superView addSubview:label];
    label.text = title;
//    label.backgroundColor = YYGrayColor;
    
}
//增加第二页上面的评价
- (void)addEvaluateView{
    UIView *evaluateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 100)];
    evaluateView.backgroundColor = [UIColor whiteColor];
    [self addSubview:evaluateView];
    
    UIFont *numberFont = [UIFont systemFontOfSize:35];
    //中间竖线高70，x128
    UIView *Vline = [[UIView alloc] initWithFrame:CGRectMake(128, 15, 1, 70)];
    Vline.backgroundColor = YYGrayLineColor;
    [evaluateView addSubview:Vline];
    
    //评分W65，H40,x45,y15
    UILabel *evaluateNumber = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 65, 40)];
//    evaluateNumber.backgroundColor = [UIColor grayColor];
    evaluateNumber.textAlignment = NSTextAlignmentCenter;
    evaluateNumber.text = @"5.0";
    evaluateNumber.font = numberFont;
    evaluateNumber.textColor = YYGreenColor;
    [evaluateView addSubview:evaluateNumber];
    
    
    [self setTextWithFrame:CGRectMake(45, 60, 65, 30) andSuperView:evaluateView andTitle:@"整体评价"];
    
    
    //增加右侧内容
    [self setTextWithFrame:CGRectMake(140, 20, 70, 26) andSuperView:evaluateView andTitle:@"配送速度"];
    
    [self setTextWithFrame:CGRectMake(140, 56, 70, 26) andSuperView:evaluateView andTitle:@"水果质量"];
    
    //添加五颗星X217,W15,Y20
    
    CGFloat X = 227;
    CGFloat W = 15;
    CGFloat H = 15;
    CGFloat Y = 25;
    CGFloat YTwo = 60;
    for (int i = 0; i < 5; i++) {
        UIImageView *starImage = [[UIImageView alloc] init];
        X = (W + 5) * i + 227;
        starImage.frame = CGRectMake(X, Y, W, H);
        starImage.image = [UIImage imageNamed:@"sort_star_green"];
        [evaluateView addSubview:starImage];
        
        UIImageView *starTwoImage = [[UIImageView alloc] init];
        starTwoImage.image = [UIImage imageNamed:@"sort_star_green"];
        starTwoImage.frame = CGRectMake(X, YTwo, W, H);
        [evaluateView addSubview:starTwoImage];
    }
    
}

//设置下面一块
- (void)addButtomView{
    UIView *buttomView = [[UIView alloc] init];
    buttomView.x = 0;
    buttomView.y = 116;
    buttomView.width = widthScreen;
    buttomView.height = 443;
    buttomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:buttomView];
    self.buttomView = buttomView;
    
    [self addTwoButton];
    [self addEvaluateTableView];
}

//添加两个按钮
- (void)addTwoButton{
    //Button的Y15，H30;X21;W156;
    CGFloat buttonX = 21;
    CGFloat buttonY = 15;
    CGFloat buttonW = 156;
    CGFloat buttonH = 30;
    [self setButtonWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH) andTitle:@"全部(60)"];
    [self setButtonWithFrame:CGRectMake(buttonX + buttonW + 24, buttonY, buttonW, buttonH) andTitle:@"有内容(60)"];
    
    
}

//设置按钮的属性并添加到下面的View
- (void)setButtonWithFrame:(CGRect)frame andTitle:(NSString *)title{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [self.buttomView addSubview:btn];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"sort_btnbg_nor"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"sort_btnbg_high"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"sort_btnbg_high"] forState:UIControlStateSelected];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:YYGreenColor forState:UIControlStateHighlighted];
    [btn setTitleColor:YYGreenColor forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

//点击下面部分两个按钮中的一个
- (void)btnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}

//添加tableViewY50;H393
- (void)addEvaluateTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, widthScreen, 393) style:UITableViewStylePlain];
    [self.buttomView addSubview:tableView];

    tableView.delegate = self;
    tableView.dataSource = self;

}

#pragma mark数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.evaluateArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYEvaluateCell *cell = [YYEvaluateCell evaluateCellWithTableView:tableView];
    
    YYEvaluateFrame *frame = self.evaluateArrays[indexPath.row];
    
    cell.evaluateFrame = frame;
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYEvaluateFrame *frame = self.evaluateArrays[indexPath.row];
    return frame.rowHeight;
    
}
#pragma mark 懒加载评论数据
- (NSMutableArray *)evaluateArrays{
    if (!_evaluateArrays) {
        _evaluateArrays  = [NSMutableArray array];
        
        YYEvaluateModel *model1 = [[YYEvaluateModel alloc] init];
        model1.userIcon = [UIImage imageNamed:@"sort_icon"];
        model1.phone = @"186****5294";
        model1.data = @"2015-9-13";
        model1.time = @"17:30";
        model1.starCount = 2;
        model1.deliverySpeed = 10;
        model1.evaluate = @"味道很不错，网上订餐也提高了速度";
        YYEvaluateFrame *frame1 = [[YYEvaluateFrame alloc] init];
        frame1.model = model1;
        
        YYEvaluateModel *model2 = [[YYEvaluateModel alloc] init];
        model2.userIcon = [UIImage imageNamed:@"sort_icon"];
        model2.phone = @"186****5294";
        model2.data = @"2015-9-13";
        model2.time = @"17:30";
        model2.starCount = 3;
        model2.deliverySpeed = 10;
        model2.evaluate = @"环境好，位置很好找，收银小姐长得很漂亮，是个午后休息的好去处，以后还会去的。";
        YYEvaluateFrame *frame2 = [[YYEvaluateFrame alloc] init];
        frame2.model = model2;
        
        YYEvaluateModel *model3 = [[YYEvaluateModel alloc] init];
        model3.userIcon = [UIImage imageNamed:@"sort_icon"];
        model3.phone = @"186****5294";
        model3.data = @"2015-9-13";
        model3.time = @"17:30";
        model3.starCount = 4;
        model3.deliverySpeed = 10;
        model3.evaluate = nil;
        YYEvaluateFrame *frame3 = [[YYEvaluateFrame alloc] init];
        frame3.model = model3;
        
        YYEvaluateModel *model4 = [[YYEvaluateModel alloc] init];
        model4.userIcon = [UIImage imageNamed:@"sort_icon"];
        model4.phone = @"186****5294";
        model4.data = @"2015-9-13";
        model4.time = @"17:30";
        model4.starCount = 5;
        model4.deliverySpeed = 10;
        model4.evaluate = @"味道不错，就是买的套餐说饮料还没上架?!但是感觉很划算，哈哈";
        YYEvaluateFrame *frame4 = [[YYEvaluateFrame alloc] init];
        frame4.model = model4;
        
        
        YYEvaluateModel *model5 = [[YYEvaluateModel alloc] init];
        model5.userIcon = [UIImage imageNamed:@"sort_icon"];
        model5.phone = @"186****5294";
        model5.data = @"2015-9-13";
        model5.time = @"17:30";
        model5.starCount = 5;
        model5.deliverySpeed = 10;
        model5.evaluate = @"掌柜的服务态度真好，火锅很好吃，请客特大特气派。蔡也相当不错。太喜欢了，谢谢！";
        YYEvaluateFrame *frame5 = [[YYEvaluateFrame alloc] init];
        frame5.model = model5;
        
        [_evaluateArrays addObject:frame1];
        [_evaluateArrays addObject:frame2];
        [_evaluateArrays addObject:frame3];
        [_evaluateArrays addObject:frame4];
        
        
        



    }
    return _evaluateArrays;
}

@end
