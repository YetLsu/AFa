//
//  YYHomeNewGuaiViewController.m
//  eto.fruitapp
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "YYHomeNewGuaiViewController.h"
#import "YYHomeNewBigTestModel.h"
#import "YYHomeNewBigTestandGuidCell.h"
#import "YYHomeNewWebViewViewController.h"

@interface YYHomeNewGuaiViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) CGFloat rowheight;//cell高
@property (nonatomic,strong) NSMutableArray *modelArrays;//模型的数组
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end

@implementation YYHomeNewGuaiViewController

- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen) style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        _tableView  = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
    return _tableView;
}

- (NSMutableArray *)modelArrays{
    if (!_modelArrays) {
        _modelArrays = [[NSMutableArray alloc]init];
    }
    return _modelArrays;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = NO;
    self.title = @"格调指南";
    [self getModels];
    // Do any additional setup after loading the view.
}

#pragma mark ----- UITableView的数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelArrays.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYHomeNewBigTestandGuidCell *cell = [YYHomeNewBigTestandGuidCell HomeNewBigTestandGuidCellWithTableView:tableView];
    cell.model = self.modelArrays[indexPath.section];
    
    self.rowheight = cell.rowHeight;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowheight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYHomeNewBigTestModel *model = self.modelArrays[indexPath.section];
    
    YYHomeNewWebViewViewController *webView = [[YYHomeNewWebViewViewController alloc]initWithModel:model];
    [self.navigationController pushViewController:webView animated:YES];
    
    YYLog(@"%ld",model.bid);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- 数组排序

- (void)getCurrentData:(NSMutableArray *)array{
    YYHomeNewBigTestModel *a = nil;
    YYHomeNewBigTestModel *b = nil;
    for (int i = 0; i < array.count; i++) {
        for (int j = i + 1; j <array.count ; j++) {
            a = array[i];
            b = array[j];
            
            if (a.date < b.date) {
                [array replaceObjectAtIndex:i withObject:b];
                [array replaceObjectAtIndex:j withObject:a];
                
            }
        }
    }
    
    self.modelArrays  = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];

    
}

- (void)getModels{
    [self.modelArrays removeAllObjects];
    [self.manager GET:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=3&category=2" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"连接服务器成功,返回的数据是:%@",responseObject);
        if ([responseObject[@"msg"]isEqualToString:@"ok"]) {
            NSArray *retarray = responseObject[@"ret"];
            int count = retarray.count;
            for (int i = 0; i < count ; i++) {
                NSDictionary *modelDic = retarray[i];
                NSString *iconStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp%@",modelDic[@"headimg"]];
                NSString *nickName = modelDic[@"username"];
                NSString *title = modelDic[@"title"];
                NSString *picStr = [NSString stringWithFormat:@"http://www.sxeto.com%@",modelDic[@"showimg"]];
                NSString *bid = modelDic[@"id"];
                NSString *contentUrl = [NSString stringWithFormat:@"http://www.sxeto.com%@",modelDic[@"url"]];
                NSString *intro = modelDic[@"intro"];
                
                YYHomeNewBigTestModel *model = [[YYHomeNewBigTestModel alloc]initWithIcon:iconStr withAuthorName:nickName withTItle:title withImagePic:picStr withBid:bid.integerValue withContentURL:contentUrl withIntro:intro withDate:0];
                [self.modelArrays addObject:model];
                if (i == count -1) {
                    [self.tableView reloadData];
                }
            }
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"连接服务器失败，错误原因是%@",error);
    }];
}


@end
