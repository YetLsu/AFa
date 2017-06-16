//
//  YYChangeAddressController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/21.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYChangeAddressController.h"
#import "YYSearchAddressController.h"

@interface YYChangeAddressController ()

@end

@implementation YYChangeAddressController
- (instancetype)init{
    return self = [super initWithStyle:UITableViewStyleGrouped];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setImage:[UIImage imageNamed:@"sort_search_high"] forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(searchAddress) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = @"更换地址";
    self.tableView.backgroundColor = YYGrayColor;
}
#pragma mark 搜索
- (void)searchAddress{
    YYSearchAddressController *searchVC = [[YYSearchAddressController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
//返回上个控制器
- (void)previousController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 15, 20)];
        iconView.image = [UIImage imageNamed:@"sortAddress"];
        [cell.contentView addSubview:iconView];
        iconView.contentMode = UIViewContentModeCenter;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = YYGrayTextColor;
        label.frame = CGRectMake(32, 0, 300, 44);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *address = [defaults stringForKey:YYAddressKey];
        if (!address) {
            address = @"正在获取地址";
        }
        label.text = address;
        [cell.contentView addSubview:label];
        return cell;
    }
    
    static NSString *addressId = @"YYChangeAddressController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressId];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = YYGrayTextColor;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"湖西路天马大厦901";
    }else{
        cell.textLabel.text = @"福东花园东区13幢";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"定位当前所在位置";
    }
    return @"配送地址";
}

@end
