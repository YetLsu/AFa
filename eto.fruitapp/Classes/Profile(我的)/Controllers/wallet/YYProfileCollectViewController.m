//
//  YYProfileCollectViewController.m
//  eto.fruitapp
//
//  Created by Apple on 16/1/21.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "YYProfileCollectViewController.h"
#import "YYOfficColdCellModel.h"
#import "YYOfficColdCell.h"
#import "YYAccountTool.h"
#import "YYCollectionArticleModel.h"
#import "YYProfileCollectArticleTableViewCell.h"
#import "YYCollectionArticleViewController.h"


@interface YYProfileCollectViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
/** 文章 */
@property (nonatomic,strong) NSMutableArray *articleArray;
/** 说说 */
@property (nonatomic,strong) NSMutableArray *talkArray;
/** 帖子 */
@property (nonatomic,strong) NSMutableArray *tieArray;

/** 模型的数组 */
@property (nonatomic,strong) NSMutableArray *modelArray;

/** 文章按钮 */
@property (nonatomic,weak) UIButton *articleBtn;
/** 说说按钮 */
@property (nonatomic,weak) UIButton *talkBtn;
/** 帖子按钮 */
@property (nonatomic,weak) UIButton *tieBtn;

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic,strong) YYAccount *account;

@property (nonatomic,assign) CGFloat rowheight;


@end

@implementation YYProfileCollectViewController

- (YYAccount *)account{
    if (!_account) {
        _account = [YYAccountTool account];
    }
    return _account;
}

- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (NSMutableArray *)articleArray{
    if (!_articleArray) {
        _articleArray = [[NSMutableArray alloc]init];
    }
    return _articleArray;
}

- (NSMutableArray *)talkArray{
    if (!_talkArray) {
        _talkArray = [[NSMutableArray alloc]init];
    }
    return _talkArray;
}

- (NSMutableArray *)tieArray{
    if (!_tieArray) {
        _tieArray = [[NSMutableArray alloc]init];
    }
    return _tieArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen) style:UITableViewStyleGrouped];
        [self.view addSubview:tableview];
        _tableView = tableview;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}



- (instancetype)init{
    if (self = [super init]) {
        [self getCollectArticle];
        [self getCollectTalk];
        [self getCollectTie];
        
    }
    return self;
}


#pragma mark ---- 获取收藏的文章

- (void)getCollectArticle{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=580&buid=%@&category=1",self.account.userUID];
    //NSLog(@"%@",urlStr);
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"连接服务器成功，返回的数据是%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSArray *modelarr = responseObject[@"ret"];
            NSArray *modelarr1 = responseObject[@"ret_a"];
            
            for (int i = 0; i < modelarr.count; i++) {
                NSDictionary *dic = modelarr[i];
                NSDictionary *dic1 = modelarr1[i];
                
                NSString *bccid = dic[@"bccid"];
                
                NSString *bcid = dic[@"bcid"];
                
                NSString *time1 = dic[@"time"];
                NSString *time = [self timeWithLastTime:time1.longLongValue];
                
                NSString *headimg = dic1[@"headimg"];
                
                NSString *img = dic1[@"img"];
                
                NSString *intro = dic1[@"intro"];
                
                NSString *title = dic1[@"title"];
                
                NSString *username = dic1[@"username"];
                
//                @property (nonatomic,copy) NSString *bccid;//收藏的文章，在文章表中的id
//                @property (nonatomic,copy) NSString *bcid;//收藏的id
//                @property (nonatomic,copy) NSString *time;//收藏的时间
//                @property (nonatomic,strong) NSURL *headimg;//头像的url
//                @property (nonatomic,strong) NSURL *img;//图片
//                @property (nonatomic,copy) NSString *intro;//介绍
//                @property (nonatomic,copy) NSString *title;//标题
//                @property (nonatomic,copy) NSString *userName;//作者的名字
                YYCollectionArticleModel *model = [[YYCollectionArticleModel alloc]initWithBccid:bccid withBcid:bcid withTime:time withHeadimg:headimg withImg:img withIntro:intro withTitle:title withUserName:username];
                

                
                [self.articleArray addObject:model];
                self.modelArray = self.articleArray;
                [self.tableView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"连接服务器错误"];
    }];
}


#pragma mark ----- 获取收藏的说说

- (void)getCollectTalk{
    [self.talkArray addObject:@"6"];
    [self.talkArray addObject:@"7"];
    [self.talkArray addObject:@"8"];
    [self.talkArray addObject:@"9"];
    
    
}

#pragma mark ----- 获取收藏的帖子

- (void)getCollectTie{
    [self.tieArray addObject:@"10"];
    [self.tieArray addObject:@"11"];
    
}

#pragma mark ----- 点击收藏的文章后获取文章的链接


- (void)getCollectArticleURL:(NSString *)baid{//这里的baid是文章的编号 也就是上方得到bccid
    NSString *url = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=32&buid=%@&baid=%@",self.account.userUID,baid];
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {//链接成功
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSString *url1 = responseObject[@"url"];
            NSURL *url = [NSURL URLWithString:url1];
            
            YYCollectionArticleViewController *VC = [[YYCollectionArticleViewController alloc]initWithURL:url];
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //链接失败
        [MBProgressHUD showError:@"连接服务器错误"];
    }];
    
}

#pragma mark ----- 添加头部视图

- (void)setTableViewHeadView{
    CGFloat btnX = 52;
    
    CGFloat btnW = 52;
    CGFloat btnH = 30;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, widthScreen, 30)];
    UIButton *articleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    articleBtn.frame = CGRectMake(0, 0, btnW, btnH);
    [articleBtn setTitle:@"文章" forState:UIControlStateNormal];
    [articleBtn setTitle:@"文章" forState:UIControlStateSelected];
    [articleBtn setTitleColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1] forState:UIControlStateNormal];
    [articleBtn setTitleColor:[UIColor colorWithRed:179/255.0 green:151/255.0 blue:57/255.0 alpha:1] forState:UIControlStateSelected];
    [articleBtn addTarget:self action:@selector(ClickArticle) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:articleBtn];
    self.articleBtn = articleBtn;
    
    
    
    UIButton *talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    talkBtn.frame = CGRectMake(btnX, 0, btnW, btnH);
    [talkBtn setTitle:@"说说" forState:UIControlStateNormal];
    [talkBtn setTitle:@"说说" forState:UIControlStateSelected];
    [talkBtn setTitleColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1] forState:UIControlStateNormal];
    [talkBtn setTitleColor:[UIColor colorWithRed:179/255.0 green:151/255.0 blue:57/255.0 alpha:1] forState:UIControlStateSelected];
    [talkBtn addTarget:self action:@selector(ClickTalk) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:talkBtn];
    self.talkBtn = talkBtn;
    
    
    UIButton *tieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tieBtn.frame = CGRectMake(btnX*2, 0, btnW, btnH);
    [tieBtn setTitle:@"帖子" forState:UIControlStateNormal];
    [tieBtn setTitle:@"帖子" forState:UIControlStateSelected];
    [tieBtn setTitleColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1] forState:UIControlStateNormal];
    [tieBtn setTitleColor:[UIColor colorWithRed:179/255.0 green:151/255.0 blue:57/255.0 alpha:1] forState:UIControlStateSelected];
    [tieBtn addTarget:self action:@selector(ClickTie) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:tieBtn];
    self.tieBtn = tieBtn;
    self.tableView.tableHeaderView = headView;
    
    headView.backgroundColor = [UIColor whiteColor];
    
    
}
//文章按钮被点击
- (void)ClickArticle{
    self.modelArray = [NSMutableArray arrayWithArray:self.articleArray];
    self.talkBtn.selected = NO;
    self.tieBtn.selected = NO;
    self.articleBtn.selected = YES;
    [self.tableView reloadData];
    
}
//说说按钮被点击
- (void)ClickTalk{
    self.modelArray = [NSMutableArray arrayWithArray:self.talkArray];
    self.talkBtn.selected = YES;
    self.tieBtn.selected = NO;
    self.articleBtn.selected = NO;
    [self.tableView reloadData];
    
}
//帖子按钮被点击
- (void)ClickTie{
    self.modelArray = [NSMutableArray arrayWithArray:self.tieArray];
    self.talkBtn.selected = NO;
    self.tieBtn.selected = YES;
    self.articleBtn.selected = NO;
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableViewHeadView];
    self.articleBtn.selected = YES;
    self.modelArray = [NSMutableArray arrayWithArray:self.articleArray];
    self.title = @"我的收藏";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----- UItableView的数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.articleBtn.selected == YES) {
        YYProfileCollectArticleTableViewCell *cell = [YYProfileCollectArticleTableViewCell YYProfileCollectArticleTableViewWithTableView:tableView];
        YYCollectionArticleModel *model = self.articleArray[indexPath.section];
        
        cell.model = model;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.rowheight = cell.rowheight;
        
        
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YYProfileCollectViewController"];
        cell.textLabel.text = self.modelArray[indexPath.section];
        return cell;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.articleBtn.selected == YES) {
        return self.rowheight;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return YY10HeightMargin;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return YY10HeightMargin;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.articleBtn.selected == YES) {
        YYLog(@"第%ld篇文章被点击",indexPath.section);
        YYCollectionArticleModel *model = self.articleArray[indexPath.section];
        [self getCollectArticleURL:model.bccid];
        
    }else if (self.talkBtn.selected == YES){
        YYLog(@"第%ld条说说被点击",indexPath.section);
        [MBProgressHUD showError:@"待完善"];
    }else{
        YYLog(@"第%ld条帖子被点击",indexPath.section);
        [MBProgressHUD showError:@"待完善"];
    }
}

#pragma mark ----- 删除模式

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//删除完后
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [self.tableView reloadData];
}
//删除的具体实现
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.modelArray removeObjectAtIndex:indexPath.section];
        if (self.articleBtn.selected == YES) {
            [self.articleArray removeObjectAtIndex:indexPath.section];
            
            
            
            
            
            
            
        }else if (self.talkBtn.selected == YES){
            [self.talkArray removeObjectAtIndex:indexPath.section];
        }else if (self.tieBtn.selected == YES){
            [self.tieArray removeObjectAtIndex:indexPath.section];
        }
        [self deleteCollection];
        
        // Delete the row from the data source.
        
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

#pragma mark 计算时间
- (NSString *)timeWithLastTime:(long long)lastTime{
    NSString *returnTime;
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    long long nowTimeL = [[NSNumber numberWithDouble:nowTime] longLongValue];
    
    long long detalTime = nowTimeL - lastTime;
    
    if (detalTime < 60) {
        returnTime = [NSString stringWithFormat:@"%lld秒前",detalTime];
    }
    else if (detalTime<3600 & detalTime >=60){
        returnTime = [NSString stringWithFormat:@"%lld分钟前",detalTime/60];
    }
    else if (detalTime >= 3600 & detalTime <86400){
        returnTime = [NSString stringWithFormat:@"%lld小时前",detalTime/60/60];
    }
    else if (detalTime>=86400){
        returnTime = [NSString stringWithFormat:@"%lld天前",detalTime/3600/24];
    }
    return returnTime;
}

- (void)deleteCollection{
    
}




@end
