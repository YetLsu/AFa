//
//  YYSearchAddressController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/21.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSearchAddressController.h"


@interface YYSearchAddressController ()

@end

@implementation YYSearchAddressController

- (instancetype)init{
    return self = [super initWithStyle:UITableViewStyleGrouped];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = YYGrayColor;
    //设置搜索框
    UITextField *searchBar = [[UITextField alloc] init];
    [searchBar setBackground:[UIImage imageNamed:@"searchbar_textfield_background"]];
    
    searchBar.height = 30;
    searchBar.width = 612/2;

    searchBar.placeholder = @"输入地址进行搜索";
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.width = 30;
    searchIcon.height = 30;
    searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
//    [searchIcon sizeToFit];
    searchIcon.contentMode = UIViewContentModeCenter;
    
    self.navigationItem.titleView = searchBar;
    searchBar.leftView = searchIcon;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    //设置返回按钮
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:@"sort_search_high"] forState:UIControlStateNormal];
    [leftBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(previousController) forControlEvents:UIControlEventTouchUpInside];


  
}
- (void)previousController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark数据源方法
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
        label.text = @"湖西路408号";
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
