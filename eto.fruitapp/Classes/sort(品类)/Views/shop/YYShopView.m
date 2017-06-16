//
//  YYShopView.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//scrollerView高559

#import "YYShopView.h"
#import "YYShopMessageModel.h"
#import "YYShopMessageFrame.h"
#import "YYShopMessageCell.h"


#define YYLineColor [UIColor colorWithRed:199/255.0 green:209/255.0 blue:197/255.0 alpha:1]
@interface YYShopView ()<UITableViewDataSource, UITableViewDelegate, YYShopMessageDelegate>
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIView *threeView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *datas;
@end


@implementation YYShopView
- (NSArray *)keys{
    if (!_keys) {
        _keys = @[@"0",@"1"];
    }
    return _keys;
}

- (NSMutableDictionary *)datas{
    if (!_datas) {
        NSMutableArray *array0 = [NSMutableArray array];
        YYShopMessageFrame *frame0 = [self frameWithleftIcon:[UIImage imageNamed:@"sortAddress"] andRightImage:nil andtext:@"9:00-19.30"];
        [array0 addObject:frame0];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *address = [defaults stringForKey:YYAddressKey];
        if (!address) {
            address = @"正在获取地址";
        }
        YYShopMessageFrame *frame1 = [self frameWithleftIcon:[UIImage imageNamed:@"sortAddress"] andRightImage:[UIImage imageNamed:@"008"] andtext:address];
        [array0 addObject:frame1];
        
        
        YYShopMessageFrame *frame2 = [self frameWithleftIcon:[UIImage imageNamed:@"sort_sound"] andRightImage:nil andtext:@"欢迎光临！欢迎光临！欢迎光临！欢迎光临！"];
        [array0 addObject:frame2];
        
        NSMutableArray *array1 = [NSMutableArray array];
        YYShopMessageFrame *frame10 = [self frameWithleftIcon:[UIImage imageNamed:@"sort_send"] andRightImage:nil andtext:@"满20减9元（在线支付专享）"];
        [array1 addObject:frame10];
        YYShopMessageFrame *frame11 = [self frameWithleftIcon:[UIImage imageNamed:@"sort_send"] andRightImage:nil andtext:@"商家免费配送"];
        [array1 addObject:frame11];
        
        _datas = [NSMutableDictionary dictionary];
        _datas[@"0"] = array0;
        _datas[@"1"] = array1;
    }
   
    return _datas;
}
- (YYShopMessageFrame *)frameWithleftIcon:(UIImage *)leftIcon andRightImage:(UIImage *)rightImage andtext:(NSString *)text{
    YYShopMessageModel *model = [[YYShopMessageModel alloc] init];
    model.leftIcon = leftIcon;
    model.text = text;
    model.rightIcon = rightImage;
    YYShopMessageFrame *frame = [[YYShopMessageFrame alloc] init];
    frame.model = model;
    return frame;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addHeaderView];
        [self addTableView];
    }
    
    return self;
}
//添加上半部分视图H230;
- (void)addHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 230)];
    [self addSubview:headerView];
    
    self.headerView = headerView;
    UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:headerView.bounds];
    backGroundImage.image = [UIImage imageNamed:@"sort_shopbg"];
    [headerView addSubview:backGroundImage];
    
//添加中间的圆形图片X145，Y25,WH138
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(145, 25, 82, 82)];
    imageView.image = [UIImage imageNamed:@"sort_watermelon"];
    [headerView addSubview:imageView];
   
    //添加label Y128；X132，W112 H26
    UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(132, 128, 112, 26)];
    shopName.text = @"老王水果店";
    shopName.textAlignment = NSTextAlignmentCenter;
    shopName.textColor = [UIColor whiteColor];
    [headerView addSubview:shopName];
    
    //添加送达时间，配送费，起送价
    [self addThreeView];
    
    
}

//添加送达时间，配送费，起送价 Y168,H62
- (void)addThreeView{
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(0, 168, widthScreen, 62)];
    threeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.headerView addSubview:threeView];
    self.threeView = threeView;
    
    //加两条竖线Y13，H36，X125
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(125, 13, 1, 36)];
    [threeView addSubview:line1];
    line1.backgroundColor = YYLineColor;
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(250, 13, 1, 36)];
    [threeView addSubview:line2];
    line2.backgroundColor = YYLineColor;
    
    //添加白色字体
    [self addWhiteTextWithFrame:CGRectMake(0, 12, 125, 20) andText:@"30分钟"];
    [self addWhiteTextWithFrame:CGRectMake(125, 12, 125, 20) andText:@"¥15"];
    [self addWhiteTextWithFrame:CGRectMake(250, 12, 125, 20) andText:@"¥0"];
    
    //添加灰色字体
    [self addGrayTextWithFrame:CGRectMake(0, 35, 125, 20) andText:@"平均送达时间"];
    [self addGrayTextWithFrame:CGRectMake(125, 35, 125, 20) andText:@"起送价"];
    [self addGrayTextWithFrame:CGRectMake(250, 35, 125, 20) andText:@"配送费"];
}
//添加白色字体
- (void)addWhiteTextWithFrame:(CGRect)frame andText:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [self.threeView addSubview:label];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    
}
//添加灰色字体
- (void)addGrayTextWithFrame:(CGRect)frame andText:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [self.threeView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = YYLineColor;
}
//添加下半部分tableView559 - 230 = 329
-(void)addTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 230, widthScreen, 329) style:UITableViewStyleGrouped];
    [self addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYShopMessageCell *cell = [YYShopMessageCell shopMessageCellWithTableView:tableView];
    
    NSString *key = self.keys[indexPath.section];
    NSArray *array = self.datas[key];
    YYShopMessageFrame *frame = array[indexPath.row];
    
    cell.messageFrame = frame;
    
    cell.delegate = self;

    return cell;
}
#pragma mark指路被点击
- (void)selectWayClick{
    
    if ([self.delegate respondsToSelector:@selector(selectWayInShopViewClick)]) {
        [self.delegate selectWayInShopViewClick];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = self.keys[indexPath.section];
    NSArray *array = self.datas[key];
    YYShopMessageFrame *frame = array[indexPath.row];
    return frame.rowHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
@end
