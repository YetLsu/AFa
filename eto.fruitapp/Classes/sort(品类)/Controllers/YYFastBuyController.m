//
//  YYFastBuyController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/16.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYFastBuyController.h"
#import "YYFruitCollectionModel.h"
#import "YYFruitCollectionCell.h"
#import "YYCollectViewHeaderView.h"
#import "YYFastBuyFruitController.h"

@interface YYFastBuyController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak)UIButton *oneKeyBtn;//左侧第一个按钮
@property (nonatomic, weak) UIView *leftView;//存放左侧按钮的view;
@property (nonatomic, strong) NSArray *keys;//存放组标题
@property (nonatomic, strong) NSMutableDictionary *datas;//以组标题为key,每组的单元格为key对应的数组

@property (nonatomic, weak)UICollectionView *collectionView;
@end

static NSString *headerID = @"collectionGroup";
static NSString *itemID = @"collectionCellFruit";
@implementation YYFastBuyController
//组标题keys
- (NSArray *)keys{
    if (!_keys) {
        _keys = @[@"全部水果", @"时令水果", @"热销水果", @"进口水果"];
    }
    return _keys;
}
- (NSMutableDictionary *)datas{
    if (!_datas) {
        _datas = [NSMutableDictionary dictionary];
        
        NSMutableArray *array0 = [[NSMutableArray alloc] init];
        YYFruitCollectionModel *model0 = [[YYFruitCollectionModel alloc] init];
        model0.icon = @"57";
        model0.name = @"猕猴桃";
        [array0 addObject:model0];
        
        YYFruitCollectionModel *model1 = [[YYFruitCollectionModel alloc] init];
        model1.icon = @"58";
        model1.name = @"苹果";
        [array0 addObject:model1];
        
        YYFruitCollectionModel *model2 = [[YYFruitCollectionModel alloc] init];
        model2.icon = @"59";
        model2.name = @"橘子";
        [array0 addObject:model2];
        
        YYFruitCollectionModel *model3 = [[YYFruitCollectionModel alloc] init];
        model3.icon = @"60";
        model3.name = @"猕猴桃";
        [array0 addObject:model3];
        
        YYFruitCollectionModel *model4 = [[YYFruitCollectionModel alloc] init];
        model4.icon = @"61";
        model4.name = @"猕猴桃";
        [array0 addObject:model4];
        
        YYFruitCollectionModel *model5 = [[YYFruitCollectionModel alloc] init];
        model5.icon = @"62";
        model5.name = @"猕猴桃";
        [array0 addObject:model5];
        
        YYFruitCollectionModel *model6 = [[YYFruitCollectionModel alloc] init];
        model6.icon = @"63";
        model6.name = @"猕猴桃";
        [array0 addObject:model6];
        
        YYFruitCollectionModel *model7 = [[YYFruitCollectionModel alloc] init];
        model7.icon = @"64";
        model7.name = @"猕猴桃";
        [array0 addObject:model7];
        
        YYFruitCollectionModel *model8 = [[YYFruitCollectionModel alloc] init];
        model8.icon = @"65";
        model8.name = @"猕猴桃";
        [array0 addObject:model8];

        NSString *key0 = self.keys[0];
        _datas[key0] = array0;
        
        NSString *key1 = self.keys[1];
        _datas[key1] = array0;
        
        NSString *key2 = self.keys[2];
        _datas[key2] = array0;
        
        NSString *key3 = self.keys[3];
        _datas[key3] = array0;
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addLeftListBtn];
    [self keyBtnClick:self.oneKeyBtn];
    [self addRightCollectionView];
    
}
/**
 *  增加左侧的按钮
 */
- (void)addLeftListBtn{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 90, 603)];
    backgroundView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    //增加到scrollerView
    [self.view addSubview:backgroundView];
    self.leftView = backgroundView;
    
    CGFloat X = 0;
    
    CGFloat W = 90;
    CGFloat H = 42;
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
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 41, 90, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:202/255.0 green:203/255.0 blue:201/255.0 alpha:1];
        
        [btn addSubview:line];
        
    }
    //增加一条竖线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(90, 0, 1, 603)];
    lineView.backgroundColor = [UIColor colorWithRed:202/255.0 green:203/255.0 blue:201/255.0 alpha:1];
    [backgroundView addSubview:lineView];
}

/**
 *  增加右侧的列表
 */
- (void)addRightCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.minimumLineSpacing = 18;
    layout.minimumInteritemSpacing = 18;
    
    layout.sectionInset = UIEdgeInsetsMake(18, 18, 0, 18);
    
    layout.itemSize = CGSizeMake(60, 80);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(90, 64, 285, 603) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [collectionView registerClass:[YYFruitCollectionCell class] forCellWithReuseIdentifier:itemID];
    
   
    [collectionView registerNib:[UINib nibWithNibName:@"YYCollectViewHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   
    return self.keys.count;
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
    NSInteger index = sender.frame.origin.y / 40;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop  animated:YES];
    
    CGPoint offset = self.collectionView.contentOffset;
    if (index != 0) {
        offset.y -= 30;
    }
    self.collectionView.contentOffset = offset;
    
}
#pragma mark uicollectionView的数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSString *key = self.keys[section];
    NSMutableArray *array = self.datas[key];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YYFruitCollectionCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    
    NSString *key = self.keys[indexPath.section];
    NSMutableArray *array = self.datas[key];
    YYFruitCollectionModel *model = array[indexPath.row];
    
    item.model = model;
    
    return item;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(375, 30);
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    YYCollectViewHeaderView *headerView;
    if ([UICollectionElementKindSectionHeader isEqualToString:kind]) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
        headerView.title.text = self.keys[indexPath.section];
        if (indexPath.section == 0) {
            headerView.title.text = nil;
        }
    }
    return headerView;

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 18, 0, 18);//分别为上、左、下、右
}
//选中某个时调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = self.keys[indexPath.section];
    YYFruitCollectionModel *model = self.datas[key][indexPath.row];
    YYFastBuyFruitController *fastBuyFC = [[YYFastBuyFruitController alloc] initWithTitle:model.name];
    [self.navigationController pushViewController:fastBuyFC animated:YES];
}

@end
