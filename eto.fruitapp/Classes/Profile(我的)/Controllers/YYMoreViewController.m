//
//  YYMoreViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/30.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYMoreViewController.h"


@interface YYMoreViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UITableView *moreTableView;

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *versionLabel;

@end

@implementation YYMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YYViewBGColor;
    
    //增加imageView
    UIImageView * imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    self.imageView.image = [UIImage imageNamed:@"18"];
    self.imageView.x = 130 / 375.0 * widthScreen;
    self.imageView.y = 100 /667.0 *heightScreen;
    self.imageView.height = 115/667.0 *heightScreen;
    self.imageView.width = 115 /375.0 * widthScreen;
    
    //增加版本号label
    UILabel *vesionLabel = [[UILabel alloc] init];
    vesionLabel.frame = CGRectMake(0, self.imageView.height + self.imageView.y + 5, widthScreen, 20);
    [self.view addSubview:vesionLabel];
    self.versionLabel = vesionLabel;
    self.versionLabel.text = @"版本号1.0.0";
    self.versionLabel.textColor = YYGrayTextColor;
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    
    //增加tableView
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setViewFrame:CGRectMake(0, 323, 375, 88)];
    [self.view addSubview:tableView];
    self.moreTableView = tableView;
    self.moreTableView.height = 88;
    
    self.moreTableView.dataSource = self;
    self.moreTableView.delegate = self;
    self.moreTableView.scrollEnabled = NO;
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.title = @"更多";
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"欢迎页";
       
    }
    else{
        cell.textLabel.text = @"分享好友";
        
    }
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
