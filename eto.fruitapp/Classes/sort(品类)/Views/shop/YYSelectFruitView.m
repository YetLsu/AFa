//
//  YYSelectFruitView.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSelectFruitView.h"
#import "YYFruitCell.h"
#import "YYFruitModel.h"


@interface YYSelectFruitView ()<UITableViewDataSource, UITableViewDelegate, YYFruitCellDelegate>
@property (nonatomic, weak)UIButton *oneKeyBtn;//左侧第一个按钮
@property (nonatomic, weak) UIView *leftView;//存放左侧按钮的view;
@property (nonatomic, strong) NSArray *keys;//存放组标题
@property (nonatomic, strong) NSMutableDictionary *datas;//以组标题为key,每组的单元格为key对应的数组
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UILabel *allPriceLabel;

@property (nonatomic, weak) UILabel *startTakeLabel;//起送价
@property (nonatomic, weak) UIButton *selectBtn;//选好了按钮

@property (nonatomic, strong) NSMutableArray *priceArray;
@end

@implementation YYSelectFruitView

- (NSMutableArray *)priceArray {
    if (!_priceArray) {
        _priceArray = [NSMutableArray array];
    }
    return _priceArray;
}

//点击加减后调用的方法
- (void)cellAllPriceWithModel:(YYFruitModel *)model{
    [self.priceArray removeAllObjects];
    CGFloat sumPrice = 0;
    for (int i = 0; i < self.keys.count; i++) {
        NSString *key = self.keys[i];
        NSArray *array = self.datas[key];
        for (YYFruitModel *model in array) {
            //把数量不为0的模型放入数组
            if (model.selectNumber != 0) {
                [self.priceArray addObject:model];
            }
            sumPrice += model.selectNumber * model.fruitPreice.floatValue;
        }
    }
    if (sumPrice == 0) {
        self.allPriceLabel.text = @"购物车是空的";
        self.startTakeLabel.hidden = NO;
        self.selectBtn.hidden = YES;
        
    }else{
        self.allPriceLabel.text = [NSString stringWithFormat:@"共%.2f元",sumPrice];
        self.startTakeLabel.hidden = YES;
        self.selectBtn.hidden = NO;
    }
    
}

- (instancetype)initWithDatas:(NSMutableDictionary *)datas andkeys:(NSArray *)keys andFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //创建后先选择左侧第一个按钮
        self.keys = keys;
        self.datas = datas;
        [self addTitleMessage];
        [self addLeftListBtn];
        [self addTableView];
        //创建后先选择左侧第一个按钮
        [self keyBtnClick:self.oneKeyBtn];
        
        //添加下部的购物车
        [self addBottomView];
    }
    return self;
}
/**
 * 添加下部的购物车
 */
- (void)addBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 519, widthScreen, 40)];
    bottomView.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    [self addSubview:bottomView];
    
    UILabel *allPrice = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 150, 40)];
    [bottomView addSubview:allPrice];
    self.allPriceLabel = allPrice;
    self.allPriceLabel.text = @"购物车是空的";
    self.allPriceLabel.textColor = [UIColor whiteColor];
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 0, 100, 40)];
    [bottomView addSubview:startLabel];
    self.startTakeLabel = startLabel;
    self.startTakeLabel.text = @"15元起送";
    self.startTakeLabel.textColor = [UIColor whiteColor];
    
    //创建选好了按钮
    UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(275, 0, 100, 40)];
    [bottomView addSubview:selBtn];
    self.selectBtn = selBtn;
    [self.selectBtn setBackgroundColor:YYGreenBGColor];
    [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectBtn setTitle:@"选好了" forState:UIControlStateNormal];
    self.selectBtn.hidden = YES;
    [self.selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
/**
 * 点击选好了按钮
 */
- (void)selectBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(gotoSureOrder:)]) {
        [self.delegate gotoSureOrder:self.priceArray];
    }
}
#pragma mark 添加界面
/**
 *  增加店铺公告
 */
- (void)addTitleMessage{
    UIView *messageView = [[UIView alloc] init];
    messageView.frame = CGRectMake(0, 0, widthScreen, 22);
    messageView.backgroundColor = [UIColor colorWithRed:224/255.0 green:234/255.0 blue:178/255.0 alpha:1.0];
    [self addSubview:messageView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 3.5, 15, 15)];
    imageView.image = [UIImage imageNamed:@"sort11"];
    [messageView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 1, 300, 20)];
    label.text = @"店铺公告：即日起水果不要钱";
    label.alpha = 0.8;
    label.font = [UIFont systemFontOfSize:12];
    
    [messageView addSubview:label];
}

/**
 *  增加左侧的按钮
 */
- (void)addLeftListBtn{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 22, 100, 537)];
    backgroundView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    //增加到scrollerView
    [self addSubview:backgroundView];
    self.leftView = backgroundView;
    
    CGFloat X = 0;
    
    CGFloat W = 100;
    CGFloat H = 50;
    for (int i = 0; i < self.keys.count; i++) {
        
        CGFloat Y = i * H;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        if (i == 0) {
            self.oneKeyBtn = btn;
        }
        [btn setTitle:self.keys[i] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"color_gray"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"color_white"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"color_white"] forState:UIControlStateSelected];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:YYGreenColor forState:UIControlStateSelected];
        [btn setTitleColor:YYGreenColor forState:UIControlStateHighlighted];
        btn.titleLabel.alpha = 0.7;
        
        [btn addTarget:self action:@selector(keyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:btn];
        
        //增加一条线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 100, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:202/255.0 green:203/255.0 blue:201/255.0 alpha:1];
        
        [btn addSubview:line];
        
    }
    //增加一条竖线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(99, 0, 1, 537)];
    lineView.backgroundColor = [UIColor colorWithRed:202/255.0 green:203/255.0 blue:201/255.0 alpha:1];
    [backgroundView addSubview:lineView];
}

/**
 *   点击左侧某个按钮
 */
- (void)keyBtnClick:(UIButton *)sender{
    for (UIView *leftBtn in self.leftView.subviews) {
        if ([leftBtn isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)leftBtn;
            button.selected = NO;
        }
    }
    
    sender.selected = YES;
    //根据y值判断是哪个key
    NSInteger index = sender.frame.origin.y / 50;
    //    NSString *key = self.keys[index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

/**
 *  添加tableView
 *
 */
- (void)addTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(110, 22, 265, 537) style:UITableViewStyleGrouped];
    //增加到scrollerView
    [self addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;

    
}

#pragma mark tableView的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.keys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = self.keys[section];
    NSArray *array = self.datas[key];
    
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYFruitCell *cell = [YYFruitCell fruitCellWithTableView:tableView];
    
    NSString *key = self.keys[indexPath.section];
    NSArray *array = self.datas[key];
    YYFruitModel *model = array[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
#pragma mark显示tableView的组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key = self.keys[section];
    return key;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


@end
