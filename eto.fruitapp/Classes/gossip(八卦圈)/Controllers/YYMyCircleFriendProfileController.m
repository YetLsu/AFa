//
//  YYMyCircleFriendProfileController.m
//  圈子_V1
//
//  Created by Apple on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYMyCircleFriendProfileController.h"
#import "YYMyCircleFriendModel.h"
#import "YYMyCircleFreindTableViewCell.h"
#import "YYAccountTool.h"
#import "YYCirclePersonOtherViewController.h"

#define YY16WidthMargin 16/375.0*widthScreen
#define YY10HeightMargin 10/667.0*heightScreen
#define YY10WidthMargin 10/375.0*widthScreen
#define YY15HeightMargin 15/667.0*heightScreen
#define widthScreen [UIScreen mainScreen].bounds.size.width //屏幕宽
#define heightScreen [UIScreen mainScreen].bounds.size.height //屏幕高

#define YY108color [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1]

@interface YYMyCircleFriendProfileController () <UITableViewDataSource,UITableViewDelegate,YYMyCircleFriendModelDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *modelArrays;

@property (nonatomic,assign) CGFloat rowheight;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;


@property (nonatomic,copy) NSMutableArray *quguanID;

@property (nonatomic,strong) NSString *whereTohere;//从哪里到这里的


@end

@implementation YYMyCircleFriendProfileController

- (instancetype)initWithWhereToHere:(NSString *)whereToHere{
    if (self = [super init]) {
        self.whereTohere = whereToHere;
    }
    return self;
}


- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        
    }
    return _manager;
}

- (NSMutableArray *)quguanID{
    if (!_quguanID) {
        _quguanID = [[NSMutableArray alloc]init];
    }
    return _quguanID;
}


- (NSMutableArray *)modelArrays{
    if (!_modelArrays) {
        _modelArrays = [[NSMutableArray alloc]init];
        

        
    }
    return _modelArrays;
    //[UIImage imageNamed:@"bgq_circle_leftTopHeadImage"]
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableview];
    self.title = @"我的圈友";
    [self getAllData];
    //[UIImage imageNamed:@"navigation_previous"];
    
    
}


- (void)getAllData{
    YYAccount *account = [YYAccountTool account];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=241&buid=%@",account.userUID];
    YYLog(@"buid:%@",account.userUID);
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
                YYLog(@"请求发送功%@",responseObject);
        
        YYLog(@"okkk----%@",responseObject[@"msg"]);
        
        if ([responseObject[@"msg"] isEqualToString:@"none"]) {
            YYLog(@"没有好友");
        }
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [self.modelArrays removeAllObjects];
            
            for (int i = 0; i < responseObject.allKeys.count - 2; i++) {
                YYLog(@"%lu",(unsigned long)responseObject.allKeys.count);
                NSString *key = [NSString stringWithFormat:@"%d",i];
                NSDictionary *modelDic = responseObject[key];
                //                YYLog(@"%@\n%d",modelDic,i);
                YYLog(@"%@",modelDic);
                //http://www.sxeto.com/fruitApp/8344C3E4C864518DEBFF80D4C3FC73AD/headimg/head.png
                NSString *strUrl = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@", modelDic[@"headimg"]];
                YYLog(@"%@",strUrl);
                
                NSString *friendName = modelDic[@"nickname"];
                
                NSString *buid = modelDic[@"buid"];
                
                
                YYMyCircleFriendModel *model = [YYMyCircleFriendModel myCircleFriendModelWithLeftImageStr:strUrl withFriendName:friendName withContentStr:@"这个人很懒什么都没有留下" withBuid:buid withAttention:@"1"];
                
                [self.modelArrays addObject:model];

                [self.tableView reloadData];
            }
        }
        //[self.squareTableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"请求发送失败%@",error);
        
        //[self.squareTableView.mj_header endRefreshing];
    }];

    
}

- (void)setupTableview{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];

    
}

#pragma mark ----- tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYMyCircleFreindTableViewCell *cell = [YYMyCircleFreindTableViewCell myCircleFreindTableViewCellWiThTableView:tableView];
    YYMyCircleFriendModel *model = self.modelArrays[indexPath.row];
    cell.selectionStyle = 0;
    
    cell.model = model;
    self.rowheight = cell.rowHeight;
#pragma mark ----- cell 的协议方法
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYMyCircleFriendModel *model = self.modelArrays[indexPath.row];
    YYCirclePersonOtherViewController *cPOVC = [[YYCirclePersonOtherViewController alloc] initWithBuid:model.buid withAtt:@"1" withWhere:self.whereTohere];
    [self.navigationController pushViewController:cPOVC animated:YES];
}

#pragma mark ----- 取消关注
- (void)attationBtnQuGuanWith:(NSString *)attation bfuid:(NSString *)bfuid{
    [self.quguanID addObject:bfuid];
}
#pragma mark ----- 关注
- (void)attationBtnGuanZhuWith:(NSString *)attation bfuid:(NSString *)bfuid{
    [self.quguanID removeObject:self.quguanID.lastObject];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowheight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    YYAccount *account = [YYAccountTool account];
    YYLog(@"==========%@",self.quguanID);
    for (NSString *buid in self.quguanID) {
        NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=24&buid=%@&bfuid=%@&flag=0",account.userUID,buid];
        YYLog(@"%@",urlStr);
        [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            YYLog(@"%@",responseObject);
            YYLog(@"取消关注成功");
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            YYLog(@"取消关注失败");
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
