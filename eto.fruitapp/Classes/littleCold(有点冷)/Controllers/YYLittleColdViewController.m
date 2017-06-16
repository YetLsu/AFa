//
//  YYLittleColdViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/5.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYLittleColdViewController.h"
#import "YYofficColdController.h"

#import "YYLittleColdHotCellmodel.h"
#import "YYLittleColdHotCell.h"

@interface YYLittleColdViewController ()
@property (nonatomic, strong) NSArray *topModelsArray;//置顶的模型数组
@property (nonatomic, strong) NSMutableArray *hotModelsArray;//热门推荐的模型数组

@end

@implementation YYLittleColdViewController
/**
 *  从数据库加载置顶模型，若没有则从网络请求
 *
 */
- (NSArray *)topModelsArray{
    if (!_topModelsArray) {
        _topModelsArray = [[YYFruitDatabaseTool shareFruitTool] littleCold_tops];
        if (_topModelsArray.count == 0) {
            _topModelsArray = @[@"[本周精选] 适合吃什么水果？", @"冬天适合吃什么水果？",  @"夏天适合吃什么水果？",  @"春天适合吃什么水果？",  @"[活动］活动就是活动喽"];
            [[YYFruitDatabaseTool shareFruitTool] addLittleCold_topsWithLittleColds:_topModelsArray];
        }
    }
    return _topModelsArray;
}

/**
 *  从数据库加热门推荐模型，若没有则从网络请求
 *
 */

- (NSMutableArray *)hotModelsArray{
    if (!_hotModelsArray) {
        _hotModelsArray = [NSMutableArray array];
        
        _hotModelsArray =(NSMutableArray *) [[YYFruitDatabaseTool shareFruitTool] littleCold_hots];
        
        if (_hotModelsArray.count == 0) {
            YYLittleColdHotCellmodel *model1 = [[YYLittleColdHotCellmodel alloc] initWithLittleColdDownCellmodel:[UIImage imageNamed:@"littleCold_icon2"] withLeftLabel:@"烹饪" withTitle:@"袖珍果盘怎么做" withContent:@"袖珍果盘怎么做？" withNumberOfZan:33 withNumberOfComment:11 withTime:@"2015-11-21"];
            for (int i = 0; i < 10; i++) {
                [[YYFruitDatabaseTool shareFruitTool] addLittleCold_hotsWithHotCellModel:model1];
                [_hotModelsArray addObject:model1];
            }
           
        }
    }
    

    return _hotModelsArray;
}

- (instancetype)init{
    return self = [[YYLittleColdViewController alloc] initWithStyle:UITableViewStyleGrouped];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = YYViewBGColor;
    //创建两个按钮的顶部view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 91.5/ 667.0 * heightScreen)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //添加两个按钮
    CGFloat btnW = 327/750.0 *widthScreen;
    CGFloat btnH = 123/ 1334.0 * heightScreen;
    UIButton *officialBtn = [[UIButton alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY15HeightMargin, btnW, btnH)];
    [headerView addSubview:officialBtn];
    
    [officialBtn setImage:[UIImage imageNamed:@"littleCold_officialCold"] forState:UIControlStateNormal];
    [officialBtn addTarget:self action:@selector(officialColdClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *folkBtn = [[UIButton alloc] initWithFrame:CGRectMake(YY16WidthMargin*2+btnW, YY15HeightMargin, btnW, btnH)];
    [headerView addSubview:folkBtn];
    [folkBtn setImage:[UIImage imageNamed:@"littleCold_folk"] forState:UIControlStateNormal];
    [folkBtn addTarget:self action:@selector(folkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = headerView;
    
    YYLog(@"%@",NSHomeDirectory());
    
}
/**
 *  官方冷被点击
 */
- (void)officialColdClick{

    YYofficColdController *officController = [[YYofficColdController alloc] init];
    officController.title = @"官方冷";
    [self.navigationController pushViewController:officController animated:YES];
}
/**
 *  民间冷被点击
 */
- (void)folkBtnClick{

    YYofficColdController *folkController = [[YYofficColdController alloc] init];
    folkController.title = @"民间冷";
    [self.navigationController pushViewController:folkController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.topModelsArray.count;
    }
    return self.hotModelsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSString *title = self.topModelsArray[indexPath.row];
        [self setCell:cell andTitle:title];
        return cell;
    }

    YYLittleColdHotCell *cell = [YYLittleColdHotCell littleColdHotCellWithTableView:tableView];
    YYLittleColdHotCellmodel *model = self.hotModelsArray[indexPath.row];
     
    cell.hotCellModel = model;
     
    return cell;
}

//写出置顶的cell
- (void)setCell:(UITableViewCell *)cell andTitle:(NSString *)title{
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, 7.5, 27, 15)];
    topImageView.image = [UIImage imageNamed:@"littleCold_top"];
    [cell.contentView addSubview:topImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YY16WidthMargin + 5 + 27, 0, widthScreen - YY16WidthMargin - 32, 30)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:titleLabel];
    titleLabel.textColor = YYGrayTextColor;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 30;
    }
    return 110;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"热门推荐";
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[YYFruitDatabaseTool shareFruitTool] deleteLittleCold_hotsData];
    [[YYFruitDatabaseTool shareFruitTool] deleteLittleCold_topData];
    YYLog(@"删除所有数据");
}
@end
