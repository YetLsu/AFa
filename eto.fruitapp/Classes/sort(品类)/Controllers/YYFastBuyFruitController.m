//
//  YYFastBuyFruitController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/17.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYFastBuyFruitController.h"
#import "YYOrderCell.h"
#import "YYOrderMOdel.h"
#import "YYAddRemarksController.h"

@interface YYFastBuyFruitController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak)UITableView *tableView;
@end

@implementation YYFastBuyFruitController
- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
         self.view.backgroundColor = [UIColor whiteColor];
        
        self.title = title;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 627) style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
       
        [self addButtomView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (void)addButtomView{
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 627, 375, 40)];
    [self.view addSubview:buttomView];
    //添加总计label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 275, 40)];
    label.text = [NSString stringWithFormat:@"   总计¥%d",26];
    
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:22];

    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [buttomView addSubview:label];
    
    //添加立即购买按钮
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(275, 0, 100, 40)];
    [buyBtn setTitle:@"确认下单" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = YYGreenColor;
    [buttomView addSubview:buyBtn];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    
    if (indexPath.section == 2) {
        cell = [self cellWithPlaceholder:@"请填写配送地址" andImage:[UIImage imageNamed:@"sort_address_green"]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) cell = [self twoSectionWithtext:@"送达时间" andTitle:@"极速送达"];
        else cell = [self twoSectionWithtext:@"鲜果备注" andTitle:@"点击添加备注"];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 0){
        
        cell = [[YYOrderCell alloc] initWithCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    return cell;
    
}
//第二组时创建一个cell
- (UITableViewCell *)twoSectionWithtext:(NSString *)text andTitle:(NSString *)title{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = text;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 245, 44)];
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = YYGrayLineColor;
    
    [cell.contentView addSubview:label];
    return cell;
}
//第一组时创建一个带图标的textField
- (UITableViewCell *)cellWithPlaceholder:(NSString *)placeholder andImage:(UIImage *)icon{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
    field.placeholder = placeholder;
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = icon;
    iconView.height = 44;
    iconView.width = 44;
    iconView.contentMode = UIViewContentModeCenter;
    
    field.leftView = iconView;
    field.leftViewMode = UITextFieldViewModeAlways;
    
    [cell.contentView addSubview:field];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark选中tableView的某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"期望送达时间" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"立即送出" otherButtonTitles:@"1小时后送出", nil];
            [actionsheet showInView:self.view];
        }
        else if(indexPath.row == 1){
            YYAddRemarksController *addController = [[YYAddRemarksController alloc] init];
            [self.navigationController pushViewController:addController animated:YES];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}
@end
