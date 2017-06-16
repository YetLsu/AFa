//
//  YYHealthSearchViewController.m
//  eto.fruitapp
//
//  Created by Apple on 16/1/9.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "YYHealthSearchViewController.h"
#import "YYCircleTableViewCell2.h"
#import "YYCircleModel.h"
#import "YYAccountTool.h"

@interface YYHealthSearchViewController ()<UITableViewDelegate,UITableViewDataSource,YYCircleTableViewCell2Delegate>

@property (nonatomic,strong) NSMutableArray *modelArrays2;//假数据
@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end

@implementation YYHealthSearchViewController



- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (instancetype)init{
    if (self = [super init]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen - 104) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 0.001)];
        //        tableView.tableHeaderView = view;
        self.headlthTableView = tableView;
        [self getContentCell];
    }
    return self;
}

- (NSMutableArray *)modelArrays2{
    if (!_modelArrays2) {
        _modelArrays2 = [[NSMutableArray alloc] init];
    }
    return _modelArrays2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelArrays2.count+1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.modelArrays2.count) {
        YYCircleTableViewCell2 *cell = [YYCircleTableViewCell2 circleTableViewUn:tableView];
        cell.model = self.modelArrays2[indexPath.row];
        self.rowHeight = cell.cellRowHeight;
        YYLog(@"%ld",(long)indexPath.row);
        
        return cell;
    }else{
        if (self.modelArrays2.count == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLNULL"];
            
            cell.textLabel.text = @"暂时没有东西哦，敬请期待哦😊";
            self.rowHeight = 44;
            return cell;
            
        }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        self.rowHeight = 35/667.0*heightScreen;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 172/2, 26/2)];
        CGRect rect = label.frame;
        rect.origin.x = widthScreen/2.0-label.frame.size.width/2.0;
        rect.origin.y = self.rowHeight/2.0 - label.frame.size.height/2.0;
        label.frame = rect;
        [cell.contentView addSubview:label];
        label.font = [UIFont systemFontOfSize:11];
        label.text = @"只有这么多了..";
        label.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0  blue:108/255.0  alpha:1];
        //cell.backgroundColor = [UIColor grayColor];
        YYLog(@"%ld",(long)indexPath.row);
        return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYLog(@"%ld",(long)indexPath.row);
    if (indexPath.row == self.modelArrays2.count) {
        return;
    }
    
    YYCircleModel *model = self.modelArrays2[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(healthCellClickWithModel:)]) {
        [self.delegate healthCellClickWithModel:model];
    }
}

- (void)getContentCell{
    [self.modelArrays2 removeAllObjects];
    YYAccount *account = [YYAccountTool account];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=21&category=%d&buid=%@",3,account.userUID];
    YYLog(@"%@",urlStr);
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"连接成功，返回的数据是：%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSMutableArray *attMutableArray = [[NSMutableArray alloc]init];
            NSString *flaglist = responseObject[@"flaglist"];
            NSInteger count0 = flaglist.length;//字符串长度
            int count = count0;
            
            for (int i = 0; i < count; i++) {
                [attMutableArray addObject:[flaglist substringWithRange:NSMakeRange(i, 1)]];
            }
            //            for (NSString *num in attMutableArray) {
            //                YYLog(@"%@",num);
            //            }
            
            
            for (int i = 0; i < [responseObject allKeys].count - 2; i++) {
                NSDictionary *modelDic = responseObject[[NSString stringWithFormat:@"%d",i]];
                
                NSString *urlStr = modelDic[@"showimg"];
                
                NSString *categoryC1 = modelDic[@"category"];
                NSString *categoryC = nil;
                if ([categoryC1 isEqualToString:@"1"]) {
                    categoryC = @"养生";
                }else if ([categoryC1 isEqualToString:@"2"]){
                    categoryC = @"烹饪";
                }else if ([categoryC1 isEqualToString:@"3"]){
                    categoryC = @"健康";
                }else if ([categoryC1 isEqualToString:@"4"]){
                    categoryC = @"食谱";
                }
                
                NSString *topic = modelDic[@"topic"];
                
                NSString *content = modelDic[@"intro"];
                
                NSString *replyNumber = modelDic[@"post"];
                
                NSString *joinNumber = modelDic[@"member"];
                
                NSString *readNumber = modelDic[@"hot"];
                
                BOOL flag = YES;
                if ([attMutableArray[i] isEqualToString:@"0"]) {
                    flag = NO;
                }else if ([attMutableArray[i] isEqualToString:@"1"]){
                    flag = YES;
                }
                
                NSString *bcid = modelDic[@"id"];
                
                
                YYCircleModel *models1 = [YYCircleModel circleModelWithLeftImageName:urlStr withPrefixTitle:topic withReplyNumber:replyNumber.integerValue withContent:content withJoinNumber:joinNumber.integerValue withReadNumber:readNumber.integerValue withJoin:flag andBcid:bcid.intValue withCategoryC:categoryC];
                
                [self.modelArrays2 addObject:models1];
                if (i == [responseObject allKeys].count - 3) {
                    [self.headlthTableView reloadData];
                }
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"连接失败，错误原因是%@",error);
    }];
}

- (void)joinToCircle:(int)bcid{
    YYAccount *account = [YYAccountTool account];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=25&buid=%@&bcid=%d&flag=1",account.userUID,bcid];
    YYLog(@"%@",urlStr);
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"%@",responseObject);
        YYLog(@"取消关注成功");
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"取消关注失败");
    }];
    
}

- (void)quitCircle:(int)bcid{
    YYAccount *account = [YYAccountTool account];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=25&buid=%@&bcid=%d&flag=0",account.userUID,bcid];
    YYLog(@"%@",urlStr);
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"%@",responseObject);
        YYLog(@"取消关注成功");
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"取消关注失败");
    }];
    
}

@end
