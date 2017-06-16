//
//  YYLittleColdDetaileViewController.m
//  YYLittleColdDetailTableView
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYLittleColdDetaileViewController.h"


#import "YYDetailCommentFrame.h"
#import "YYDetailCommentModel.h"
#import "YYDetaileCommentTableViewCell.h"
#import "YYAccountTool.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>



@interface YYLittleColdDetaileViewController () <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIWebViewDelegate, YYDetaileCommentTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArrays;
@property (nonatomic,strong) NSMutableArray *hotCommentModel;//热门评论；
@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic,strong) UIButton *zanBtn;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIView *downView;

@property (nonatomic, weak) UIImageView *zanImageView;
@property (nonatomic, weak) UIImageView *collectImageView;

//点中的cell进行回复
@property (nonatomic,strong) NSString *replyID;//回复的ID
@property (nonatomic,assign) NSString *replyNick;//回复的昵称

//判断是从哪里点击的
@property (nonatomic,strong) NSString *whereClick;//哪里点击的评论

//顶部webView
@property (nonatomic, strong) UIWebView *topWebView;

//评论弹出来的textField
@property (nonatomic, strong) UITextField *commendTextField;
//遮盖层
@property (nonatomic, strong) UIButton *coverView;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
/**
 *文章的url字符串
 */
@property (nonatomic, copy) NSString *essayUrlStr;
@property (nonatomic, assign) NSInteger baid;
@property (nonatomic,assign) NSInteger radius;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic,assign) int flag_Zan;//赞的flag
@property (nonatomic,assign) int flag_Collect;//收藏的flag

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;//小菊花
@end

@implementation YYLittleColdDetaileViewController

- (UIActivityIndicatorView *)activityIndicator{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        
    }
    return _activityIndicator;
}

- (NSMutableArray *)hotCommentModel{
    if (!_hotCommentModel) {
        _hotCommentModel = [[NSMutableArray alloc] init];
    }
    return _hotCommentModel;
}

- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}
- (instancetype)initWithEssayUrl:(NSString *)essayUrlStr andessayID:(NSInteger)baid andRadius:(NSInteger)radius{
    if (self = [super init]) {
        self.essayUrlStr = essayUrlStr;
        self.baid =baid;
        self.radius = radius;
        YYLog(@"%@\n%ld,radius:%ld",essayUrlStr,(long)baid,radius);
    }
    return self;
}
- (UITextField *)commendTextField{
    if (!_commendTextField) {
        _commendTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, heightScreen - 40, widthScreen, 40)];
      
//        _commendTextField.backgroundColor = YYGrayColor;
        _commendTextField.backgroundColor = [UIColor orangeColor];
        _commendTextField.borderStyle = UITextBorderStyleRoundedRect;
        _commendTextField.returnKeyType = UIReturnKeySend;
        _commendTextField.delegate = self;

    }
    return _commendTextField;
}
- (UIButton *)coverView{
    if (!_coverView) {
        _coverView = [[UIButton alloc]initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor clearColor];
        [_coverView addTarget:self action:@selector(clickcoverView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.whereClick = nil;
    
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
    
    //增加分享按钮
    UIImage *image = [UIImage imageNamed:@"littleCold_share"];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClick)];
    
    self.title = @"详细页面";
    [self.view addSubview:self.tableView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.downView];
    
//    self.topWebView;
    //获取顶部文章网页的url和是否赞过的属性flag
    NSString *userId = [YYAccountTool account].userUID;
#pragma mark 获取文章
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=32&baid=%ld&buid=%@",(long)self.baid,userId];
    YYLog(@"获取文章url%@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            YYLog(@"%@",connectionError);
        }
        
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        YYLog(@"%@",dic);
        
        NSNumber *flagnumber = dic[@"flag_h"];
        self.flag_Zan = 0;
        self.flag_Zan = flagnumber.intValue;
        
        NSNumber *flagnumber2 = dic[@"flag_c"];
        self.flag_Collect = 0;
        self.flag_Collect = flagnumber2.intValue;
        
        
        
        YYLog(@"%d",self.flag_Zan);
        if (self.flag_Zan == 0) {//未点赞
            self.zanImageView.image = [UIImage imageNamed:@"littleCold_bottomWeiZan"];
            //self.zanBtn.enabled = YES;
        }
        else if (self.flag_Zan == 1){
            self.zanImageView.image = [UIImage imageNamed:@"littleCold_bottomYiZan"];
            //self.zanBtn.enabled = NO;
        }
        
        if (self.flag_Collect == 0) {//未收藏
            self.collectImageView.image = [UIImage imageNamed:@"littleCold_collect_Wei"];
        }else if (self.flag_Collect == 1){
            self.collectImageView.image = [UIImage imageNamed:@"littleCold_collect_yi"];
        }
    }];
    //加载文章的网页
    NSURL *essayurl = [NSURL URLWithString:self.essayUrlStr];
    NSURLRequest *essayRequest = [NSURLRequest requestWithURL:essayurl];
    [self.topWebView loadRequest:essayRequest];

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

#pragma mark - Table view 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotCommentModel.count + 1;
    }else{
        if (self.modelArrays.count == 0) {
            return 2;
        }else{
            return self.modelArrays.count + 1;
        }
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self setheadTableviewcellWithTitle:@"热门评论"];
            return cell;
        }else{
            YYDetaileCommentTableViewCell *cell = [YYDetaileCommentTableViewCell DetailCommentTableViewCell:tableView WithPort:36];
            YYDetailCommentFrame *cellFrame = [[YYDetailCommentFrame alloc] init];
            YYDetailCommentModel *model = self.hotCommentModel[indexPath.row-1];
            cellFrame.model = model;
            cell.cellFrame = cellFrame;
            self.rowHeight = cell.cellSize.height;
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self setheadTableviewcellWithTitle:@"全部评论"];
            return cell;
        }else{
            if (self.modelArrays.count == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hh"];
                cell.textLabel.text = @"还没有评论,快来占领沙发吧~";
                cell.textLabel.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
                self.rowHeight = 44;
                return cell;
            }else{
            YYDetaileCommentTableViewCell *cell = [YYDetaileCommentTableViewCell DetailCommentTableViewCell:tableView WithPort:36];
            YYDetailCommentFrame *cellFrame = [[YYDetailCommentFrame alloc] init];
            YYDetailCommentModel *model = self.modelArrays[indexPath.row-1];
            cellFrame.model = model;
            cell.cellFrame = cellFrame;
            self.rowHeight = cell.cellSize.height;
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.delegate = self;

            return cell;
            }
        }
    }
    
}
//点击了单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.replyID = 0;
    self.replyNick = nil;
    YYDetailCommentModel *model = self.modelArrays[indexPath.row-1];
    self.replyID = model.userID;
    self.replyNick = model.userName;
    self.whereClick = @"2";
    
    return [self clickComment];
    
}
//热门评论和所有评论的框

- (UITableViewCell *)setheadTableviewcellWithTitle:(NSString *)title{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(YY16WidthMargin, 8, widthScreen - 2*YY16WidthMargin, 13)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:label];
    self.rowHeight = 13 + 8*2;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


//评论中点赞之后调用
- (void)commentCellZanClick{
    [self getAllCommentForEssay];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
       
        return self.rowHeight;
    }else{
        if (self.modelArrays.count == 0) {
            return self.rowHeight;
        }else{
            return self.rowHeight + 86/667.0*heightScreen;//前面的是可变高度，后面的是除了评论外其他的高度
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0/667.0*heightScreen;
//    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}


#pragma mark ----- 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, widthScreen, [UIScreen mainScreen].bounds.size.height - 40) style:UITableViewStyleGrouped];
      
    }
    return _tableView;
}
#pragma mark懒加载文章的webView
- (UIWebView *)topWebView{
    if (!_topWebView) {
       _topWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen)];
        
        [self.view addSubview:_topWebView];
        
        _topWebView.scrollView.scrollEnabled = NO;
        
        _topWebView.delegate = self;

    }
    return _topWebView;
}
//网页加载完之后
- (void)webViewDidFinishLoad:(UIWebView *)webView     //网页加载完成的时候调用
{
    
    CGRect frame = webView.frame;
    //    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    CGSize fittingSize = CGSizeMake(widthScreen, self.radius*widthScreen);
    frame.size = fittingSize;
    webView.frame = frame;
    YYLog(@"webViewDidFinishLoad%@",NSStringFromCGRect(webView.frame));
    self.tableView.tableHeaderView = webView;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    YYLog(@"出错");
}
#pragma mark 获取所有评论
- (void)getAllCommentForEssay{
    //删除所有模型
    [self.modelArrays removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=34&baid=%ld",(long)self.baid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject)
    {
        YYLog(@"%@",responseObject);
        for (int i = 0; i < responseObject.allKeys.count-1; i++)
        {
            
            NSString *key = [NSString stringWithFormat:@"%d",i];
            
            NSDictionary *subDic = responseObject[key];
            
            YYLog(@"%@",subDic);
            NSString *zan = subDic[@"hot"];
            
            NSString *strUrl1 =[NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",subDic[@"headimg"]];
            NSString *strUrl = strUrl1;
            
            NSString *timeStr = subDic[@"time"];
            
            timeStr = [self timeWithLastTime:timeStr.longLongValue];
            
            NSString *commentID = subDic[@"id"];
#pragma mark ----- 对谁说
            NSString *commentToMan = nil;//username
            
            if (![subDic[@"nickname_r"] isEqual:[NSNull null]]) {
                if ([subDic[@"nickname_r"] isEqualToString:@""]) {
                    commentToMan = subDic[@"username"];
                }else{
                    commentToMan = subDic[@"nickname_r"];
                }
            }
            YYLog(@"%@",commentToMan);
//            if ([subDic[@"nickname"] isEqualToString:@""]) {
//                commentToMan = subDic[@"username"];
//            }else{
//                commentToMan = subDic[@"nickname"];
//            }
            
            YYLog(@"%@",commentToMan);
            
            NSString *userID = subDic[@"buid"];
            //NSString *touxiang = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",subDic[@"headimg"]];
            
            YYDetailCommentModel *model = [YYDetailCommentModel detailCommentModelWithHeadImageStr:strUrl andUserName:subDic[@"nickname"] andTime:timeStr andCommentContent:subDic[@"content"] andCommentNumberOfZan:zan.integerValue andCommentID:commentID.integerValue andToMan:commentToMan andUserID:userID];
            
            [self.modelArrays addObject:model];
        }
        YYDetailCommentModel *model = nil;
        YYDetailCommentModel *model1 = nil;
        if (self.modelArrays.count != 0) {
            if (self.modelArrays.count == 1) {
                model = self.modelArrays[0];
            }else{
                    model = self.modelArrays[0];
                for (int i = 0; i < self.modelArrays.count ; i++) {
                    
                    model1 = self.modelArrays[i];
                    if (model.CommentNumberOfZan < model1.CommentNumberOfZan) {
                        model = model1;
                    }
                }
            }

            [self.hotCommentModel removeAllObjects];
            [self.hotCommentModel addObject:model];
        }
        
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"%@",error);
    }];
}
- (NSMutableArray *)modelArrays{
    if (!_modelArrays) {
        _modelArrays = [NSMutableArray array];
        [self getAllCommentForEssay];
    }
    return _modelArrays;
}
#pragma mark增加下面三个按钮
- (UIView *)downView{
    if (!_downView) {
        _downView = [[UIView alloc] initWithFrame:CGRectMake(0, heightScreen-40,widthScreen, 40)];
        _downView.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:244/255.0 alpha:1];
        
        //赞图和赞
        UIImageView *zanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleCold_bottomWeiZan"]];
        zanImageView.frame = CGRectMake(widthScreen/3/2-(20+22)/2, 10, 20, 20);
        [_downView addSubview:zanImageView];
        self.zanImageView = zanImageView;
        UILabel *zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen/3/2-(20+22)/2+22, 11, 20, 18)];
        zanLabel.text = @"赞";
        [_downView addSubview:zanLabel];
        
        
        //评论图和评论
        UIImageView *commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleCold_Comment"]];
        commentImageView.frame = CGRectMake(widthScreen/3/2-(20+35+2)/2+widthScreen/3, 10, 20, 20);
        [_downView addSubview:commentImageView];
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen/3/2-(20+35+2)/2+widthScreen/3+22, 11, 35, 18)];
        commentLabel.text = @"评论";
        [_downView addSubview:commentLabel];
        
        //收藏图和收藏
        UIImageView *collectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleCold_collect_Wei"]];
        collectImageView.frame = CGRectMake(widthScreen/3/2-(20+35+2)/2+widthScreen/3*2, 10, 20, 20);
        [_downView addSubview:collectImageView];
        self.collectImageView = collectImageView;
        UILabel *collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen/3/2-(20+35+2)/2+widthScreen/3*2+22, 11, 35, 18)];
        collectLabel.text = @"收藏";
        [_downView addSubview:collectLabel];
        
        
        //三个按钮的添加
        //赞
        self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zanBtn.frame = CGRectMake(0, 0, widthScreen/3.0, 40/667.0*heightScreen);
        self.zanBtn.backgroundColor = [UIColor clearColor];
        [_downView addSubview:self.zanBtn];
        [self.zanBtn addTarget:self action:@selector(clickZan:) forControlEvents:UIControlEventTouchUpInside];
        
        //评论
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentBtn.frame = CGRectMake(widthScreen/3.0, 0, widthScreen/3.0, 40/667.0*heightScreen);
        [_downView addSubview:self.commentBtn];
        self.commentBtn.backgroundColor = [UIColor clearColor];
        [self.commentBtn addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
        
        //收藏
        self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.collectBtn.frame = CGRectMake(widthScreen/3.0*2, 0, widthScreen/3.0, 40/667.0*heightScreen);
        
        self.collectBtn.backgroundColor = [UIColor clearColor];
        //[self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_downView addSubview:self.collectBtn];
        [self.collectBtn addTarget:self action:@selector(clickCollect:) forControlEvents:UIControlEventTouchUpInside];
        
        //竖线
        [[YYFruitTool shareFruitTool]addLineViewWithFrame:CGRectMake(widthScreen/3.0, 7,0.5, 26) andView:_downView];
      
        [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(widthScreen/3*2.0, 7,0.5, 26) andView:_downView];
       
    }
    return _downView;
}
#pragma mark 下面三个按钮的交互
/**
 *  点击了赞
 *
 */
- (void)clickZan:(UIButton *)sender{
    YYLog(@"点击了赞");

    NSString *userID = [YYAccountTool account].userUID;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=33&baid=%ld&buid=%@&flag=%d",self.baid, userID,(1-self.flag_Zan)];
    YYLog(@"点赞url%@",urlStr);
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        YYLog(@"%@",responseObject);
        NSString *zanSuccess = responseObject[@"msg"];
        
        if ([zanSuccess isEqualToString:@"ok"]) {
            YYLog(@"点赞成功");
            if (self.flag_Zan) {
                YYLog(@"取消咱");
                self.flag_Zan = 1- self.flag_Zan;
                self.zanImageView.image = [UIImage imageNamed:@"littleCold_bottomWeiZan"];
            }else{
                self.flag_Zan = 1- self.flag_Zan;
                YYLog(@"添加赞咱");
            self.zanImageView.image = [UIImage imageNamed:@"littleCold_bottomYiZan"];
            }
            //[self.view setNeedsDisplay];
        }
        else{
            [MBProgressHUD showError:@"网络连接错误"];
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"失败%@",error);
    }];
}
/**
 *  点击了评论
 *
 */
- (void)clickComment{
    YYLog(@"评论");
    
    
    
    if (self.whereClick == nil) {
        self.whereClick = @"1";
        self.replyID = nil;
    }else{
        self.whereClick = @"2";
        
    }
    
    
    [self.view addSubview:self.coverView];

    self.commendTextField.y = heightScreen - 40;
    [self.view addSubview:self.commendTextField];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.commendTextField becomeFirstResponder];
    self.whereClick = nil;
    
}
//点击returen键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.commendTextField resignFirstResponder];
    [self.coverView removeFromSuperview];
    NSString *commendStr = self.commendTextField.text;
    //发送评论buid(用户号),username(用户名),baid(文章编号),comment(内容)
    YYAccount *account = [YYAccountTool account];
    NSString *buserName = account.userNickName;
    if (buserName.length == 0) {
        buserName = account.userPhone;
    }
    NSString *urlStr = nil;
    if ([self.whereClick isEqualToString:@"1"]) {
          urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=35&baid=%ld&buid=%@&busername=%@&content=%@&bruid=%@",self.baid,account.userUID,buserName,commendStr,nil];
    }else{
         urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=35&baid=%ld&buid=%@&busername=%@&content=%@&bruid=%@",self.baid,account.userUID,buserName,commendStr,self.replyID];
    }
    
    YYLog(@"%@",urlStr);
   
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:5.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            YYLog(@"请求失败%@",connectionError);
        }
        
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        YYLog(@"%@",dic);
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"成功");
            [MBProgressHUD showSuccess:@"发送评论成功" toView:self.view];
            [self getAllCommentForEssay];
             
        }
        else{
            [MBProgressHUD showSuccess:@"网络连接错误" toView:self.view];
        }
    }];
    return YES;
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *frameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [frameValue CGRectValue];
    
    self.commendTextField.y = keyboardRect.origin.y - 40;
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.commendTextField.y = heightScreen;
    [self.commendTextField removeFromSuperview];
}

/**
 *  点击了蒙板
 */
- (void)clickcoverView{
    [self.commendTextField resignFirstResponder];
    [self.coverView removeFromSuperview];
}
/**
 *  点击了收藏
 *
 */
- (void)clickCollect:(UIButton *)sender{
    YYLog(@"点击了收藏");
    NSString *userID = [YYAccountTool account].userUID;
    YYLog(@"%d",self.flag_Collect);
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=37&baid=%ld&buid=%@&flag=%d",self.baid, userID,(1-self.flag_Collect)];
    YYLog(@"点赞url%@",urlStr);
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        YYLog(@"%@",responseObject);
        NSString *zanSuccess = responseObject[@"msg"];
        
        if ([zanSuccess isEqualToString:@"ok"]) {
            YYLog(@"点赞成功");
            if (self.flag_Collect) {
                YYLog(@"取消咱");
                self.flag_Collect = 1- self.flag_Collect;
                self.collectImageView.image = [UIImage imageNamed:@"littleCold_collect_Wei"];
            }else{
                self.flag_Collect = 1- self.flag_Collect;
                YYLog(@"添加赞咱");
                self.collectImageView.image = [UIImage imageNamed:@"littleCold_collect_yi"];
            }
            //[self.view setNeedsDisplay];
        }
        else{
            [MBProgressHUD showError:@"网络连接错误"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"失败%@",error);
    }];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 分享

- (void)shareBtnClick{
    YYLog(@"分享");
    UIView *view = [[UIView alloc] init];
    [self showShareActionSheet:view];
}
#pragma mark -

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

#pragma mark 显示分享菜单

/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    __weak YYLittleColdDetaileViewController *theController = self;
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSArray* imageArray = @[[UIImage imageNamed:@"sort_wechat"]];
    [shareParams SSDKSetupShareParamsByText:@"dashlaslasdlash"
                                     images:imageArray
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    [activePlatforms removeAllObjects];
    [activePlatforms addObject:@(SSDKPlatformTypeWechat)];
    //[activePlatforms removeObject:@(SSDKPlatformTypeSinaWeibo)];
    NSArray *arrayWeixin = [[NSArray alloc] init];
    arrayWeixin = @[@"997"];
    
    //2、分享
    [ShareSDK showShareActionSheet:view
                             items:activePlatforms
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       [theController showLoadingView:NO];
//                       [theController.tableView reloadData];
                   }
                   
               }];
    
}

@end
