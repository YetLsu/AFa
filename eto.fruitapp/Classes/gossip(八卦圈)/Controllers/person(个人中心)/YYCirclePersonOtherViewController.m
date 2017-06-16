//
//  YYCirclePersonOtherViewController.m
//  圈子_V1
//
//  Created by Apple on 15/12/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCirclePersonOtherViewController.h"
#import "YYCirclePersonTableViewCell.h"
#import "YYPersonCellModel.h"
#import "YYCirclePersonHeadViewModel.h"
#import "YYFruitTool.h"
#import "YYAccountTool.h"
//1月8日
#import "YYDynamicMessageCell.h"
#import "YYDynamicMessageModel.h"

#import "YYCDetailViewController.h"

#define YY16WidthMargin 16/375.0*widthScreen
#define YY10HeightMargin 10/667.0*heightScreen
#define YY10WidthMargin 10/375.0*widthScreen
#define YY15HeightMargin 15/667.0*heightScreen
#define widthScreen [UIScreen mainScreen].bounds.size.width //屏幕宽
#define heightScreen [UIScreen mainScreen].bounds.size.height //屏幕高

@interface YYCirclePersonOtherViewController () <UITableViewDataSource,UITableViewDelegate,YYDynamicMessageCellDelegate>

@property (nonatomic,strong) NSMutableArray *modelsMutableArray;//内容的假数据
@property (nonatomic,strong) YYCirclePersonHeadViewModel *headViewModel;//头部视图假数据

@property (nonatomic,strong) UITableView *tableView;//列表
@property (nonatomic,strong) UIView *downView;//下方的视图
@property (nonatomic,strong) UIView *headView;//头部视图
@property (nonatomic,assign) CGFloat rowHeight;//单元格高度
@property (nonatomic,weak) UILabel *downRightLabel;//关注的框


@property (nonatomic,weak) UIView *brownLine;//棕色下划线

@property (nonatomic,strong) NSString *headViewBuid;//获取头部视图信息时需要的元素

@property (nonatomic,strong) NSString *attention;//是否关注

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic,strong) NSString *whereToHere;//从哪个圈友到这里的 1为我的，2为其他




@end

@implementation YYCirclePersonOtherViewController

- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (instancetype)initWithBuid:(NSString *)buid withAtt:(NSString *)attention withWhere:(NSString *)whereToHere{
    if (self = [super init]) {
        self.headViewBuid = buid;
        self.attention = attention;
        self.whereToHere = whereToHere;
    }
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        if ([self.whereToHere isEqualToString:@"1"]) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen - 40 - 64) style:UITableViewStyleGrouped];
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen - 40 ) style:UITableViewStyleGrouped];
        }
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    self.title = @"个人主页";
    [super viewDidLoad];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bgq_person_more"] style:0 target:self action:@selector(clickPoint:)];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //[self addTableViewHeadView];
    [self addDownView];
    [self setupHeadViewData];
    YYLog(@"%f",self.tableView.frame.size.height);
}


#pragma mark ----- 添加头部视图，并赋值
- (void)addTableViewHeadView{
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 470/2)];
    
    UIImageView *backgroungView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 390/2)];
    
    [self.headView addSubview:backgroungView];
    
    
    //头像
    UIImageView *userHeadImageView= [[UIImageView alloc] initWithFrame:CGRectMake(widthScreen/2.0 - 134/2/2.0, 32/667.0*heightScreen, 134/2, 134/2)];
    userHeadImageView.layer.cornerRadius = userHeadImageView.frame.size.width/2.0;//设置圆的半径
    userHeadImageView.layer.masksToBounds = YES;
    
    
    [backgroungView addSubview: userHeadImageView];
    //用户名
    //得到用户名
    NSString *nameStr = self.headViewModel.userName;
    //得到用户名字框的size
    CGSize size1 = [nameStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    //设置用户名的框
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen/2.0 - size1.width/2.0, userHeadImageView.frame.origin.y + userHeadImageView.frame.size.height + YY10WidthMargin , size1.width, 15)];
    userNameLabel.font = [UIFont systemFontOfSize:15];
    
    userNameLabel.shadowColor = [UIColor colorWithWhite:0.1f alpha:0.8f];    //设置文本的阴影色彩和透明度。
    userNameLabel.shadowOffset = CGSizeMake(1.75f, 1.01f);     //设置阴影的倾斜角度。
    userNameLabel.textColor = [UIColor whiteColor];
    //userNameLabel.textColor = [UIColor ];
    [backgroungView addSubview:userNameLabel];
    
    
    
    //设置下面黑灰色的视图
    UIView *headViewDownView = [[UIView alloc] initWithFrame:CGRectMake(0, userNameLabel.frame.origin.y + userNameLabel.frame.size.height + YY10HeightMargin , widthScreen, 40)];
    //headViewDownView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    //设置里面的label
    //得到label的内容
    NSString *labelStr = [NSString stringWithFormat:@"圈友   %ld            关注   %ld",(long)self.headViewModel.circleFriendNumber,(long)self.headViewModel.attationNumber];
    CGSize size2 = [labelStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size2.width, 25)];
    numberLabel.textColor = [UIColor whiteColor];
    
    numberLabel.shadowColor = [UIColor colorWithWhite:0.1f alpha:0.8f];    //设置文本的阴影色彩和透明度。
    numberLabel.shadowOffset = CGSizeMake(1.75f, 1.01f);     //设置阴影的倾斜角度。
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.font = [UIFont systemFontOfSize:14];
    numberLabel.frame = CGRectMake(widthScreen/2.0 - size2.width/2, headViewDownView.frame.size.height/2.0 - numberLabel.frame.size.height/2.0, size2.width, 25);
    [headViewDownView addSubview:numberLabel];
    //白竖线
    UIView *shuWhiteView = [[UIView alloc] initWithFrame:CGRectMake(numberLabel.frame.size.width/2.0, 0, 1, 25)];
    //shuWhiteView.center = headViewDownView.center;
    shuWhiteView.backgroundColor = [UIColor whiteColor];
    [numberLabel addSubview:shuWhiteView];
    
    [backgroungView addSubview:headViewDownView];
    
    //他的动态的按钮
    UIButton *dynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    dynamicBtn.frame = CGRectMake(widthScreen/2.0 - 156/2.0/2, backgroungView.frame.size.height, 156/2.0, self.headView.frame.size.height - backgroungView.frame.size.height);
    [dynamicBtn setTitle:@"他的动态" forState:UIControlStateNormal];
    [dynamicBtn setTitleColor:[UIColor colorWithRed:177/255.0 green:146/255.0 blue:28/255.0 alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:dynamicBtn];
    
    //下划线
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(dynamicBtn.frame.origin.x, dynamicBtn.frame.origin.y+dynamicBtn.frame.size.height - 1, dynamicBtn.frame.size.width, 1)];
    downView.backgroundColor = [UIColor colorWithRed:177/255.0 green:146/255.0 blue:28/255.0 alpha:1];
    [self.headView addSubview: downView];
    self.brownLine = downView;
    //self.brownLine.backgroundColor = [UIColor blueColor];
    
    //赋值
    self.headView.backgroundColor = [UIColor whiteColor];
    [userHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.headViewModel.personHeadPic] placeholderImage:[UIImage imageNamed:@"bgq_person_headImage"]];
    NSURL *url = [NSURL URLWithString:self.headViewModel.personBGI];
    [backgroungView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"bgq_person_bgimage"]];
    userNameLabel.text = self.headViewModel.userName;
    numberLabel.text = labelStr;
    
    self.tableView.tableHeaderView = self.headView;
    
    
}


- (void)addDownView{
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, widthScreen, 40)];
    [self.view addSubview:self.downView];
    //测试
    //self.downView.backgroundColor = [UIColor blueColor];
    //第一个view
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(widthScreen/2.0/2.0 - 150/2.0/2.0, self.downView.frame.size.height/2.0 - 15/2.0, 75, 15)];
    UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 41/2.0, 15)];
    firstImageView.image = [UIImage imageNamed:@"bgq_person_sendMessage"];
    [firstView addSubview:firstImageView];
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstImageView.frame.size.width, 0, firstView.frame.size.width - firstImageView.frame.size.width, firstView.frame.size.height)];
    firstLabel.textAlignment = 1;
    firstLabel.text = @"发私信";
    firstLabel.textColor = [UIColor colorWithRed:236/255.0 green:195/255.0 blue:47/255.0 alpha:1];
    firstLabel.font = [UIFont systemFontOfSize:15];
    [firstView addSubview:firstLabel];
    [self.downView addSubview:firstView];
    //测试
    //firstView.backgroundColor = [UIColor blueColor];
    //第二个view
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(widthScreen/2.0/2.0 - 150/2.0/2.0 + widthScreen/2.0, self.downView.frame.size.height/2.0 - 15/2.0, 75, 15)];
    //测试
    //secondView.backgroundColor = [UIColor greenColor];
    UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25/2.0, 15)];
    secondImageView.image = [UIImage imageNamed:@"bgq_person_attentionImage"];
    [secondView addSubview:secondImageView];
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondImageView.frame.size.width, 0, secondView.frame.size.width - secondImageView.frame.size.width, secondView.frame.size.height)];
    secondLabel.textAlignment = 1;
    if ([self.attention isEqualToString:@"0"]) {
        secondLabel.text = @"加关注";
    }else if ([self.attention isEqualToString:@"1"]){
        secondLabel.text = @"已关注";
    }
    
    secondLabel.textColor = [UIColor colorWithRed:236/255.0 green:195/255.0 blue:47/255.0 alpha:1];
    secondLabel.font = [UIFont systemFontOfSize:15];
    [secondView addSubview:secondLabel];
    self.downRightLabel = secondLabel;
    
    
    [self.downView addSubview:secondView];
    //加线
    YYFruitTool *tool = [YYFruitTool new];
    [tool addLineViewWithFrame:CGRectMake(0, 0, widthScreen, 0.5) andView:self.downView];
    
    [tool addLineViewWithFrame:CGRectMake(widthScreen/2.0, 0, 0.5, self.downView.frame.size.height) andView:self.downView];
    
    //添加按钮
    UIButton *sendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMessage.frame = CGRectMake(0, 0, widthScreen/2.0, self.downView.frame.size.height);
    sendMessage.backgroundColor = [UIColor clearColor];
    [sendMessage addTarget:self action:@selector(clickSendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.downView addSubview:sendMessage];
    
    UIButton *attention = [UIButton buttonWithType:UIButtonTypeCustom];
    attention.frame = CGRectMake(widthScreen/2.0, 0, widthScreen/2.0, self.downView.frame.size.height);
    attention.backgroundColor = [UIColor clearColor];
    [attention addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
    [self.downView addSubview:attention];
    
    self.downView.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)clickPoint:(id)sender{
    YYLog(@"YYCirclePersonViewController.h    ...");
}
- (void)clickSendMessage:(UIButton *)sender{
    YYLog(@"YYCirclePersonViewController.h    发私信");
}
#pragma mark ----- 点击关注后的事件
- (void)clickAttention:(UIButton *)sender{
    YYAccount *account = [YYAccountTool account];
    NSString *urlStr = nil;
    if ([self.attention isEqualToString:@"0"]) {
        urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=24&buid=%@&bfuid=%@&flag=1",account.userUID,self.headViewBuid];
        [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            YYLog(@"连接成功,返回的消息是%@",responseObject[@"msg"]);
            if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
                self.attention = @"1";
                self.downRightLabel.text = @"已关注";
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            YYLog(@"连接不成功，错误原因是：%@",error);
        }];
        
    }else if ([self.attention isEqualToString:@"1"]){
        urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=24&buid=%@&bfuid=%@&flag=0",account.userUID,self.headViewBuid];
        [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            YYLog(@"连接成功,返回的消息是%@",responseObject[@"msg"]);
            if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
                self.attention = @"0";
                self.downRightLabel.text = @"未关注";
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            YYLog(@"连接不成功，错误原因是：%@",error);
        }];
    }
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
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return YY10HeightMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return self.rowHeight;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYDynamicMessageModel *model = self.modelsMutableArray[indexPath.section];
    YYCDetailViewController *newCDVC = nil;
    if ([self.whereToHere isEqualToString:@"1"]) {
        newCDVC = [[YYCDetailViewController alloc]initWithModel:model withGoToPerson:@"2" withWhere:@"1"];
    }else{
        newCDVC = [[YYCDetailViewController alloc]initWithModel:model withGoToPerson:@"2" withWhere:@"2"];
    }
    model.attention = self.attention;
    
    [self.navigationController pushViewController:newCDVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (YYCirclePersonHeadViewModel *)headViewModel{
    if (!_headViewModel) {
        _headViewModel = [[YYCirclePersonHeadViewModel alloc]init];
  
    }
    return _headViewModel;
}



- (NSMutableArray *)modelsMutableArray{
    if (!_modelsMutableArray) {
        _modelsMutableArray = [[NSMutableArray alloc] init];
    }
    return _modelsMutableArray;
}

- (void)setupHeadViewData{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=20&buid=%@",self.headViewBuid];
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
        NSString *bgimg = nil;
        if ([modelDic[@"bgimg"] isEqualToString:@""]) {
            
        }else{
            bgimg = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",modelDic[@"bgimg"]];
        }
        
        
        
        self.headViewModel = [YYCirclePersonHeadViewModel circlePersonHeadViewModelWithPersonHeadPic:strUrl withPersonBGI:bgimg withUserName:userName withCircleFriendNumber:focus.integerValue withAttationNumber:fans.integerValue];
        
        [self addTableViewHeadView];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"连接服务器失败，错误的原因是%@",error);
    }];
    
    
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

- (void)getAllCell{
    [self.modelsMutableArray removeAllObjects];
    NSString *urlSquare = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=200&buid=%@",self.headViewBuid];
    
    
    [self.manager GET:urlSquare parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"连接服务器成功,返回的数据是：%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSString *nickname = responseObject[@"user"][@"nickname"];
            NSString *strUrl1 =[NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",responseObject[@"user"][@"headimg"]];
            NSString *strUrl = strUrl1;
            
            NSArray *postArray = responseObject[@"post"];
            
            for (int i = 0; i < postArray.count; i++) {
                NSDictionary *modelDic = postArray[i];
                YYLog(@"%@",modelDic);
                
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
                YYDynamicMessageModel *model = [[YYDynamicMessageModel alloc]initWithIconUrlStr:strUrl nickName:nickname date:[self timeWithLastTime:timeStr.longLongValue] dynamicMessage:modelDic[@"content"] imageUrlStrsArray:imageArray shareNumber:share.integerValue zanNumber:zan.integerValue attention:@"2" andBsid:bsid.intValue andCommentnumber:comment.integerValue andBuid:buid withFrom:@"2" withTime:timeStr.longLongValue withUserID:1];
                [self.modelsMutableArray addObject:model];
                
                if (i == postArray.count - 1) {
                    YYLog(@"排序1");
                    self.modelsMutableArray = [self getCurrentarray:self.modelsMutableArray];
                    [self.tableView reloadData];
                }
            }
            
            NSArray *squareArray = responseObject[@"square"];
            for (int i = 0; i < squareArray.count; i++) {
                NSDictionary *modelDic = squareArray[i];
                YYLog(@"%@",modelDic);
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
                YYDynamicMessageModel *model = [[YYDynamicMessageModel alloc]initWithIconUrlStr:strUrl nickName:nickname date:[self timeWithLastTime:timeStr.longLongValue] dynamicMessage:modelDic[@"content"] imageUrlStrsArray:imageArray shareNumber:share.integerValue zanNumber:zan.integerValue attention:@"2" andBsid:bsid.intValue andCommentnumber:comment.integerValue andBuid:buid withFrom:@"1" withTime:timeStr.longLongValue withUserID:1];
                [self.modelsMutableArray addObject:model];
                if (i == squareArray.count - 1) {
                    YYLog(@"排序2");
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
