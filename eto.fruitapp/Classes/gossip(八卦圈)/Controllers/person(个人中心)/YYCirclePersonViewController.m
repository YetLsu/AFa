//
//  YYCirclePersonViewController.m
//  圈子_V1
//
//  Created by Apple on 15/12/18.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCirclePersonViewController.h"
#import "YYCirclePersonTableViewCell.h"
#import "YYPersonCellModel.h"
#import "YYCirclePersonHeadViewModel.h"
#import "YYFruitTool.h"
#import "YYAccountTool.h"
#import "UIImageView+WebCache.h"

//1月8日
#import "YYDynamicMessageModel.h"
#import "YYDynamicMessageCell.h"

#import "YYCDetailViewController.h"


#define YY16WidthMargin 16/375.0*widthScreen
#define YY10HeightMargin 10/667.0*heightScreen
#define YY10WidthMargin 10/375.0*widthScreen
#define YY15HeightMargin 15/667.0*heightScreen
#define widthScreen [UIScreen mainScreen].bounds.size.width //屏幕宽
#define heightScreen [UIScreen mainScreen].bounds.size.height //屏幕高

@interface YYCirclePersonViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,YYDynamicMessageCellDelegate>
@property (nonatomic,strong) NSMutableArray *modelsMutableArray;//内容的假数据
@property (nonatomic,strong) YYCirclePersonHeadViewModel *headViewModel;//头部视图假数据


@property (nonatomic,strong) UITableView *tableView;//列表
@property (nonatomic,strong) UIImageView *headViewBgimg;//头部的背景图
//@property (nonatomic,strong) UIView *downView;//下方的视图
@property (nonatomic,strong) UIView *headView;//头部视图
@property (nonatomic,assign) CGFloat rowHeight;//单元格高度


@property (nonatomic,weak) UIButton *dynamicBtn;//动态按钮
@property (nonatomic,weak) UIButton *collectBtn;//收藏按钮
@property (nonatomic,weak) UIView *brownLine;//棕色下划线

@property (nonatomic,strong) NSString *leftOrRight;//左边或者右边的按钮 eg:1是动态 2是收藏

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end

@implementation YYCirclePersonViewController

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
    self.title = @"个人主页";
    self.leftOrRight = @"1";
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bgq_person_more"] style:0 target:self action:@selector(clickPoint:)];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //self.dynamicBtn.selected = YES;
    [self setupHeadViewData];
    // Do any additional setup after loading the view.
}

- (void)addTableViewHeadView{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 470/2)];
    
    UIImageView *backgroungView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 390/2)];
    backgroungView.image = [UIImage imageNamed:self.headViewModel.personBGI];
    YYAccount *account = [YYAccountTool account];
    NSURL *url = [NSURL URLWithString:account.userBackgroundUrlStr];
    [backgroungView sd_setImageWithURL:url placeholderImage:account.userBackgroundImage];
    [self.headView addSubview:backgroungView];
    self.headViewBgimg = backgroungView;
    
    UIButton *setBackgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBackgroundBtn.frame = self.headView.bounds;
    [setBackgroundBtn addTarget:self action:@selector(setBackgroundHeadView) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:setBackgroundBtn];
    

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
    
    //动态的按钮
    UIButton *dynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    dynamicBtn.frame = CGRectMake(widthScreen/2 - (104/375.0*widthScreen)/2, backgroungView.frame.size.height, 104/375.0*widthScreen, self.headView.frame.size.height - backgroungView.frame.size.height);
    [dynamicBtn setTitle:@"我的动态" forState:UIControlStateNormal];
    [dynamicBtn setTitleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1] forState:UIControlStateNormal];
    [dynamicBtn setTitle:@"我的动态" forState:UIControlStateSelected];
    [dynamicBtn setTitleColor:[UIColor colorWithRed:177/255.0 green:146/255.0 blue:28/255.0 alpha:1] forState:UIControlStateSelected];
    
    
    [self.headView addSubview:dynamicBtn];
    [dynamicBtn addTarget:self action:@selector(clickdynamic:) forControlEvents:UIControlEventTouchUpInside];
    self.dynamicBtn = dynamicBtn;
    self.dynamicBtn.selected = YES;
    
//    //收藏按钮
//    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    collectBtn.frame = CGRectMake(437/2.0/375.0*widthScreen, backgroungView.frame.size.height, 104/2/375.0*widthScreen, self.headView.frame.size.height - backgroungView.frame.size.height);
//    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
//    [collectBtn setTitleColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1] forState:UIControlStateNormal];
//    [collectBtn setTitle:@"收藏" forState:UIControlStateSelected];
//    [collectBtn setTitleColor:[UIColor colorWithRed:177/255.0 green:146/255.0 blue:28/255.0 alpha:1] forState:UIControlStateSelected];
//    
//    [self.headView addSubview:collectBtn];
//    [collectBtn addTarget:self action:@selector(clickcollect:) forControlEvents:UIControlEventTouchUpInside];
//    self.collectBtn = collectBtn;
    
    
    
    
    
    
    //下划线
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(self.dynamicBtn.frame.origin.x, self.dynamicBtn.frame.origin.y+self.dynamicBtn.frame.size.height - 1, self.dynamicBtn.frame.size.width, 1)];
    downView.backgroundColor = [UIColor colorWithRed:177/255.0 green:146/255.0 blue:28/255.0 alpha:1];
    [self.headView addSubview: downView];
    self.brownLine = downView;
    
    //赋值
    self.headView.backgroundColor = [UIColor whiteColor];
    [userHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.headViewModel.personHeadPic] placeholderImage:[UIImage imageNamed:@"bgq_person_headImage"]];
    
    //userHeadImageView.image = [UIImage imageNamed:self.headViewModel.personHeadPic];
    //backgroungView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.headViewModel.personBGI]];
    userNameLabel.text = self.headViewModel.userName;
    numberLabel.text = labelStr;
    
    self.tableView.tableHeaderView = self.headView;
    
}



#pragma mark ----- 点击动态

- (void)clickdynamic:(UIButton *)sender{
    self.dynamicBtn.selected = YES;
    self.collectBtn.selected = NO;
    self.leftOrRight = @"1";
    //sender.selected = !sender.selected;
    CGRect rect = self.brownLine.frame;
    rect.origin.x = self.dynamicBtn.frame.origin.x;
    self.brownLine.frame = rect;
    [self.tableView reloadData];
    
    YYLog(@"动态");
}

- (void)clickcollect:(UIButton *)sender{
    self.collectBtn.selected = YES;
    self.dynamicBtn.selected = NO;
    self.leftOrRight = @"2";
    CGRect rect = self.brownLine.frame;
    rect.origin.x = self.collectBtn.frame.origin.x;
    self.brownLine.frame = rect;
    [self.tableView reloadData];
    
    
    YYLog(@"收藏");
}



- (void)clickPoint:(id)sender{
    YYLog(@"YYCirclePersonViewController.h    ...");
}
- (void)clickSendMessage:(UIButton *)sender{
    YYLog(@"YYCirclePersonViewController.h    发私信");
}
- (void)clickAttention:(UIButton *)sender{
    YYLog(@" YYCirclePersonViewController.h    关注他");
}

#pragma mark ----- TableView的delegate和datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.leftOrRight isEqualToString:@"1"]) {
        return self.modelsMutableArray.count;
    }else{
        return 10;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.leftOrRight isEqualToString:@"1"]) {
        YYDynamicMessageCell *cell = [YYDynamicMessageCell dynamicMessageCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = self.modelsMutableArray[indexPath.section];
        self.rowHeight = cell.rowheight;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYCirclePersonViewController"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YYCirclePersonViewController"];
        }
        cell.textLabel.text = nil;
        cell.textLabel.text = [NSString stringWithFormat:@"收藏%ld",indexPath.section];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return YY10HeightMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.leftOrRight isEqualToString:@"1"]) {
        return self.rowHeight;
    }else{
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.leftOrRight isEqualToString:@"1"]) {
        YYDynamicMessageModel *model = self.modelsMutableArray[indexPath.section];
        model.attention = @"2";
        YYCDetailViewController *newCDVC = [[YYCDetailViewController alloc]initWithModel:model withGoToPerson:@"2" withWhere:@"2"];
        [self.navigationController pushViewController:newCDVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (YYCirclePersonHeadViewModel *)headViewModel{
    if (!_headViewModel) {
        _headViewModel = [YYCirclePersonHeadViewModel circlePersonHeadViewModelWithPersonHeadPic:@"bgq_person_headImage" withPersonBGI:@"bgq_person_bgimage" withUserName:@"噜啦啦，噜啦啦" withCircleFriendNumber:666 withAttationNumber:999];
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




- (NSMutableArray *)modelsMutableArray{
    if (!_modelsMutableArray) {
        _modelsMutableArray = [[NSMutableArray alloc] init];
    }
    return _modelsMutableArray;
}

- (void)getAllCell{
    [self.modelsMutableArray removeAllObjects];
    YYAccount *account = [YYAccountTool account];
    NSString *urlSquare = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer?mode=200&buid=%@",account.userUID];
    
    [self.manager GET:urlSquare parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"连接服务器成功,返回的数据是：%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSArray *postArray = responseObject[@"post"];
            NSString *nickname = responseObject[@"user"][@"nickname"];
            NSString *strUrl1 =[NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",responseObject[@"user"][@"headimg"]];
            NSString *strUrl = strUrl1;
            
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
//修改头部视图的背景图片
- (void)setBackgroundHeadView{
    YYLog(@"修改头部视图背景图片");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark actionsheet的代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    
    imagePC.delegate = self;
    imagePC.allowsEditing = YES;
    
    if (buttonIndex == 0) {//从相册选择
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            imagePC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePC animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 1){//拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePC animated:YES completion:nil];
        }
        
    }
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


#pragma mark 选中某张照片时调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    YYAccount *account = [YYAccountTool account];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    image = [UIImage imageWithData:imageData];
    
    NSString *postImageUrlStr = @"http://www.sxeto.com/fruitApp/upload.php";
    NSURL *url = [NSURL URLWithString:postImageUrlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mode"] = @"46";
    dic[@"buid"] = account.userUID;
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    dic[@"img"] = imageStr;
    
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        YYLog(@"转换json出错%@",error);
    }
    
    request.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            YYLog(@"%@发送失败",connectionError);
            return ;
        }
        
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        YYLog(@"%@",dic);
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"修改成功");
            account.userBackgroundImage = image;
            account.userBackgroundUrlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",dic[@"headimg"]];
            [YYAccountTool saveAccount:account];
            [MBProgressHUD showSuccess:@"成功修改背景图片成功"];
            self.headViewBgimg.image = image;
            [self reflashHeadViewBgimg:image];
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [MBProgressHUD showError:@"网络错误"];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
        YYLog(@"解析数据%@\n\n错误%@",dic,error);
    }];
}

#pragma mark ------ 发送一个通知来更新个人中心的背景

- (void)reflashHeadViewBgimg:(UIImage *)image{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center postNotificationName:@"ChangeBgimg" object:self userInfo:@{@"Image":image}];
    
}





@end
