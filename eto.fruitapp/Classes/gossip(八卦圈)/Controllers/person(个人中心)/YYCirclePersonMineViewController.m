//
//  YYCirclePersonMineViewController.m
//  圈子_V1
//
//  Created by Apple on 15/12/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCirclePersonMineViewController.h"
#import "YYCirclePersonTableViewCell.h"
#import "YYPersonCellModel.h"
#import "YYCirclePersonHeadViewModel.h"
#import "YYFruitTool.h"
#import "YYCirclePersonViewController.h"
#import "YYAccountTool.h"

#import "YYDynamicMessageModel.h"
#import "YYDynamicMessageCell.h"

#import "YYCDetailViewController.h"

#define YY16WidthMargin 16/375.0*widthScreen
#define YY10HeightMargin 10/667.0*heightScreen
#define YY10WidthMargin 10/375.0*widthScreen
#define YY15HeightMargin 15/667.0*heightScreen
#define widthScreen [UIScreen mainScreen].bounds.size.width //屏幕宽
#define heightScreen [UIScreen mainScreen].bounds.size.height //屏幕高

@interface YYCirclePersonMineViewController ()<UITableViewDataSource,UITableViewDelegate,YYDynamicMessageCellDelegate>
@property (nonatomic,strong) NSMutableArray *modelsMutableArray;//内容的假数据
@property (nonatomic,strong) YYCirclePersonHeadViewModel *headViewModel;//头部视图假数据

@property (nonatomic,strong) UITableView *tableView;//列表
@property (nonatomic,weak) UIImageView *headviewImg;//头部的背景图
@property (nonatomic,strong) UIView *headView;//头部视图
@property (nonatomic,assign) CGFloat rowHeight;//单元格高度



@property (nonatomic,weak) UIView *brownLine;//棕色下划线
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end

@implementation YYCirclePersonMineViewController

- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen ) style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //YYAccount *account = [YYAccountTool account];
    //YYLog(@"http://www.sxeto.com/fruitApp/Buyer?mode=212&buid=%@",account.userUID);
    self.title = @"个人主页";
    [super viewDidLoad];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bgq_person_more"] style:0 target:self action:@selector(clickPoint:)];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupHeadViewData];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"ChangeBgimg" object:nil];
}

- (void)receiveMessage:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    self.headviewImg.image = userInfo[@"Image"];
}

#pragma mark ----- 添加头部视图，并赋值
- (void)addTableViewHeadView{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 150/2)];
    UIImageView *headViewbgimg = [[UIImageView alloc] init];
    headViewbgimg.frame = self.headView.frame;
    [self.headView addSubview:headViewbgimg];
    self.headviewImg = headViewbgimg;

    //右边的小箭头
    UIImageView *rightView = [[UIImageView alloc]init];
    rightView.frame = CGRectMake(widthScreen - 16 - 10, 30, 10, 14);
    rightView.image = [UIImage imageNamed:@"bgq_person_right"];

    
    [self.headView addSubview:rightView];
    
    //头像
    UIImageView *userHeadImageView= [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, 12.5/667.0*heightScreen, 100/2, 100/2)];
    userHeadImageView.layer.cornerRadius = userHeadImageView.frame.size.width/2.0;//设置圆的半径
    userHeadImageView.layer.masksToBounds = YES;

    [self.headView addSubview: userHeadImageView];

    
    //用户名
    //得到用户名
    NSString *nameStr = self.headViewModel.userName;
    //得到用户名字框的size
    CGSize size1 = [nameStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    //设置用户名的框
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userHeadImageView.frame.origin.x + userHeadImageView.frame.size.width +YY10WidthMargin, YY15HeightMargin, size1.width, 15)];
    userNameLabel.font = [UIFont systemFontOfSize:15];
    
    userNameLabel.shadowColor = [UIColor colorWithWhite:0.1f alpha:0.8f];    //设置文本的阴影色彩和透明度。
    userNameLabel.shadowOffset = CGSizeMake(1.75f, 1.01f);     //设置阴影的倾斜角度。
    userNameLabel.textColor = [UIColor whiteColor];
    [self.headView addSubview:userNameLabel];
    
    

    //得到label的内容 圈友和粉丝数
    NSString *labelStr = [NSString stringWithFormat:@"圈友   %ld            关注   %ld",(long)self.headViewModel.circleFriendNumber,(long)self.headViewModel.attationNumber];
    CGSize size2 = [labelStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
      //设置label
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size2.width, 25)];
    numberLabel.textColor = [UIColor whiteColor];
    
    numberLabel.shadowColor = [UIColor colorWithWhite:0.1f alpha:0.8f];    //设置文本的阴影色彩和透明度。
    numberLabel.shadowOffset = CGSizeMake(1.75f, 1.01f);     //设置阴影的倾斜角度。
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.font = [UIFont systemFontOfSize:14];
    numberLabel.frame = CGRectMake(userNameLabel.frame.origin.x, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + YY10HeightMargin, size2.width, 25);
    [self.headView addSubview:numberLabel];
    //白竖线
    UIView *shuWhiteView = [[UIView alloc] initWithFrame:CGRectMake(numberLabel.frame.size.width/2.0, 0, 1, 25)];
    //shuWhiteView.center = headViewDownView.center;
    shuWhiteView.backgroundColor = [UIColor whiteColor];
    [numberLabel addSubview:shuWhiteView];
    
    
    
    //赋值
    YYAccount *account = [YYAccountTool account];
    NSURL *url = [NSURL URLWithString:account.userBackgroundUrlStr];
    [headViewbgimg sd_setImageWithURL:url placeholderImage:account.userBackgroundImage];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    [userHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.headViewModel.personHeadPic] placeholderImage:[UIImage imageNamed:@"bgq_person_headImage"]];
    self.headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.headViewModel.personBGI]];
    userNameLabel.text = self.headViewModel.userName;
    numberLabel.text = labelStr;
    
    
    //点击头部视图跳转到我的个人主页
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = self.headView.frame;
    clearBtn.backgroundColor = [UIColor clearColor];
    [clearBtn addTarget:self action:@selector(clickToPerson:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:clearBtn];
    
    
    
    self.tableView.tableHeaderView = self.headView;
    
    
}

#pragma mark ----- 点击了头像 跳转到person

- (void)clickToPerson:(UIButton *)sender{
    YYCirclePersonViewController *cPMVC = [[YYCirclePersonViewController alloc]init];
    [self.navigationController pushViewController:cPMVC animated:YES];
}


- (void)clickPoint:(id)sender{
    YYLog(@"YYCirclePersonViewController.h    ...");
}


#pragma mark ----- TableView的delegate和datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.modelsMutableArray.count;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YYDynamicMessageCell *cell = [YYDynamicMessageCell dynamicMessageCellWithTableView:tableView];
    cell.delegate = self;
    cell.model = self.modelsMutableArray[indexPath.section];
    self.rowHeight = cell.rowheight;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return YY10HeightMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.rowHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYDynamicMessageModel *model = self.modelsMutableArray[indexPath.section];
    model.attention = @"1";
    YYCDetailViewController *newCDVC = [[YYCDetailViewController alloc]initWithModel:model withGoToPerson:@"2" withWhere:@"2"];
    [self.navigationController pushViewController:newCDVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (YYCirclePersonHeadViewModel *)headViewModel{
    if (!_headViewModel) {
        _headViewModel = [[YYCirclePersonHeadViewModel alloc]init];
    }
    return _headViewModel;
}

- (void)setupHeadViewData{
    YYAccount *account = [YYAccountTool account];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=20&buid=%@",account.userUID];
    YYLog(@"urlStr-----%@",urlStr);
    // NSURL *url = [NSURL URLWithString:urlStr];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"连接服务器成功,得到的数据是%@",responseObject);
        
        NSMutableDictionary *modelDic = responseObject;
        
        NSString *strUrl1 =[NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",modelDic[@"headimg"]];
        NSString *strUrl = strUrl1;
        
        NSString *userName = modelDic[@"nickname"];
        
        NSString *focus = modelDic[@"focus"];
        
        NSString *fans = modelDic[@"fans"];
        
        
        self.headViewModel = [YYCirclePersonHeadViewModel circlePersonHeadViewModelWithPersonHeadPic:strUrl withPersonBGI:@"bgq_person_bgimage" withUserName:userName withCircleFriendNumber:focus.integerValue withAttationNumber:fans.integerValue];
        
        [self addTableViewHeadView];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"连接服务器失败，错误的原因是%@",error);
    }];
    
    
}


- (NSMutableArray *)modelsMutableArray{
    if (!_modelsMutableArray) {
        _modelsMutableArray = [[NSMutableArray alloc] init];
        
    }
    return _modelsMutableArray;
}

//获取cell的数据
- (void)getAllCell{
    [self.modelsMutableArray removeAllObjects];
    YYAccount *account = [YYAccountTool account];
    NSString *urlSquare = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=201&buid=%@",account.userUID];
    YYLog(@"%@",urlSquare);
    [self.manager GET:urlSquare parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"连接服务器成功,返回的数据是：%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"])
        {
            for (int i = 0; i < [responseObject allKeys].count - 1; i++)
            {
                YYLog(@"%@",responseObject);
                YYLog(@"%lu",[responseObject allKeys].count - 1);
                NSString *key = [NSString stringWithFormat:@"%d",i];
                NSDictionary *modelDic = responseObject[key];
                //                YYLog(@"%@\n%d",modelDic,i);
                YYLog(@"%@",modelDic);
                //http://www.sxeto.com/fruitApp/8344C3E4C864518DEBFF80D4C3FC73AD/headimg/head.png
                NSString *strUrl1 =[NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",modelDic[@"headimg"]];
                NSString *strUrl = strUrl1;
                NSString *timeStr = modelDic[@"time"];
                NSString *share = modelDic[@"share"];
                NSString *zan = modelDic[@"hot"];
                
                NSString *imagesArrayStr = modelDic[@"imgurllist"];
                
                NSString *bsid = modelDic[@"id"];
                NSString *comment = modelDic[@"comment"];
                
                NSString *buid = modelDic[@"buid"];
                
                NSMutableArray *imageArray = [NSMutableArray array];
                if (imagesArrayStr.length != 0)
                {
                    YYLog(@"图片qqqqqqqq%@",imagesArrayStr);
                    NSArray *array = [imagesArrayStr componentsSeparatedByString:@","];
                    for (NSString *str in array)
                    {
                        NSString *a = [@"http://www.sxeto.com/fruitApp" stringByAppendingPathComponent:str];
                        [imageArray addObject:a];
                    }
                    
                }
                YYDynamicMessageModel *model = [[YYDynamicMessageModel alloc]initWithIconUrlStr:strUrl nickName:modelDic[@"nickname"] date:[self timeWithLastTime:timeStr.longLongValue] dynamicMessage:modelDic[@"content"] imageUrlStrsArray:imageArray shareNumber:share.integerValue zanNumber:zan.integerValue attention:@"2" andBsid:bsid.intValue andCommentnumber:comment.integerValue andBuid:buid withFrom:@"1" withTime:timeStr.longLongValue withUserID:1];
                [self.modelsMutableArray addObject:model];
                
                if (i == [responseObject allKeys].count - 2) {
                    YYLog(@"排序");
                    self.modelsMutableArray = [self getCurrentarray:self.modelsMutableArray];
                    [self.tableView reloadData];
                }
                
            }
 
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"服务器连接失败，失败原因：%@",error);
    }];
    
    NSString *urlPost = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=202&buid=%@",account.userUID];
    YYLog(@"%@",urlPost);
    [self.manager GET:urlPost parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"连接服务器成功,返回的数据是：%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"])
        {
            for (int i = 0; i < [responseObject allKeys].count - 1; i++)
            {
                YYLog(@"%@",responseObject);
                YYLog(@"%lu",[responseObject allKeys].count - 1);
                NSString *key = [NSString stringWithFormat:@"%d",i];
                NSDictionary *modelDic = responseObject[key];
                //                YYLog(@"%@\n%d",modelDic,i);
                YYLog(@"%@",modelDic);
                //http://www.sxeto.com/fruitApp/8344C3E4C864518DEBFF80D4C3FC73AD/headimg/head.png
                NSString *strUrl1 =[NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",modelDic[@"headimg"]];
                NSString *strUrl = strUrl1;
                NSString *timeStr = modelDic[@"time"];
                NSString *share = modelDic[@"share"];
                NSString *zan = modelDic[@"hot"];
                
                NSString *imagesArrayStr = modelDic[@"imgurllist"];
                
                NSString *bsid = modelDic[@"id"];
                NSString *comment = modelDic[@"comment"];
                
                NSString *buid = modelDic[@"buid"];
                
                NSMutableArray *imageArray = [NSMutableArray array];
                if (imagesArrayStr.length != 0)
                {
                    YYLog(@"图片qqqqqqqq%@",imagesArrayStr);
                    NSArray *array = [imagesArrayStr componentsSeparatedByString:@","];
                    for (NSString *str in array)
                    {
                        NSString *a = [@"http://www.sxeto.com/fruitApp" stringByAppendingPathComponent:str];
                        [imageArray addObject:a];
                    }
                    
                }
                YYDynamicMessageModel *model = [[YYDynamicMessageModel alloc]initWithIconUrlStr:strUrl nickName:modelDic[@"nickname"] date:[self timeWithLastTime:timeStr.longLongValue] dynamicMessage:modelDic[@"content"] imageUrlStrsArray:imageArray shareNumber:share.integerValue zanNumber:zan.integerValue attention:@"2" andBsid:bsid.intValue andCommentnumber:comment.integerValue andBuid:buid withFrom:@"2" withTime:timeStr.longLongValue withUserID:1];
                
                
                
                [self.modelsMutableArray addObject:model];
                if (i == [responseObject allKeys].count - 2) {
                    YYLog(@"b");
                    self.modelsMutableArray = [self getCurrentarray:self.modelsMutableArray];
                    [self.tableView reloadData];
                }
            }
            
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"服务器连接失败，失败原因：%@",error);
    }];
    
    
}

- (NSMutableArray *)getCurrentarray:(NSMutableArray *)array{
    YYDynamicMessageModel *a = nil;
    YYDynamicMessageModel *b = nil;
    for (int i = 0; i < array.count; i++) {
        for (int j = i + 1; j <array.count ; j++) {
            a = array[i];
            b = array[j];
            
            if (a.time < b.time) {
                [array replaceObjectAtIndex:i withObject:b];
                [array replaceObjectAtIndex:j withObject:a];
                
            }
        }
    }
    return array;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAllCell];
}
#pragma mark ----- 图片放大功能

- (void)enlargePicture:(NSInteger)tag{
    UIImageView *imageView = [self.view viewWithTag:tag];
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 0, widthScreen, heightScreen);
    [Btn addTarget:self action:@selector(clickBigPic:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *bigImage = [[UIImageView alloc]initWithFrame:Btn.frame];
    bigImage.image = imageView.image;
    bigImage.contentMode = UIViewContentModeScaleAspectFit;
    bigImage.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:Btn];
    [Btn addSubview:bigImage];
}

- (void)clickBigPic:(UIButton *)sender{
    [sender removeFromSuperview];
}







@end
