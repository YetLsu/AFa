//
//  YYHomeNewViewController.m
//  圈子_V1
//
//  Created by Apple on 15/12/31.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYHomeNewViewController.h"
#import "FFScrollView.h"
#import "YYLittleColdDetaileViewController.h"
#import "YYLittleColdViewController.h"
#import "YYCircleModel.h"
#import "YYCircleDetailTableViewController.h"
#import "YYCircleViewController.h"
#import "YYNavigationController.h"
#import "YYAccountTool.h"
#import "UIImageView+WebCache.h"

#import "YYHomeNewBigTextViewController.h"
#import "YYHomeNewGuaiViewController.h"


#define YY16WidthMargin 16/375.0*widthScreen
#define YY10HeightMargin 10/667.0*heightScreen
#define YY15HeightMargin 15/667.0*heightScreen
#define widthScreen [UIScreen mainScreen].bounds.size.width //屏幕宽
#define heightScreen [UIScreen mainScreen].bounds.size.height //屏幕高
#define lineColor [UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:1]//灰色的线
@interface YYHomeNewViewController () <UITableViewDataSource,UITableViewDelegate,FFScrollViewDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) UIButton *bigBtn;//逼格按钮
@property (nonatomic,weak) UIButton *guideBtn;//指南按钮

@property (nonatomic,strong) NSArray *topImageViews;//上方的滚动视图的图片
@property (nonatomic,strong) NSMutableArray *downButtonImg;//下方滚动视图的图片

@property (nonatomic,strong) UIImageView *topImage;//头部的阿发图

@property (nonatomic,strong) NSMutableArray *hotCircleModel;//热门的圈子的模型

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic,copy) NSMutableArray *hotArticleArray;//文章组


@end

@implementation YYHomeNewViewController

- (NSMutableArray *)hotArticleArray{
    if (!_hotArticleArray) {
        _hotArticleArray = [[NSMutableArray alloc]init];
        
    }
    return _hotArticleArray;
}

- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (NSMutableArray *)hotCircleModel{
    if (!_hotCircleModel) {
        _hotCircleModel = [[NSMutableArray alloc] init];
    }
    return _hotCircleModel;
}

- (UIImageView *)topImage{
    if (!_topImage) {
        _topImage = [[UIImageView alloc]initWithFrame:CGRectMake(widthScreen/2.0 -  45/2.0, 64/2.0 - 25/2.0, 45, 25)];
        _topImage.image = [UIImage imageNamed:@"home_new_title"];
        //[self.navigationItem.titleView addSubview:_topImage];
        
    }
    return _topImage;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:tableview];
        tableview.delegate = self;
        tableview.dataSource = self;
        _tableView = tableview;
    }
    return _tableView;
}



- (NSMutableArray *)downButtonImg{
    if (!_downButtonImg) {
        _downButtonImg = [[NSMutableArray alloc]init];
    }
    return _downButtonImg;
}
- (NSArray *)topImageViews{
    
    if (!_topImageViews) {
        _topImageViews = @[@"bgq_circle_headView",@"bgq_circle_headView",@"bgq_circle_headView",@"bgq_circle_headView",@"bgq_circle_headView",@"bgq_circle_headView",@"bgq_circle_headView",@"bgq_circle_headView"];
    }
    return _topImageViews;
}

- (instancetype)init{
    if (self = [super init]) {
        NSMutableArray *modelArrays2 = [[NSMutableArray alloc]init];
        [modelArrays2 removeAllObjects];
        YYAccount *account = [YYAccountTool account];
        YYLog(@"%@",account.userUID);
        if (account.userUID) {
            
        }else{
            account.userUID = @"7E643900247907B907053B48D8593350";
        }
        NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=21&category=%d&buid=%@",0,account.userUID];
        
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
                    
                    [modelArrays2 addObject:models1];
                    
                    
                    [self.downButtonImg addObject:urlStr];
                    
                    if (i == [responseObject allKeys].count - 3) {
                        [self getHotCircle:modelArrays2];
                        
                    }
                    
                }
                
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            YYLog(@"连接失败，错误原因是%@",error);
        }];

        
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeadView];
    self.navigationItem.titleView = self.topImage;
    self.view.backgroundColor = [UIColor greenColor];
    [self getHotArticle];
    
}
- (void)getHotArticle{
    NSString *urlStr = @"http://www.sxeto.com/fruitApp/Buyer?mode=31&category=0";
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        
               YYLog(@"%@",responseObject);
        for (int i = 0; i < responseObject.count - 1; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            NSDictionary *dic = responseObject[key];
            YYLog(@"%@",dic);
            NSString *urlStr = dic[@"url"];
            NSString *baid = dic[@"id"];
            NSString *radius = dic[@"radius"];
            YYLittleColdDetaileViewController *LCDVC = [[YYLittleColdDetaileViewController alloc]
            initWithEssayUrl:urlStr andessayID:baid.integerValue andRadius:radius.integerValue];
            LCDVC.value = baid.integerValue;
            [self.hotArticleArray addObject:LCDVC];
            if (responseObject.count -2 == i) {
                if (i == 0) {
                    [self.tableView reloadData];
                }else{
                   [self setCurrentArray:self.hotArticleArray];
                }
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"失败");
    }];
}

- (void)setCurrentArray:(NSMutableArray *)array{
    YYCircleDetailTableViewController *a = nil;
    YYCircleDetailTableViewController *b = nil;
    for (int i = 0; i < array.count; i++) {
        for (int j = i + 1; j <array.count ; j++) {
            a = array[i];
            b = array[j];
            
            if (a.value < b.value) {
                [array replaceObjectAtIndex:i withObject:b];
                [array replaceObjectAtIndex:j withObject:a];
                
            }
        }
    }

    self.hotArticleArray = [NSMutableArray arrayWithArray:array];
    
    
    [self.tableView reloadData];
    
}

- (void)setupHeadView{
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 350/2/667.0*heightScreen +70/667.0*heightScreen)];
    
    //滚动视图
    FFScrollView *topScrollView = [[FFScrollView alloc] initPageViewWithFrame:CGRectMake(0, 0, widthScreen, 350/2/667.0*heightScreen) views:self.topImageViews];
    topScrollView.pageViewDelegate = self;
    //UIView *viewtop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 350/2/667.0*heightScreen)];
    //viewtop.backgroundColor = [UIColor greenColor];
    //[headView addSubview:topScrollView];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.frame = topScrollView.frame;
    headImageView.image = [UIImage imageNamed:@"home_new_banner"];
    [headView addSubview:headImageView];
    
    //big测试
    UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bigBtn.frame = CGRectMake(0, topScrollView.frame.origin.y+topScrollView.frame.size.height, widthScreen/2.0, 70/667.0*heightScreen);
    [bigBtn setImage:[UIImage imageNamed:@"home_new_bugTest"] forState:UIControlStateNormal];
    [bigBtn addTarget:self action:@selector(clickBig:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:bigBtn];
    
    //格调指南
    UIButton *guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guideBtn.frame = CGRectMake(widthScreen/2, bigBtn.frame.origin.y, widthScreen/2, bigBtn.frame.size.height);
    [guideBtn addTarget:self action:@selector(clickGuide:) forControlEvents:UIControlEventTouchUpInside];
    [guideBtn setImage:[UIImage imageNamed:@"home_new_guide"] forState:UIControlStateNormal];
    [headView addSubview:guideBtn];
    //添加线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(widthScreen/2,bigBtn.frame.origin.y + (YY10HeightMargin*7.0/2 - YY10HeightMargin*6.0/2) , 0.5, 60/667.0*heightScreen)];
    line1.backgroundColor = lineColor;
    [headView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 1, widthScreen, 0.5)];
    line2.backgroundColor = lineColor;
    [headView addSubview:line2];
    //banner下方的线
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, headImageView.frame.size.height, widthScreen, 0.5)];
    line3.backgroundColor = lineColor;
    [headView addSubview:line3];
    
    self.tableView.tableHeaderView = headView;
    
}


#pragma mark ----- tableView的数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YYHomeNewViewController"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //热门文章
        UIView *hotArticleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , widthScreen, 610/2/667.0*heightScreen)];
        //测试
        //hotArticleView.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:hotArticleView];
        
        //在热门文章中添加label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen/2.0-75/2.0, YY10HeightMargin, 75, 20)];
        titleLabel.text = @"热门文章";
        titleLabel.font = [UIFont systemFontOfSize:18];
        [hotArticleView addSubview:titleLabel];
        
        //更多的按钮
        UIButton *moreTop = [UIButton buttonWithType:UIButtonTypeCustom];
        moreTop.frame = CGRectMake(widthScreen - YY16WidthMargin - 38/375.0*widthScreen, YY15HeightMargin, 38/375.0*widthScreen, 13/667.0*heightScreen);
        //moreTop.backgroundColor = [UIColor blueColor];
        [moreTop setImage:[UIImage imageNamed:@"home_new_more"] forState:UIControlStateNormal];
        [moreTop addTarget:self action:@selector(clickmoreTop:) forControlEvents:UIControlEventTouchUpInside];
        
        [hotArticleView addSubview:moreTop];
        
        //点击进入文章的按钮
        UIButton *gotoArticle = [UIButton buttonWithType:UIButtonTypeCustom];
        gotoArticle.frame = CGRectMake(YY16WidthMargin, titleLabel.frame.origin.y + titleLabel.frame.size.height+YY10HeightMargin, widthScreen - 2*YY16WidthMargin, hotArticleView.frame.size.height - titleLabel.frame.origin.y - titleLabel.frame.size.height - YY10HeightMargin - YY10HeightMargin);
        [gotoArticle setImage:[UIImage imageNamed:@"home_new_hotartcle"] forState:UIControlStateNormal];
        [gotoArticle addTarget:self action:@selector(clickgotoArticle:) forControlEvents:UIControlEventTouchUpInside];
        [hotArticleView addSubview:gotoArticle];
        
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YYHomeNewViewController"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //热门圈子
        UIView *hotCircle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, widthScreen, 304/2/667.0*heightScreen)];
        //测试
       // hotCircle.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:hotCircle];
        
        //在热门文章中添加label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen/2.0-75/2.0, YY10HeightMargin, 75, 20)];
        titleLabel.text = @"热门圈子";
        titleLabel.font = [UIFont systemFontOfSize:18];
        [hotCircle addSubview:titleLabel];
        
        //更多的按钮
        UIButton *moreDown = [UIButton buttonWithType:UIButtonTypeCustom];
        moreDown.frame = CGRectMake(widthScreen - YY16WidthMargin - 38/375.0*widthScreen, YY15HeightMargin, 38/375.0*widthScreen, 13/667.0*heightScreen);
        //moreDown.backgroundColor = [UIColor blueColor];
        [moreDown setImage:[UIImage imageNamed:@"home_new_more"] forState:UIControlStateNormal];
        [moreDown addTarget:self action:@selector(clickmoreDown:) forControlEvents:UIControlEventTouchUpInside];
        
        [hotCircle addSubview:moreDown];
        
        //添加美味食谱的滚动视图
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(YY16WidthMargin, titleLabel.frame.origin.y + titleLabel.frame.size.height + YY10HeightMargin, widthScreen - 2* YY16WidthMargin, hotCircle.frame.size.height - titleLabel.frame.origin.y - titleLabel.frame.size.height - YY10HeightMargin - YY16WidthMargin)];
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        //测试
        //scroll.backgroundColor = [UIColor purpleColor];
        scroll.contentSize = CGSizeMake(scroll.frame.size.width, scroll.frame.size.height);
        [hotCircle addSubview:scroll];
        for (int i = 0; i < self.downButtonImg.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((95/375.0*widthScreen + YY10WidthMargin)*i, 0, 95/375.0*widthScreen, 95/667.0*heightScreen);
            button.backgroundColor = [UIColor clearColor];
            button.tag = i+50;//热门圈子的tag值从50开始
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:button];
            
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 95/375.0*widthScreen, 95/667.0*heightScreen)];
            NSURL *url = [NSURL URLWithString:self.downButtonImg[i]];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home_new_hotcircle"]];
    
            [button addSubview:imageView];
            
        }
        scroll.contentSize = CGSizeMake((95/375.0*widthScreen + YY10WidthMargin)*self.downButtonImg.count, scroll.frame.size.height);
        
        
 
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYLog(@"被点击");
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 610/2/667.0*heightScreen;
    }else{
        return 304/2/667.0*heightScreen;
    }
}

#pragma mark ----- 上方两个按钮的方法
- (void)clickBig:(UIButton *)sender{
    YYLog(@"逼格测试被点击");
    YYHomeNewBigTextViewController *HNBTVC = [[YYHomeNewBigTextViewController alloc] init];
    [self.navigationController pushViewController:HNBTVC animated:YES];
    
}
- (void)clickGuide:(UIButton *)sender{
    YYHomeNewGuaiViewController *HNGVC = [[YYHomeNewGuaiViewController alloc]init];
    [self.navigationController pushViewController:HNGVC animated:YES];
    YYLog(@"指南按钮被点击");
}
//更多文章
- (void)clickmoreTop:(UIButton *)sender{
    YYLog(@"上方的更多按钮被点击");
    YYLittleColdViewController *littleCold = [[YYLittleColdViewController alloc]init];
    [self.navigationController pushViewController:littleCold animated:YES];
}
//热门文章
- (void)clickgotoArticle:(UIButton *)sender{
    YYLog(@"点击了热门文章");
#pragma mark ----- 需要从网络获取一个热门文章的链接和文章的id
#warning 没完成的
    
    YYLittleColdDetaileViewController *dataile = self.hotArticleArray[0];
    [self.navigationController pushViewController:dataile animated:YES];
}
//更多热门圈子
- (void)clickmoreDown:(UIButton *)sender{
    YYLog(@"下方的更多按钮被点击");
    YYCircleViewController *CVC = [[YYCircleViewController alloc]initWithFlag:@"2"];
    
    [self.navigationController pushViewController:CVC animated:YES];
}
//热门圈子被点击

- (void)clickBtn:(UIButton *)sender{
    YYLog(@"第%ld张图被点击",sender.tag);
    YYCircleModel *model = self.hotCircleModel[sender.tag-50];
    YYCircleDetailTableViewController *CDTVC = [[YYCircleDetailTableViewController alloc]initWithCircleModel:model];
    [self.navigationController pushViewController:CDTVC animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)getHotCircle:(NSMutableArray *)array{

    if (array.count == 0)
    {
        
    }
    else if (array.count >=1 &&array.count <= 4){
        self.hotCircleModel = [NSMutableArray arrayWithArray:array];
    }
    else
    {
        YYCircleModel *a = nil;
        YYCircleModel *b = nil;
        for (int i = 0; i < array.count; i++)
        {
            for (int j = i + 1; j <array.count ; j++)
            {
                a = array[i];
                b = array[j];
                
                if (a.readNumber < b.readNumber)
                {
                    [array replaceObjectAtIndex:i withObject:b];
                    [array replaceObjectAtIndex:j withObject:a];
                    
                }
            }
        }
        [self.hotCircleModel addObject:array[0]];
        [self.hotCircleModel addObject:array[1]];
        [self.hotCircleModel addObject:array[2]];
        [self.hotCircleModel addObject:array[3]];
      
    }
    
    [self.tableView reloadData];
    
}

@end
