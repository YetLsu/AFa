//
//  YYAddressController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/4.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYAddressController.h"
#import "YYAddressCellModel.h"
#import "YYAddressTableViewCell.h"
#import "YYAddAddressController.h"


@interface YYAddressController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;


@end

@implementation YYAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配送地址";
    
    //添加tableVIew
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    //添加右侧按钮
    UIImage *image = [UIImage imageNamed:@"profile_add"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addAddress)];
    
    
   
    
}
- (void)addAddress{
    YYAddAddressController *addAddress = [[YYAddAddressController alloc] init];
    [self.navigationController pushViewController:addAddress animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYAddressCellModel *model = [[YYAddressCellModel alloc] init];
    model.name = @"刘有";
    model.address = @"柯桥区湖西路天马大厦";
    model.phone = @"1234567893";
    static NSString *ID = @"addressCell";
    YYAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYAddressTableViewCell alloc] initWithAddressCell];
    }
    cell.AddressModel = model;
    
    return cell;
}

@end
