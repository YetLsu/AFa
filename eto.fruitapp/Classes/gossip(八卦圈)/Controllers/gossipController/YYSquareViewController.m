//
//  YYSquareViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/20.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSquareViewController.h"
#import "YYDynamicMessageCell.h"
#import "YYDynamicMessageModel.h"

#import "YYAccountTool.h"
#import "MJRefresh.h"

@interface YYSquareViewController ()<UITableViewDataSource, UITableViewDelegate, YYDynamicMessageCellDelegate, UITextFieldDelegate>

#pragma mark 模型数组
@property (nonatomic, strong)NSMutableArray *squareArrays;//广场模型数组

@property (nonatomic, assign) CGFloat rowheight;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) UITextField *commentField;

@property (nonatomic, strong) UIButton *coverBtn;

@property (nonatomic, strong) YYDynamicMessageModel *commentModel;

@property (nonatomic, weak) UIRefreshControl *control;

@property (nonatomic,copy) NSString *attation;

@property (nonatomic,strong) NSArray *reflashImg;//刷新图片的数组
@end

@implementation YYSquareViewController
//- (UIButton *)coverBtn{
//    if (!_coverBtn) {
//        _coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen)];
//        _coverBtn.backgroundColor = [UIColor clearColor];
//        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    return _coverBtn;
//}

//- (UITextField *)commentField{
//    if (!_commentField) {
//        _commentField = [[UITextField alloc] initWithFrame:CGRectMake(0, heightScreen - 40, widthScreen, 40)];
//        _commentField.backgroundColor = YYOrangeColor;
//        _commentField.returnKeyType = UIReturnKeySend;
//        _commentField.delegate = self;
//    }
//    return _commentField;
//}
/**
 *  遮盖被点击隐藏显示框
 */
//- (void)coverBtnClick{
//    [self.coverBtn removeFromSuperview];
//    self.commentField.y = heightScreen;
//    [self.commentField resignFirstResponder];
//}

- (NSArray *)reflashImg{
    if (!_reflashImg) {
        UIImage *img1 = [UIImage imageNamed:@"bgq_square_reflash_1"];
        UIImage *img2 = [UIImage imageNamed:@"bgq_square_reflash_2"];
        _reflashImg = @[img1,img2];
    }
    return _reflashImg;
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

- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];

    }
    return _manager;
}
- (NSMutableArray *)squareArrays{
    if (!_squareArrays) {
        _squareArrays = [NSMutableArray array];

    }
    return _squareArrays;
}
- (instancetype)init{
    if (self = [super init]) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen - 64 - 49) style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        tableView.backgroundColor = YYViewBGColor;
        tableView.delegate = self;
        tableView.dataSource = self;
        self.squareTableView = tableView;
//        [self getSquareArrays];

//        UIRefreshControl *control = [[UIRefreshControl alloc] init];
//        [self.squareTableView addSubview:control];
//        self.control = control;
//        [control addTarget:self action:@selector(refreshControlTableView) forControlEvents:UIControlEventValueChanged];
        
        
#pragma mark ----- MJRefresh
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshControlTableView)];
        // 设置普通状态的动画图片
        [header setImages:self.reflashImg forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [header setImages:self.reflashImg forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [header setImages:self.reflashImg forState:MJRefreshStateRefreshing];
        // 设置header
        self.squareTableView.mj_header = header;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        // 隐藏状态
        header.stateLabel.hidden = YES;
        
        
        [self refreshControlTableView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshControlTableView) name:@"writeSomething" object:nil];
    }
    return self;
}
- (void)refreshControlTableView{
    
    YYAccount *account = [YYAccountTool account];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=21&category=-1&buid=%@",account.userUID];
    YYLog(@"%@",urlStr);
    
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        YYLog(@"%@",responseObject);
        //        YYLog(@"请求发送功%@",responseObject);
#pragma mark ----- 状态
        
        NSMutableArray *attMutableArray = [[NSMutableArray alloc]init];
        
        NSString *attStr = responseObject[@"flaglist"];
        NSInteger count0 = attStr.length;//字符串长度
        int count = count0;
        
        for (int i = 0; i < count; i++) {
            [attMutableArray addObject:[attStr substringWithRange:NSMakeRange(i, 1)]];
        }
        YYLog(@"%@",attMutableArray);//按照给定的NSRang字符串截取自串的宽度和位
        
                YYLog(@"okkk%@",responseObject[@"msg"]);
        YYLog(@"%@",responseObject[@"flaglist"]);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [self.squareArrays removeAllObjects];
            
            for (int i = 0; i < responseObject.allKeys.count - 2; i++) {
                YYLog(@"%@",responseObject);
                YYLog(@"%lu",responseObject.allKeys.count - 2);
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
                if (imagesArrayStr.length != 0) {
                    YYLog(@"图片qqqqqqqq%@",imagesArrayStr);
                    NSArray *array = [imagesArrayStr componentsSeparatedByString:@","];
                    for (NSString *str in array) {
                        NSString *a = [@"http://www.sxeto.com/fruitApp" stringByAppendingPathComponent:str];
                        [imageArray addObject:a];
                    }
                    
                }
                NSString *tempTag = modelDic[@"user_id"];
                NSInteger attentionTag = tempTag.integerValue ;
                
                YYDynamicMessageModel *model = [[YYDynamicMessageModel alloc]initWithIconUrlStr:strUrl nickName:modelDic[@"nickname"] date:[self timeWithLastTime:timeStr.longLongValue] dynamicMessage:modelDic[@"content"] imageUrlStrsArray:imageArray shareNumber:share.integerValue zanNumber:zan.integerValue attention:attMutableArray[i] andBsid:bsid.intValue andCommentnumber:comment.integerValue andBuid:buid withFrom:@"1" withTime:timeStr.longLongValue withUserID:attentionTag];
                
                [self.squareArrays addObject:model];
               // YYLog(@"%d",self.squareArrays.count);
                //                YYLog(@"%lu",(unsigned long)model.imageUrlStrsArray.count);
                [self.squareTableView reloadData];
            }
        }
        [self.squareTableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"请求发送失败%@",error);
        [self.squareTableView.mj_header endRefreshing];
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark tableview的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.squareArrays.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYDynamicMessageCell *cell = [YYDynamicMessageCell dynamicMessageCellWithTableView:tableView];
    
    YYDynamicMessageModel *model = self.squareArrays[indexPath.section];
    cell.model = model;
    
    self.rowheight = cell.rowheight;
    
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

//#pragma mark  单元格下方按钮被点击代理方法
//- (void)commentBtnToControllerClickWithModel:(YYDynamicMessageModel *)model{
//    YYAccount *account = [YYAccountTool account];
//    self.commentModel = model;
//    if (!account.userUID) {
//        YYLog(@"去登录");
//    }
//#warning 警告
//    [self.squareTableView.window addSubview:self.coverBtn];
//    
//    [self.squareTableView.window addSubview:self.commentField];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    
//     [self.commentField becomeFirstResponder];
//}
//弹出键盘
- (void)keyBoardWillShow:(NSNotification *)noti{
    
    NSDictionary *userinfo = [noti userInfo];
    
    NSValue *frameValue = [userinfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = frameValue.CGRectValue;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.commentField.y = keyboardFrame.origin.y - 40;
    }];

    YYLog(@"键盘%@",noti);
}

#pragma mark ----- 点关注的方法

- (void)attationBtnGuanZhuWith:(NSString *)attation bfuid:(NSString *)bfuid{
    YYAccount *account = [YYAccountTool account];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=24&buid=%@&bfuid=%@&flag=1",account.userUID,bfuid];
    YYLog(@"%@",urlStr);
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"%@",responseObject);
        YYLog(@"关注成功");
        [self refreshControlTableView];

        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"关注失败");
    }];
    
    
}

#pragma mark ----- 取消关注的方法

- (void)attationBtnQuGuanWith:(NSString *)attation bfuid:(NSString *)bfuid{
    YYAccount *account = [YYAccountTool account];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=24&buid=%@&bfuid=%@&flag=0",account.userUID,bfuid];
    YYLog(@"%@",urlStr);
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"%@",responseObject);
        YYLog(@"关注成功");

        [self refreshControlTableView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"关注失败");
    }];
    
}

#pragma mark ----- 图片放大
- (void)enlargePicture:(NSInteger)tag{
    
    [self.delegate enlargeSquarePic:tag];
    
    UIImageView *imageView = [self.view viewWithTag:tag];
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 0, widthScreen, heightScreen);
    Btn.backgroundColor = [UIColor clearColor];
    [Btn addTarget:self action:@selector(clickBigPic:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *bigImage = [[UIImageView alloc]initWithFrame:Btn.frame];
    bigImage.image = imageView.image;
    bigImage.contentMode = UIViewContentModeScaleAspectFit;
    bigImage.backgroundColor = [UIColor greenColor];
    [self.view addSubview:Btn];
    [Btn addSubview:bigImage];
    
}

- (void)clickBigPic:(UIButton *)sender{
    [sender removeFromSuperview];
}


#pragma mark tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowheight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYDynamicMessageModel *model = self.squareArrays[indexPath.section];
    
    if ([self.delegate respondsToSelector:@selector(dynamicMessageClickWithModel:)]) {
        [self.delegate dynamicMessageClickWithModel:model];
    }
    
}
@end
