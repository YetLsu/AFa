///
//  YYHomeViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/5.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYHomeViewController.h"
#import "YYNearFruitSsopController.h"
#import "YYFruitShopModel.h"
#import "YYFruitShopCell.h"

#import "YYShopViewController.h"
#import "YYStarShopController.h"
#import "YYTimeFruitController.h"
#import "YYChangeAddressController.h"

#import <MapKit/MapKit.h>


@interface YYHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) NSMutableArray *fruitShops;

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, weak) UIButton *addressBtn;



@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIScrollView *scrollerView;

@property (nonatomic, strong) NSArray *eightArray;

@property (nonatomic, weak) UICollectionView *collectionView;
//懒加载挡住导航条的view
@property (nonatomic, strong) UIView *navigationView;

@end
static NSString *shopFruitID = @"shopFruitID";
@implementation YYHomeViewController

- (UIView *)navigationView{
    if (!_navigationView) {
          _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 64)];
    }
    
    return _navigationView;
}

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (NSMutableArray *)fruitShops{
    if (!_fruitShops) {
        _fruitShops = [NSMutableArray array];
        YYFruitShopModel *model = [[YYFruitShopModel alloc] init];
        model.shopName = @"老王水果店(鉴湖店)";
        model.address = @"柯桥区折线路330号";
        model.openTime = @"营业时间：6点—23点";
        model.distance = @"1000米";
        model.shopIcon = [UIImage imageNamed:@"010"];
        model.xingNumber = 5;
        
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        
        
    }
    return _fruitShops;
}

- (NSArray *)eightArray{
    if (!_eightArray) {
        //        _eightArray = [NSMutableArray array];
        NSArray *array0 = @[[UIImage imageNamed:@"home_banbana"], @"香蕉"];
        NSArray *array1 = @[[UIImage imageNamed:@"home_pear"], @"鸭梨"];
        NSArray *array2 = @[[UIImage imageNamed:@"home_lemon"], @"柠檬"];
        NSArray *array3 = @[[UIImage imageNamed:@"home_apple"], @"苹果"];
        NSArray *array4 = @[[UIImage imageNamed:@"home_grape"], @"葡萄"];
        NSArray *array5 = @[[UIImage imageNamed:@"home_orange"], @"脐橙"];
        NSArray *array6 = @[[UIImage imageNamed:@"home_watermelon"], @"西瓜"];
        NSArray *array7 = @[[UIImage imageNamed:@"home_hamiMelon"], @"哈密瓜"];
        
        _eightArray = @[array0, array1, array2, array3, array4, array5, array6, array7];
        
    }
    return _eightArray;
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    return self = [super initWithStyle:UITableViewStyleGrouped];
    
}
#pragma mark 根据颜色创建图片
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0, 0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//在view显示时改变view的高度
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    YYLog(@"%@",[UIApplication sharedApplication].windows);
    
    CGFloat contentOffsetY = self.tableView.contentOffset.y;
    CGFloat alpha = (contentOffsetY + 20)/200;
//    YYLog(@"%f",alpha);
    self.navigationView.backgroundColor = [YYNavigationBarColor colorWithAlphaComponent:alpha];
    
    [window addSubview:self.navigationView];

}

//在view消失时把view移除window
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationView removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = YYGrayColor;
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, widthScreen, 305 + 10 +60 + 10 + 125 + 10 + 33 - 64 )];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    //增加顶部的图片
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, widthScreen, 155)];
    topView.image = [UIImage imageNamed:@"home_top"];
    [self.headerView addSubview:topView];
    
    //增加顶部的地址按钮
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *address = [defaults stringForKey:YYAddressKey];
    if (!address) {
        [self addTitleAddressBtnWithText:@"正在定位"];
    }else{
        [self addTitleAddressBtnWithText:address];
    }
    
    
    //增加多个按钮的scrollerView
    [self addCellBtnWithBtnViewFrame:CGRectMake(0, 155 - 64, widthScreen, 150)];
    
    //增加下面两个店铺的button高60
    [self addTwoFruitShopWithShopFrame:CGRectMake(0, 305 + 10 - 64, widthScreen, 60)];
    
    //增加迪葱水果店按钮
    UIButton *dicongFruitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 305 + 10 +60 + 10 - 64, widthScreen, 125)];
    [dicongFruitBtn setImage:[UIImage imageNamed:@"home_dicong"] forState:UIControlStateNormal];
    [self.headerView addSubview:dicongFruitBtn];
    
    //增加去附近水果店的按钮
    [self addToNearFruitShopViewWithFrame:CGRectMake(0, 305 + 10 +60 + 10 + 125 + 10 - 64, widthScreen, 33)];
    
    [self getAddress];
}
#pragma mark 创建CLLocationManager开始更新位置信息
- (void)getAddress{
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.manager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            return ;
        }
        CLPlacemark *placemark = [placemarks firstObject];
        if (placemark.name) {
            NSString *str = placemark.name;
            if ([str rangeOfString:@"浙江省绍兴市"].location != NSNotFound) {
                NSRange range =  [placemark.name rangeOfString:@"浙江省绍兴市"];
                
                str = [placemark.name substringFromIndex:range.location + range.length];
                
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults setObject:str forKey:YYAddressKey];
            [userDefaults synchronize];
            
            YYLog(@"定位完成地址为name%@\nthoroughfare%@",placemark.name,placemark.thoroughfare);
            [self setAddressSizeWithText:str];
            [self.manager stopUpdatingLocation];
            
        }
        
        
    }];
    
}
#pragma mark 增加去附近水果店的按钮
- (void)addToNearFruitShopViewWithFrame:(CGRect )nearShopFrame{
    UIView *bottomView = [[UIView alloc] initWithFrame:nearShopFrame];
    [self.headerView addSubview:bottomView];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    UILabel *nearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 33)];
    [bottomView addSubview:nearLabel];
    nearLabel.text = @"附近的水果店";
    nearLabel.textColor = YYGrayTextColor;
    nearLabel.font = [UIFont systemFontOfSize:15];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(316, 0, 50, 33)];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:YYGreenBGColor forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [bottomView addSubview:moreBtn];
    
    [moreBtn addTarget:self action:@selector(goTofruitShop) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 增加下面两个店铺的button高60
- (void)addTwoFruitShopWithShopFrame:(CGRect )shopFrame{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layout.itemSize = CGSizeMake(shopFrame.size.width / 2, shopFrame.size.height);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:shopFrame collectionViewLayout:layout];
    [self.headerView addSubview:collectionView];
    //    self.collectionView = collectionView;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:shopFruitID];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //增加上下两条线和中间的竖线
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(0, 0, shopFrame.size.width, 1) andView:collectionView];
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(0, shopFrame.size.height -1, shopFrame.size.width, 1) andView:collectionView];
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(shopFrame.size.width / 2, 0, 1, shopFrame.size.height) andView:collectionView];
    
}
#pragma mark 增加16个按钮
- (void)addCellBtnWithBtnViewFrame:(CGRect )btnViewFrame{
    //增加一个scrollerView
    UIScrollView *scrollerBtnView = [[UIScrollView alloc] initWithFrame:btnViewFrame];
    scrollerBtnView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:scrollerBtnView];
    self.scrollerView = scrollerBtnView;
    
    int number = 8;
    //根据按钮个数判断scrollerView的content size
    CGFloat btnWidth  = widthScreen / 4;
    CGFloat btnHeight = 150 / 2;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    if (number <= 8) {
        scrollerBtnView.contentSize = CGSizeMake(widthScreen, 150);
        for (int j = 0; j < 2; j++) {
            for (int i = 0; i < 4; i++) {
                int index = j * 4 + i;
                
                NSArray *array = self.eightArray[index];
                btnX = i * btnWidth;
                btnY = j *btnHeight;
                [self addBtnWithFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight) andImage:array[0] andTitle:array[1]];
                
            }
        }
        [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(0, 149, widthScreen, 1) andView:self.scrollerView];
        
    }
    else if (number >8){
        scrollerBtnView.contentSize = CGSizeMake(widthScreen * 2, 150);
    }
}
#pragma mark 添加按钮到scrollerView
- (void)addBtnWithFrame:(CGRect )btnFrame andImage:(UIImage *)image andTitle:(NSString *)title{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [self.scrollerView addSubview:btn];
    [btn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:image forState:UIControlStateNormal];
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 30, 20);
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleEdgeInsets = UIEdgeInsetsMake(50, -widthScreen/4 + 47, 10, 0);
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}
#pragma mark 分类按钮被点击
- (void)sortBtnClick:(UIButton *)btn{
}
#pragma mark设置按钮文字
- (void)setAddressSizeWithText:(NSString *)text{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    self.addressBtn.width = titleSize.width + 30;
    self.addressBtn.height = 30;
    self.addressBtn.x = (widthScreen - self.addressBtn.width)/2.0;
    self.addressBtn.y = (64 - 50)/2.0 + 20;
    
    [self.addressBtn setTitle:text forState:UIControlStateNormal];
    
     self.addressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, titleSize.width + 10);
}
#pragma mark 增加顶部的地址按钮
- (void)addTitleAddressBtnWithText:(NSString *)title{
    
    UIButton *addressBtn = [[UIButton alloc] init];

    [addressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [addressBtn setImage:[UIImage imageNamed:@"home_WhiteAddress"] forState:UIControlStateNormal];
    [addressBtn setImage:[UIImage imageNamed:@"home_WhiteAddress"] forState:UIControlStateHighlighted];
    
    [self.navigationView addSubview:addressBtn];
    
    self.addressBtn = addressBtn;
    
    [addressBtn addTarget:self action:@selector(changeAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self setAddressSizeWithText:title];
}

#pragma mark 设置地址
- (void)changeAddress{
    YYChangeAddressController *changeVc = [[YYChangeAddressController alloc] init];
    [self.navigationController pushViewController:changeVc animated:YES];
}
- (void)goTofruitShop{
    YYNearFruitSsopController *nearController = [[YYNearFruitSsopController alloc] init];
    [self.navigationController pushViewController:nearController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffsetY = self.tableView.contentOffset.y;
    CGFloat alpha = (contentOffsetY + 20)/300;
//    YYLog(@"%f",alpha);
    self.navigationView.backgroundColor = [YYNavigationBarColor colorWithAlphaComponent:alpha];
}

#pragma mark collectionView的数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:shopFruitID forIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:item.bounds];
    [item.contentView addSubview:view];
    //添加共同的控件
    //添加图片
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:item.bounds];
    [view addSubview:iconView];
    //添加字体大的label
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 180, 18)];
    [view addSubview:textlabel];
    textlabel.textAlignment = NSTextAlignmentRight;
    //添加字体小的label
    UILabel *detaillabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, 180, 12)];
    [view addSubview:detaillabel];
    detaillabel.textAlignment = NSTextAlignmentRight;
    detaillabel.textColor = YYGrayTextColor;
    detaillabel.font = [UIFont systemFontOfSize:12];
    
    
    if (indexPath.row == 0) {
        iconView.image = [UIImage imageNamed:@"home_starFruitShop"];
        textlabel.text = @"明星水果店";
        detaillabel.text = @"多年老店";
    }
    else if (indexPath.row == 1) {//添加时令水果才有的图标new
        iconView.image = [UIImage imageNamed:@"home_timeFruit"];
        textlabel.text = @"时令水果";
        detaillabel.text = @"9月－10月下架";
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_new"]];
        [view addSubview:image];
        [image sizeToFit];
        image.x = 0;
        image.y = 0;
    }
    return item;
}
#pragma mark 点击某一个item时被调用即明星水果或者时令水果被点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *item = [collectionView cellForItemAtIndexPath:indexPath];
    UIView *view = [item.contentView.subviews lastObject];
    for (UIView *label in view.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            UILabel *newLabel = (UILabel *)label;
            
            if ([newLabel.text isEqualToString:@"明星水果店"]) {
                YYStarShopController *starVC = [[YYStarShopController alloc] init];
                [self.navigationController pushViewController:starVC animated:YES];
            }
            else if ([newLabel.text isEqualToString:@"时令水果"]){
                YYTimeFruitController *timeVc = [[YYTimeFruitController alloc] init];
                [self.navigationController pushViewController:timeVc animated:YES];
                
            }
        }
    }
}

#pragma mark tableView的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fruitShops.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYFruitShopCell *cell = [YYFruitShopCell fruitShopCellWithTableView:tableView];
    
    YYFruitShopModel *model = self.fruitShops[indexPath.row];
    
    cell.model = model;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

/**
 *  行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYFruitShopModel *model = self.fruitShops[indexPath.row];
    
    YYShopViewController *shopView = [[YYShopViewController alloc] initWithShopName:model.shopName];
    
    [self.navigationController pushViewController:shopView animated:YES];
    
}
@end
