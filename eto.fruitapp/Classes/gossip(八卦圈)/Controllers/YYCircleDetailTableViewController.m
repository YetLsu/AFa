//
//  YYCircleDetailTableViewController.m
//  圈子_V1
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCircleDetailTableViewController.h"
#import "YYCircleDetailContentTableViewCell.h"
#import "YYCircleWriteSomethingViewController.h"
#import "YYCirecleIntroduceModel.h"
#import "YYCircleDetailContentModel.h"
#import "YYCircleModel.h"
#import "UIImageView+WebCache.h"

#import "YYCDetailViewController.h"

#import "YYDynamicMessageModel.h"


#import "YYAccountTool.h"

#import "YYGoLoginController.h"

@interface YYCircleDetailTableViewController ()
//该圈子的模型
@property (nonatomic, strong) YYCircleModel *model;

@property (nonatomic,weak) UIView *topHeadView;
@property (nonatomic,assign) CGFloat rowHeight;

//头部视图的视图
@property (nonatomic,weak) UIImageView *leftImage;//左图名
@property (nonatomic,weak) UILabel *circleAndJoinLabel;//圈友和参与
@property (nonatomic,weak) UILabel *categoryLabel;//分类栏
@property (nonatomic,weak) UIButton *joinButton;//就加入按钮
@property (nonatomic,weak) UILabel *introduceLabel;//圈子介绍的Label
//两个按钮
@property (nonatomic,weak) UIView *switchView;//切换
@property (nonatomic, weak) UIButton *allBtn;
@property (nonatomic, weak) UIButton *essenceBtn;//精华


//model
@property (nonatomic,strong) YYCirecleIntroduceModel *topModel;
@property (nonatomic,strong) NSMutableArray *cellModelArrays;//从服务器获取的用于页面显示的
@property (nonatomic,copy) NSMutableArray *infomationArrays;//接受返回的信息，用来传给下一个页面的

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong) YYAccount *account;//账户


@end

@implementation YYCircleDetailTableViewController

- (NSMutableArray *)infomationArrays{
    if (!_infomationArrays) {
        _infomationArrays = [[NSMutableArray alloc] init];
        
    }
    return _infomationArrays;
}

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

- (instancetype)initWithCircleModel:(YYCircleModel *)model{
    if (self = [super init]) {
        self.model = model;
        self.title = [NSString stringWithFormat:@"#%@#",model.prefixTitle] ;
    }
    return self;
}
- (YYCirecleIntroduceModel *)topModel{
    if (!_topModel) {
        //[UIImage imageNamed:@"bgq_circle_headImage"]
        _topModel = [YYCirecleIntroduceModel CirecleIntroduceModelWithLeftImageString:@"bgq_circle_headImage" withCirclefriend:self.model.joinNumber withJoinNumber:self.model.readNumber withCategory:self.model.categoryC withCircleIntroduce:self.model.content];
    }
    return _topModel;
}

- (NSMutableArray *)cellModelArrays{
    if (!_cellModelArrays) {
        _cellModelArrays = [[NSMutableArray alloc] init];
//        YYCircleDetailContentModel *model1 = [YYCircleDetailContentModel CircleDetailContentModelWithTieID:1 withTitle:@"那年我才18岁，ta也18岁，在那月黑风高的夜晚...阳光出奇的好，哈哈" withUserName:@"那一夜" withTime:@"10小时前" withZanNumber:77 withCommentNumber:666];
//        YYCircleDetailContentModel *model2 = [YYCircleDetailContentModel CircleDetailContentModelWithTieID:1 withTitle:@"那年我才18岁，ta也18岁，在那月黑风高的夜晚...阳光出奇的好，哈哈" withUserName:@"那一夜,啪啪啪" withTime:@"10小时前" withZanNumber:7 withCommentNumber:626];
//        YYCircleDetailContentModel *model3 = [YYCircleDetailContentModel CircleDetailContentModelWithTieID:1 withTitle:@"那年我才18岁，ta也18岁，在那月黑风高的夜晚...阳光出奇的好，哈哈，高的夜晚...阳光出奇的好，哈哈，高的夜晚...阳光出奇的好，哈哈" withUserName:@"那" withTime:@"10小时前" withZanNumber:77 withCommentNumber:666];
//        YYCircleDetailContentModel *model4 = [YYCircleDetailContentModel CircleDetailContentModelWithTieID:1 withTitle:@"那年我才18岁，ta也18岁，在" withUserName:@"那一夜" withTime:@"10086小时前" withZanNumber:77 withCommentNumber:666];
//        YYCircleDetailContentModel *model5 = [YYCircleDetailContentModel CircleDetailContentModelWithTieID:1 withTitle:@"那年我才18岁，ta也18岁，在那月黑风高的夜晚...阳光出奇的好，哈哈" withUserName:@"那一夜" withTime:@"10小时前" withZanNumber:77 withCommentNumber:666];
//        YYCircleDetailContentModel *model6 = [YYCircleDetailContentModel CircleDetailContentModelWithTieID:1 withTitle:@"那年我才18岁，ta也18岁，在那月黑风高的夜晚...阳光出奇的好，哈哈" withUserName:@"那一夜" withTime:@"10小时前" withZanNumber:77 withCommentNumber:666];
//        [_cellModelArrays addObject:model1];
//        [_cellModelArrays addObject:model2];
//        [_cellModelArrays addObject:model3];
//        [_cellModelArrays addObject:model4];
//        [_cellModelArrays addObject:model5];
//        [_cellModelArrays addObject:model6];
//        
    }
    return _cellModelArrays;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"bgq_detailCircle_write"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(commentCircle)];
    [self addHeadView];
  
    [self btnClickWithBtn:self.allBtn];
    [self getAllTieZi];

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
#pragma mark ----- 获取该圈子下所有的帖子

- (void)getAllTieZi{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=215&bcid=%d&buid=%@",self.model.bcid,self.account.userUID];
    YYLog(@"%@",urlStr);
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"连接成功返回的数据%@",responseObject);
        
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [self.infomationArrays removeAllObjects];
            [self.cellModelArrays removeAllObjects];
             YYLog(@"%lu",(unsigned long)[responseObject allKeys].count);
            for (int i = 0; i < [responseObject allKeys].count - 2; i++) {
                
                YYLog(@"%lu",[responseObject allKeys].count - 2);
                NSString *key = [NSString stringWithFormat:@"%d",i];
                NSDictionary *modelDic = responseObject[key];
                //                YYLog(@"%@\n%d",modelDic,i);
                YYLog(@"%@",modelDic);
                //http://www.sxeto.com/fruitApp/8344C3E4C864518DEBFF80D4C3FC73AD/headimg/head.png
                NSString *strUrl1 =[NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",modelDic[@"headimg"]];
                NSString *strUrl = strUrl1;
                
                NSString *nickName = modelDic[@"nickname"];
                
                NSString *timeStr1 = modelDic[@"time"];
                NSString *timeStr = [self timeWithLastTime:timeStr1.longLongValue];
                
                NSString *content = modelDic[@"content"];
                
                NSString *imagesArrayStr = modelDic[@"imgurllist"];
                
                NSString *shareNumber = modelDic[@"share"];
                
                NSString *zanNumber = modelDic[@"hot"];
                
                NSString *comment = modelDic[@"comment"];
                
                NSString *buid = modelDic[@"buid"];
                
                NSString *bcpid = modelDic[@"bcpid"];
                
                NSMutableArray *imageArray = [NSMutableArray array];
                if (imagesArrayStr.length != 0) {
                    YYLog(@"图片qqqqqqqq%@",imagesArrayStr);
                    NSArray *array = [imagesArrayStr componentsSeparatedByString:@","];
                    for (NSString *str in array) {
                        NSString *a = [@"http://www.sxeto.com/fruitApp" stringByAppendingPathComponent:str];
                        [imageArray addObject:a];
   
                    }
                    
                }
                
                YYDynamicMessageModel *model = [[YYDynamicMessageModel alloc] initWithIconUrlStr:strUrl nickName:nickName date:timeStr dynamicMessage:content imageUrlStrsArray:imageArray shareNumber:shareNumber.integerValue zanNumber:zanNumber.integerValue attention:@"2" andBsid:bcpid.intValue andCommentnumber:comment.integerValue andBuid:buid withFrom:@"2" withTime:timeStr1.longLongValue withUserID:1];
                
                YYCircleDetailContentModel *model1 = [YYCircleDetailContentModel CircleDetailContentModelWithTieID:bcpid.integerValue withTitle:content withUserName:nickName withTime:timeStr withZanNumber:zanNumber.integerValue withCommentNumber:comment.integerValue];
                
                [self.infomationArrays addObject:model];
                [self.cellModelArrays addObject:model1];
                // YYLog(@"%d",self.squareArrays.count);
                //                YYLog(@"%lu",(unsigned long)model.imageUrlStrsArray.count);
                [self.tableView reloadData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"连接失败，错误原因%@",error);
    }];
}

#pragma mark 发表评论
- (void)commentCircle{
    YYCircleWriteSomethingViewController *write = [[YYCircleWriteSomethingViewController alloc] initWithModel:self.model];
    [self.navigationController pushViewController:write animated:YES];
}
- (void)addHeadView{
    UIView *topHeadV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 100)];
    //头像
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY15HeightMargin, 54/375.0*widthScreen, 54/667.0*heightScreen)];
    headV.layer.cornerRadius = 2.5;//设置圆的半径
    headV.layer.masksToBounds = YES;
    [topHeadV addSubview:headV];
    self.leftImage = headV;
    
    //圈友和参与
    UILabel *quanyou = [[UILabel alloc] initWithFrame:CGRectMake(headV.frame.origin.x + headV.frame.size.width + YY10WidthMargin, YY10HeightMargin*2, widthScreen-(headV.frame.origin.x + headV.frame.size.width + YY10WidthMargin)-YY16WidthMargin - 65/375.0*widthScreen, 17)];
    quanyou.font = [UIFont systemFontOfSize:16];
    [topHeadV addSubview:quanyou];
    self.circleAndJoinLabel = quanyou;
    
    //分类栏
    UILabel *categorylb = [[UILabel alloc]initWithFrame:CGRectMake(quanyou.frame.origin.x, quanyou.frame.origin.y +17 + YY10HeightMargin, widthScreen-(headV.frame.origin.x + headV.frame.size.width + YY10WidthMargin)-YY16WidthMargin - 65/375.0*widthScreen - 40/375.0*widthScreen, 13)];
    categorylb.font = [UIFont systemFontOfSize:12];
    categorylb.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
    [topHeadV addSubview:categorylb];
    self.categoryLabel = categorylb;
    
    //获取圈子介绍的size
    NSString *temp = [NSString stringWithFormat:@"圈子介绍：%@",self.topModel.circleIntroduce];
    CGSize size = [temp boundingRectWithSize:CGSizeMake(widthScreen - 2*YY16WidthMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
    YYLog(@"%f",size.height);
    
    
    //圈子介绍
    UILabel *jieshao = [[UILabel alloc]initWithFrame:CGRectMake(YY16WidthMargin, headV.frame.origin.y + headV.frame.size.height + YY10HeightMargin, widthScreen - 2*YY16WidthMargin, size.height)];
    jieshao.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
    jieshao.numberOfLines = 0;
    jieshao.font = [UIFont systemFontOfSize:12];
    [topHeadV addSubview:jieshao];
    self.introduceLabel = jieshao;
    
    
    //加入圈的按钮
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.frame = CGRectMake(widthScreen - YY16WidthMargin - 65/375.0*widthScreen , YY10HeightMargin*3, 65/375.0*widthScreen, 30/667.0*heightScreen);
    [joinBtn setImage:[UIImage imageNamed:@"bgq_circle_joinCircle"] forState:UIControlStateNormal];
    [joinBtn setImage:[UIImage imageNamed:@"bgq_circle_joinCircle"] forState:UIControlStateHighlighted];
    [joinBtn setImage:[UIImage imageNamed:@"bgq_circle_HavejoinCircle"] forState:UIControlStateSelected];
    [joinBtn addTarget:self action:@selector(joinCircle:) forControlEvents:UIControlEventTouchUpInside];
    [topHeadV addSubview:joinBtn];
    
    joinBtn.selected = self.model.join;
    
    
    //分段控制器

    UIView *switchView = [[UIView alloc]initWithFrame:CGRectMake(2*YY16WidthMargin, jieshao.frame.origin.y + YY10HeightMargin + size.height,widthScreen - 4*YY16WidthMargin , 35)];
//    switchView.backgroundColor = [UIColor yellowColor];
    [topHeadV addSubview:switchView];
    self.switchView = switchView;
    //增加全部帖子按钮
    CGFloat btnW = switchView.width/2.0;
    self.allBtn = [self addBtnWithFrame:CGRectMake(0, 0,btnW , 35) andTag:0 andImage:[UIImage imageNamed:@"bgq_allBtn_normal"] andSelImage:[UIImage imageNamed:@"bgq_allBtn_Sel"] andTitle:@"全部帖子"];
    [self.allBtn setTitleColor:[UIColor colorWithRed:231/255.0 green:191/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
    [self.allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    
    self.essenceBtn = [self addBtnWithFrame:CGRectMake(btnW, 0, btnW, 35) andTag:1 andImage:[UIImage imageNamed:@"bgq_essenceBtn_normal"] andSelImage:[UIImage imageNamed:@"bgq_essenceBtn_sel"] andTitle:@"精华区"];
    [self.essenceBtn setTitleColor:[UIColor colorWithRed:231/255.0 green:191/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
    [self.essenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    self.topHeadView = topHeadV;
    //设置头部视图的高度
    CGFloat heightH = switchView.frame.origin.y + switchView.frame.size.height + 13/667.0*heightScreen;
    
    CGRect rect = _topHeadView.frame;
    rect.size.height = heightH;
    self.topHeadView.frame = rect;

    
    self.tableView.tableHeaderView = self.topHeadView;
#pragma mark ----- 加入数据
    //self.topModel.joinNumber
    NSURL *iconURLStr = [NSURL URLWithString:self.model.leftImageName];
    
    [self.leftImage sd_setImageWithURL:iconURLStr placeholderImage:[UIImage imageNamed:@"bgq_circle_headImage"]];
    //self.leftImage.image = [UIImage imageNamed:self.topModel.leftImageString];
    self.circleAndJoinLabel.text = [NSString stringWithFormat:@"圈友%ld  参与%ld",(long)self.topModel.circlefriend,(long)self.topModel.joinNumber];
    self.categoryLabel.text = self.topModel.category;
    self.introduceLabel.text = self.topModel.circleIntroduce;
}
#pragma mark增加按钮0全部1精华
- (UIButton *)addBtnWithFrame:(CGRect)btnFrame andTag:(NSInteger)tag andImage:(UIImage *)image andSelImage:(UIImage *)selImage andTitle:(NSString *)title{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [self.switchView addSubview:btn];
    btn.tag = tag;
   
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:selImage forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor colorWithRed:240/255.0 green:204/255.0 blue:60/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [btn addTarget:self action:@selector(btnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
- (void)btnClickWithBtn:(UIButton *)btn{
    self.allBtn.selected = NO;
    self.essenceBtn.selected = NO;
    btn.selected = YES;
    if (btn.tag == 0) {
        YYLog(@"全部");
    }
    else if (btn.tag == 1){
        YYLog(@"精华");

    }
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

    return self.cellModelArrays.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYCircleDetailContentTableViewCell *cell = [YYCircleDetailContentTableViewCell circleDetailContentTableViewCell:tableView];
    cell.model = self.cellModelArrays[indexPath.row];
    self.rowHeight = cell.cellRowHeight;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return YY10HeightMargin;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (void)joinCircle:(UIButton *)sender{
    YYLog(@"加入圈");
    YYAccount *account = [YYAccountTool account];
    
    
    if (account.userUID) {
        int flag = 0;
        if (self.model.join == YES) {
            flag = 1;
        }else{
            flag = 0;
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=25&buid=%@&bcid=%d&flag=%d",self.account.userUID,self.model.bcid,1-flag];
        YYLog(@"%@",urlStr);
        [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            sender.selected = !sender.selected;
            YYLog(@"连接成功，返回值为：%@",responseObject[@"msg"]);
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"reflashYYCircleViewController" object:self userInfo:nil];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            YYLog(@"连接失败,原因是%@",error);
        }];
    }else{
        YYGoLoginController *goLogin = [[YYGoLoginController alloc] init];
        [self.navigationController pushViewController:goLogin animated:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YYDynamicMessageModel *model = self.infomationArrays[indexPath.row];
    
    YYCDetailViewController *cdVC = [[YYCDetailViewController alloc] initWithModel:model withGoToPerson:@"1" withWhere:@"2"];
    [self.navigationController pushViewController:cdVC animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     
}




@end
