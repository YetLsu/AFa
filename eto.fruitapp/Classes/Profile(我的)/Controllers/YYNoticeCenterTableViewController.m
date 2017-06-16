//
//  YYNoticeCenterTableViewController.m
//  通知中心
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYNoticeCenterTableViewController.h"
#import "YYNoticCenterTableViewCell.h"
#import "YYNoticCenterModel.h"
#import "YYProfileDataBase.h"
#import "YYAccountTool.h"

@interface YYNoticeCenterTableViewController ()
@property (nonatomic,strong) NSMutableArray *modelArrays;
@property (nonatomic,assign) CGFloat rowHeight;

@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;

@property (nonatomic, assign) NSInteger category;

@end

@implementation YYNoticeCenterTableViewController
- (instancetype)initWithCategory:(NSInteger)category{
    if (self = [super init]) {
        self.category = category;
    }
    return self;
}
- (void)dealloc{
    if (self.category == 1) {
        NSString *yiduUrl = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=55&buid=%@&category=1",[YYAccountTool account].userUID];
        [self.manager GET:yiduUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
            YYLog(@"标为已读请求发送成功%@",responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
                YYLog(@"标为已读成功");
            }
           
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             YYLog(@"标为已读请求发送失败%@",error);
        }];
        YYLog(@"返回");
    }
    
}

- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

//获取通知
- (void)getNotifications{
    YYLog(@"获取通知");
    [self.modelArrays removeAllObjects];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=51&buid=%@&category=%ld",[YYAccountTool account].userUID, self.category];
    YYLog(@"%@",urlStr);

    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        
//        YYLog(@"%@",responseObject);
        YYLog(@"%ld",responseObject.allKeys.count);
        for (int i = 0; i < responseObject.allKeys.count - 1; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            NSDictionary *dic = responseObject[key];
            
//            YYLog(@"%@",dic);
            NSString *noticID = dic[@"id"];
            //截取时间
            NSString *date = (NSString *)dic[@"time"];
            NSRange range = [date rangeOfString:@"201"];
            NSInteger fromIndex = range.length + range.location + 2;
            date = [date substringWithRange:NSMakeRange(fromIndex, 11)];
            
            NSString *read = dic[@"visited"];
            NSInteger readBOOL = read.integerValue;
            YYNoticCenterModel *model = [YYNoticCenterModel noticWithTiTle:@"您有一个新的评论" withUserSay:dic[@"content"] withContentNotic:@"" withDate:date withRead:readBOOL withNoticID:noticID.integerValue];
            
//            YYLog(@"%ld",noticID.integerValue);
            
            [self.modelArrays addObject:model];
//            [[YYProfileDataBase shareProfileDataBase] addprofile_notification:model];

        }
        [self.tableView reloadData];
       
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"失败%@",error);
    }];

}

- (NSMutableArray *)modelArrays{
    
    
    if (!_modelArrays) {
        _modelArrays = [NSMutableArray array];

    }
    return _modelArrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知中心";
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 0.1)];
    
    [self getNotifications];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.modelArrays.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYNoticCenterTableViewCell *cell = [YYNoticCenterTableViewCell noticeTableViewCell:tableView];
    cell.model = self.modelArrays[indexPath.row];
    self.rowHeight = cell.rowHeight;
    if (!cell.model.read) {
        cell.pointImageView.image = [UIImage imageNamed:@"profile_Push_yellowCircle"];
        cell.titleLabel.textColor = [UIColor blackColor];
    }else{
        cell.pointImageView.image = nil;
        cell.titleLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
    }
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    YYNoticCenterModel *model = self.modelArrays[indexPath.row];
    
    NSString *deleteOneStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=53&buid=%@&list=%ld",[YYAccountTool account].userUID,model.noticID];
    
    [self.manager GET:deleteOneStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        YYLog(@"删除一条记录发送成功");
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"删除一条记录成功");
            [self getNotifications];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"删除一条记录发送失败");
    }];
    
}
#warning 点击单元格之后的效果
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableArray *modelArrays1 = [[NSMutableArray alloc]init];
//    YYNoticCenterModel *model = nil;
//    for (int i = 0; i < self.modelArrays.count; i++) {
//        if (i == indexPath.row) {
//            model = self.modelArrays[indexPath.row];
//            
//            [[YYProfileDataBase shareProfileDataBase] deleteprofile_notification:model];
//            model.read = YES;
//            [[YYProfileDataBase shareProfileDataBase]addprofile_notification:model];
//        }else{
//            model = self.modelArrays[i];
//        }
//        [modelArrays1 addObject:model];
//    }
//    self.modelArrays = modelArrays1;
//    [self.tableView reloadData];
//}
////去除多余的下划线
//-(void)setExtraCellLineHidden: (UITableView *)tableView
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//    //[view release];
//}




@end
