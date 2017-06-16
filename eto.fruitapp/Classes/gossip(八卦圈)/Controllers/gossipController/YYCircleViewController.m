//
//  YYCircleViewController.m
//  圈子_V1
//
//  Created by Apple on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCircleViewController.h"
#import "YYCircleTableViewCell.h"
#import "YYCircleTableViewCell2.h"
#import "YYCircleModel.h"
#import "FFScrollView.h"

#import "YYCircleDetailTableViewController.h"

#import "YYAccountTool.h"
#import "MJRefresh.h"





@interface YYCircleViewController () <UITableViewDataSource,UITableViewDelegate,FFScrollViewDelegate,YYCircleTableViewCell2Delegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArrays1;//推荐的
@property (nonatomic,strong) NSMutableArray *modelArrays2;//已经加入的
//@property (nonatomic,strong) NSMutableArray *testArray;//客户端返回的所有圈子

@property (nonatomic,assign) CGFloat rowHeight;//行高
@property (nonatomic,strong) UIView *headView;//头部视图
@property (nonatomic,strong) NSArray *pictureArrays;//头部的图片数组

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, weak) UIRefreshControl *control;
@property (nonatomic,strong)NSString *flag;//用来区分从哪里来的1是八卦圈 2是首页


@end

@implementation YYCircleViewController
- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        
    }
    return _manager;
}

- (instancetype)initWithFlag:(NSString *)flag{
    if (self = [super init]) {
        self.flag = flag;
        [self.view addSubview:self.tableView];
        [self addTableViewHeadView:CGRectMake(0, 0, widthScreen, 350/2/667.0*heightScreen)];
        [self reloadThisView];
    }
    return self;
}


- (void)reloadThisView{
    [self refreshControlTableView];
    [self topCellTableView];
}

#pragma mark ----- 头部的我的数据

- (void)topCellTableView{
    YYAccount *account = [YYAccountTool account];
    [self.modelArrays1 removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=212&buid=%@",account.userUID];
    YYLog(@"%@",urlStr);
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        //        YYLog(@"请求发送功%@",responseObject);
        
        YYLog(@"okkk%@",responseObject[@"msg"]);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [self.modelArrays1 removeAllObjects];
            
            for (int i = 0; i < responseObject.allKeys.count - 1; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                NSDictionary *modelDic = responseObject[key];
                //                YYLog(@"%@\n%d",modelDic,i);
                YYLog(@"%@",modelDic);
                
                NSString *strUrl = modelDic[@"showimg"];
                YYLog(@"%@",strUrl);
                
                NSString *topic = modelDic[@"topic"];//主题
                
                NSString *post = modelDic[@"post"];//今日 发帖数
                NSInteger postNumber = post.integerValue;
                
                NSString *content = modelDic[@"intro"];//圈子的内容
                
                NSString *member = modelDic[@"member"];//关注的成员数
                NSInteger memberNumber = member.integerValue;
                
                NSString *join = modelDic[@"hot"];//参与的  热度
                NSInteger joinNumber = join.integerValue;
                
                NSString *bcid = modelDic[@"id"];//圈子的id
                int bcID = bcid.intValue;
                
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
                
                YYCircleModel *model = [YYCircleModel circleModelWithLeftImageName:strUrl withPrefixTitle:topic withReplyNumber:postNumber withContent:content withJoinNumber:memberNumber withReadNumber:joinNumber withJoin:YES andBcid:bcID withCategoryC:categoryC];
                
                [self.modelArrays1 addObject:model];
                //                YYLog(@"%lu",(unsigned long)model.imageUrlStrsArray.count);
                [self.circleTableView reloadData];
            }
        }
        //[self.squareTableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"请求发送失败%@",error);
        
        //[self.squareTableView.mj_header endRefreshing];
    }];

}


#pragma mark ----- 刷新加载数据
- (void)refreshControlTableView{
    YYAccount *account = [YYAccountTool account];
    [self.modelArrays2 removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=213&buid=%@",account.userUID];
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        //        YYLog(@"请求发送功%@",responseObject);
        
        YYLog(@"okkk%@",responseObject[@"msg"]);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [self.modelArrays2 removeAllObjects];
            
            for (int i = 0; i < responseObject.allKeys.count - 1; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                NSDictionary *modelDic = responseObject[key];
                //                YYLog(@"%@\n%d",modelDic,i);
                YYLog(@"%@",modelDic);
                
                NSString *strUrl = modelDic[@"showimg"];
                YYLog(@"%@",strUrl);
                
                NSString *topic = modelDic[@"topic"];//主题
                
                NSString *post = modelDic[@"post"];//今日 发帖数
                NSInteger postNumber = post.integerValue;
                
                NSString *content = modelDic[@"intro"];//圈子的内容
                
                NSString *member = modelDic[@"member"];//关注的成员数
                NSInteger memberNumber = member.integerValue;
                
                NSString *join = modelDic[@"hot"];//参与的  热度
                NSInteger joinNumber = join.integerValue;
                
                NSString *bcid = modelDic[@"id"];//圈子的id
                int bcID = bcid.intValue;
                
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

                YYCircleModel *model = [YYCircleModel circleModelWithLeftImageName:strUrl withPrefixTitle:topic withReplyNumber:postNumber withContent:content withJoinNumber:memberNumber withReadNumber:joinNumber withJoin:NO andBcid:bcID withCategoryC:categoryC];
                
                [self.modelArrays2 addObject:model];
                //                YYLog(@"%lu",(unsigned long)model.imageUrlStrsArray.count);
                [self.circleTableView reloadData];
            }
        }
        //[self.squareTableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"请求发送失败%@",error);
        
        //[self.squareTableView.mj_header endRefreshing];
    }];
    
}


- (NSMutableArray *)modelArrays1{
    if (!_modelArrays1) {
        _modelArrays1 = [[NSMutableArray alloc] init];
    }
    return _modelArrays1;
}

- (NSMutableArray *)modelArrays2{
    if (!_modelArrays2) {
        _modelArrays2 = [[NSMutableArray alloc] init];
       
    }
    return _modelArrays2;
}


- (UITableView *)tableView{
    if (!_tableView) {
        if ([self.flag isEqualToString:@"1"]) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, widthScreen, heightScreen - 64  - 49) style:UITableViewStyleGrouped];
            self.circleTableView = _tableView;
            _tableView.delegate = self;
            _tableView.dataSource = self;
            YYLog(@"-----%f,-----%f,-----%f",self.view.frame.size.height,heightScreen,_tableView.frame.size.height);
        }else if ([self.flag isEqualToString:@"2"]){
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen) style:UITableViewStyleGrouped];
            self.circleTableView = _tableView;
            _tableView.delegate = self;
            _tableView.dataSource = self;
        }
   
    }
    return _tableView;
}

- (NSArray *)pictureArrays{
    if (!_pictureArrays) {
        _pictureArrays = [[NSArray alloc]init];

        _pictureArrays = @[@"bgq_circle_headView",@"bgq_circle_headView",@"bgq_circle_headView",@"bgq_circle_headView",@"bgq_circle_headView"];
        
    }
    return _pictureArrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"reflashYYCircleViewController" object:nil];
    //NSInteger number = self.testArray.count;
    
}

-(void)receiveMessage:(NSNotification *)noti{
    [self reloadThisView];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadThisView];
}

- (void)addTableViewHeadView:(CGRect)frame{
    UIView *headViewModel = [[UIView alloc] initWithFrame:frame];
    FFScrollView *scroll = [[FFScrollView alloc]initPageViewWithFrame:frame views:self.pictureArrays];
    //隐藏横向滚动条
//    scroll.showsHorizontalScrollIndicator = FALSE;
    scroll.pageViewDelegate = self;
    [headViewModel addSubview:scroll];

    self.tableView.tableHeaderView = headViewModel;
}
#pragma mark --- FFScrollView delegate method
- (void)scrollViewDidClickedAtPage:(NSInteger)pageNumber
{
    switch (pageNumber) {
        case 0:
            NSLog(@"1");
            break;
        case 1:
            NSLog(@"2");
            break;
        case 2:
            NSLog(@"3");
            break;
        case 3:
            NSLog(@"4");
            break;
            
        case 4:
            NSLog(@"5");
            break;
            
        default:
            break;
    }
}




#pragma mark ----- tableview的方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.modelArrays1.count+1;
    }else if (section == 1){
        YYLog(@"%lu",(self.modelArrays2.count+1));
        return self.modelArrays2.count+1;
        
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"all"];
            cell.textLabel.text = @"我的圈子";
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
            self.rowHeight = 25/667.0*heightScreen;
            cell.selectionStyle = 0;
            return cell;
        }else{
            YYCircleTableViewCell2 *cell = [YYCircleTableViewCell2 circleTableViewUn:tableView];
            cell.model = self.modelArrays1[indexPath.row-1];
            cell.delegate = self;
            self.rowHeight = cell.cellRowHeight;
            cell.selectionStyle = 0;
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"all"];
            cell.textLabel.text = @"为您推荐的圈子";
            cell.textLabel.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.selectionStyle = 0;
            self.rowHeight = 25/667.0*heightScreen;
            return cell;
        }else{
            YYCircleTableViewCell2 *cell = [YYCircleTableViewCell2 circleTableViewUn:tableView];
            cell.model = self.modelArrays2[indexPath.row-1];
            //cell2的协议方法
            cell.delegate = self;
            self.rowHeight = cell.cellRowHeight;
            cell.selectionStyle = 0;
            return cell;
        }
        
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"all"];
        self.rowHeight = 30/667.0*heightScreen;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 12)];
        [cell.contentView addSubview:view];
        CGRect rect = view.frame;
        rect.origin.y = self.rowHeight/2.0 - rect.size.height/2.0;
        rect.origin.x = widthScreen/2.0 - rect.size.width/2.0;
        view.frame = rect;
        //view.backgroundColor = [UIColor blueColor];
        //加号
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.height, rect.size.height)];
        imageView.image = [UIImage imageNamed:@"bgq_circle_more"];
        //测试
        //imageView.backgroundColor = [UIColor greenColor];
        [view addSubview:imageView];
        //文字
        UILabel *wordlabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + 3, 0, rect.size.width - imageView.frame.size.width - 3, rect.size.height)];
        wordlabel.font = [UIFont systemFontOfSize:12];
        wordlabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
        wordlabel.text = @"刷新圈子";
        [view addSubview:wordlabel];
        cell.selectionStyle = 0;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10/667.0*heightScreen;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;

}


- (void)joinToCircle:(int)bcid{
        YYAccount *account = [YYAccountTool account];
        NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=25&buid=%@&bcid=%d&flag=1",account.userUID,bcid];
        YYLog(@"%@",urlStr);
        [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            YYLog(@"%@",responseObject);
            YYLog(@"取消关注成功");
            [self reloadThisView];
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
        [self reloadThisView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"取消关注失败");
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYLog(@"11");
    if (indexPath.section == 2) {
        YYLog(@"点击加载更多,变为刷新圈子");
        [self reloadThisView];
    }else{
      YYCircleModel *model = nil;
      if (indexPath.section == 0) {
          model = self.modelArrays1[indexPath.row - 1];
        
      }else if (indexPath.section == 1){
          model = self.modelArrays2[indexPath.row - 1];
      }
      if ([self.delegate respondsToSelector:@selector(CircleModelClickWithModel:)]) {
          [self.delegate CircleModelClickWithModel:model];
      }
        YYCircleDetailTableViewController *circleDetail = [[YYCircleDetailTableViewController alloc]initWithCircleModel:model];
        [self.navigationController pushViewController:circleDetail animated:YES];
    }
    
}





@end
