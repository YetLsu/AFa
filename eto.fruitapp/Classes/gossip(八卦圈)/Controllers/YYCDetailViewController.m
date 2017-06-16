//
//  YYCDetailViewController.m
//  圈子_V1
//
//  Created by Apple on 15/12/19.
//  Copyright © 2015年 Apple. All rights reserved.
//  修改：修改了downview的背景颜色，添加YYCDetailHeadViewDelegate协议，使headview遵守协议，实现协议的方法，在协议中跳转

#import "YYCDetailViewController.h"
#import "YYCDetailHeadView.h"
#import "YYDetailCommentFrame.h"
#import "YYDetailCommentModel.h"
#import "YYDetaileCommentTableViewCell.h"
#import "YYDynamicMessageModel.h"
#import "YYAccountTool.h"
#import "YYLoginController.h"
//#import "YYCirclePersonViewController.h"
#import "YYCirclePersonOtherViewController.h"
#import "YYCirclePersonViewController.h"

//修改
@interface YYCDetailViewController () <UITableViewDataSource,UITableViewDelegate,YYCDetailHeadViewDelegate,YYDetaileCommentTableViewCellDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) YYDynamicMessageModel *HeadViewModel;
@property (nonatomic,assign) CGFloat headViewHeight;
@property (nonatomic,strong) NSMutableArray *modelArrays;
@property (nonatomic,strong) UIView *downView;
@property (nonatomic,assign) CGFloat rowHeight;
//@property (nonatomic,strong) YYDetailCommentModel *hotComment;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic,weak) UIImageView *zanImageView;//赞图
@property (nonatomic,weak) UIButton *zanBtn;//赞按钮

@property (nonatomic,assign) NSInteger bsid;//说说的id


@property (nonatomic,strong) NSMutableArray *hotCommentModel;//热门评论的

/** 点击评论弹出的textfield */
@property (nonatomic,strong) UITextField *commentTextField;

@property (nonatomic,strong) UIButton *coverBtn;//遮盖层的按钮（用来缩回键盘）

@property (nonatomic,assign) int flag; //是否已评论的flag

@property (nonatomic,assign) NSString *gotoPerson;//判断从哪里跳转到这个页面如果是从个人中心，则为2,广场则为1

//点中的cell进行回复
@property (nonatomic,strong) NSString *replyID;//回复的ID
@property (nonatomic,assign) NSString *replyNick;//回复的昵称

//判断是从哪里点击的
@property (nonatomic,strong) NSString *whereClick;//哪里点击的评论

@property (nonatomic,strong) YYDynamicMessageModel *model;//传过来的model；

@property (nonatomic,strong) YYAccount *account;//获取账号

@property (nonatomic,strong) NSString *whereToHere;//哪里此处的

@end

@implementation YYCDetailViewController

- (UITableView *)tableView{
    if (!_tableView) {
        if ([self.whereToHere isEqualToString:@"1"]) {
          _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen - 40/667.0*heightScreen - 64) style:UITableViewStyleGrouped];
        }else{
          _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen - 40/667.0*heightScreen) style:UITableViewStyleGrouped];
        }
        
    }
    return _tableView;
}

- (YYAccount *)account{
    if (!_account) {
        _account = [YYAccountTool account];
    }
    return _account;
}

#pragma mark ----- 跳转到查看其它的人的个人主页
- (void)pushToPersonViewControl:(YYDynamicMessageModel *)model{
    YYLog(@"%@",model);
    if ([model.buid isEqualToString:self.account.userUID]) {
        YYCirclePersonViewController *cPVC = [[YYCirclePersonViewController alloc]init];
        [self.navigationController pushViewController:cPVC animated:YES];
    }else{
        YYCirclePersonOtherViewController *cPOVC = [[YYCirclePersonOtherViewController alloc] initWithBuid:model.buid withAtt:model.attention withWhere:@"2"];
        [self.navigationController pushViewController:cPOVC animated:YES];
    }
    
   
}


- (UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.frame = self.view.bounds;
        [_coverBtn addTarget:self action:@selector(clickCoverBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _coverBtn;
    
}

- (UITextField *)commentTextField{
    if (!_commentTextField) {
        _commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, heightScreen - 40/667.0*heightScreen, widthScreen, 40/667.0*heightScreen)];
        //测试
        _commentTextField.backgroundColor = [UIColor yellowColor];
        _commentTextField.borderStyle = UITextBorderStyleRoundedRect;
        _commentTextField.returnKeyType = UIReturnKeySend;
        _commentTextField.delegate = self;
    }
    return _commentTextField;
}


- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}
- (instancetype) initWithModel:(YYDynamicMessageModel *)model withGoToPerson:(NSString *)gotoPerson withWhere:(NSString *)where{
    if (self = [super init]) {
        self.HeadViewModel = model;
        self.bsid = model.bsid;
        self.model = model;
        self.gotoPerson = gotoPerson;
        self.whereToHere = where;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    [self addTableViewHeadView];
    [self addDownView];
    self.whereClick = nil;
    
    self.title = @"详细";

    UIImage *image = [UIImage imageNamed:@"littleCold_share"];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickShareBtn)];
    
    [self getModelsArray];
    
    //    self.topWebView;
    //获取顶部文章网页的url和是否赞过的属性flag
    NSString *userId = [YYAccountTool account].userUID;
#pragma mark 获取是否关注，是否点赞
    NSString *urlStr = nil;
    if ([self.model.from isEqualToString:@"1"]) {
        urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=214&bsid=%ld&buid=%@&bfuid=%@",(long)self.bsid,userId,self.model.buid];
        YYLog(@"url:%@",urlStr);
    }else if ([self.model.from isEqualToString:@"2"]){
        urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=216&bcpid=%ld&buid=%@&bfuid=%@",(long)self.bsid,userId,self.model.buid];
        YYLog(@"url:%@",urlStr);
    }
    
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
        self.flag = 0;
        self.flag = flagnumber.intValue;
   
        YYLog(@"%d",self.flag);
        if (self.flag == 0) {//未点赞
            self.zanImageView.image = [UIImage imageNamed:@"littleCold_bottomWeiZan"];
            //self.zanBtn.enabled = YES;
        }
        else if (self.flag == 1){
            self.zanImageView.image = [UIImage imageNamed:@"littleCold_bottomYiZan"];
            
            //self.zanBtn.enabled = NO;
        }
    }];

    
   
}
- (void)clickShareBtn{
    YYLog(@"点击了分享按钮");
}

- (void)addTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
#pragma mark ----- 添加头部视图
- (void)addTableViewHeadView{
    YYCDetailHeadView *headView = [[YYCDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 100)];
    headView.model = self.HeadViewModel;
    self.headViewHeight = headView.viewHeight;
    CGRect rect = headView.frame;
    rect.size.height = self.headViewHeight;
    headView.frame = rect;
    headView.backgroundColor = [UIColor whiteColor];
    headView.delegate = self;
    if ([self.gotoPerson isEqualToString:@"1"]) {
        headView.goToPersonBtn.enabled = YES;
    }else if ([self.gotoPerson isEqualToString:@"2"]){
        headView.goToPersonBtn.enabled = NO;
    }
    
    //headView.model = self.HeadViewModel;
    self.tableView.tableHeaderView = headView;
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

#pragma mark ----- YYDetaileCommentTableViewCellDelegate
- (void)commentCellZanClick{
    [self getModelsArray];
    //[self.tableView reloadData];
}



- (void)addDownView{
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, widthScreen, 40/667.0*heightScreen)];
    //self.downView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.downView];
    
    UIImageView *zanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleCold_bottomWeiZan"]];
    zanImageView.frame = CGRectMake(widthScreen/12.0, 10/667.0*heightScreen, 20/375.0*widthScreen, 20/667.0*heightScreen);
    
    [self.downView addSubview:zanImageView];
    //修改12_24
    self.zanImageView = zanImageView;
    
    UILabel *zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen/12.0+20/375.0*widthScreen+3, 12/667.0*heightScreen, 20, 18/667.0*heightScreen)];
    zanLabel.text = @"赞";
    [self.downView addSubview:zanLabel];
    
    UIImageView *commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleCold_Comment"]];
    commentImageView.frame = CGRectMake(widthScreen/12.0*5, 10/667.0*heightScreen, 20/375.0*widthScreen, 20/667.0*heightScreen);
    [self.downView addSubview:commentImageView];
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen/12.0*5+20/375.0*widthScreen+3, 12/667.0*heightScreen, 35, 18/667.0*heightScreen)];
    commentLabel.text = @"评论";
    [self.downView addSubview:commentLabel];
    
    UIImageView *collectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleCold_collect_Wei"]];
    collectImageView.frame = CGRectMake(widthScreen/12.0*9, 10/667.0*heightScreen, 20/375.0*widthScreen, 20/667.0*heightScreen);
    [self.downView addSubview:collectImageView];
    UILabel *collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen/12.0*9+20/375.0*widthScreen+3, 12/667.0*heightScreen, 35, 18/667.0*heightScreen)];
    collectLabel.text = @"收藏";
    [self.downView addSubview:collectLabel];
    
    
    //三个按钮的添加
    //赞
    UIButton *zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zanBtn.frame = CGRectMake(0, 0, widthScreen/3.0, 40/667.0*heightScreen);
    zanBtn.backgroundColor = [UIColor clearColor];
    [self.downView addSubview:zanBtn];
    [zanBtn addTarget:self action:@selector(clickZan:) forControlEvents:UIControlEventTouchUpInside];
    //修改12_24
    self.zanBtn = zanBtn;
    
    //评论
    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(widthScreen/3.0, 0, widthScreen/3.0, 40/667.0*heightScreen);
    [self.downView addSubview:commentBtn];
    commentBtn.backgroundColor = [UIColor clearColor];
    [commentBtn addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏
    UIButton * collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(widthScreen/3.0*2, 0, widthScreen/3.0, 40/667.0*heightScreen);
    
    collectBtn.backgroundColor = [UIColor clearColor];
    //[self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.downView addSubview:collectBtn];
    [collectBtn addTarget:self action:@selector(clickCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //竖线
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3.0, 7/667.0*[UIScreen mainScreen].bounds.size.height,1, 26/667.0*[UIScreen mainScreen].bounds.size.height)];
    grayView.backgroundColor = [UIColor grayColor];
    [_downView addSubview:grayView];
    UIView *grayViewnew = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3.0*2, 7/667.0*[UIScreen mainScreen].bounds.size.height,1, 26/667.0*[UIScreen mainScreen].bounds.size.height)];
    grayViewnew.backgroundColor = [UIColor grayColor];
    [_downView addSubview:grayViewnew];
//修改
    self.downView.backgroundColor = [UIColor whiteColor];
}
//修改12_24
#pragma mark ---- 点击页面的赞触发的方法
- (void)clickZan:(id)sender{
    YYLog(@"点击了赞");
    NSString *userID = [YYAccountTool account].userUID;
    
    NSString *urlStr = nil;
    if ([self.model.from isEqualToString:@"1"]) {
        urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=23&bsid=%ld&buid=%@&flag=%d",(long)self.bsid, userID,(1-self.flag)];
    }else if ([self.model.from isEqualToString:@"2"]){
        urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=231&bcpid=%ld&buid=%@&flag=%d",(long)self.bsid, userID,(1-self.flag)];
    }
    
    YYLog(@"点赞url%@",urlStr);
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        YYLog(@"%@",responseObject);
        NSString *zanSuccess = responseObject[@"msg"];
        YYLog(@"%@",zanSuccess);
        if ([zanSuccess isEqualToString:@"ok"]) {
            YYLog(@"点赞成功");
            if (self.flag) {
                YYLog(@"取消咱");
                self.flag = 1- self.flag;
                self.zanImageView.image = [UIImage imageNamed:@"littleCold_bottomWeiZan"];
            }else{
                self.flag = 1- self.flag;
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

- (void)clickComment{
    YYLog(@"点击了评论%@",self.whereClick);
    if (self.whereClick == nil) {
        self.whereClick = @"1";
    }else{
        self.whereClick = @"2";
    }
    [self.view addSubview:self.coverBtn];
    
    self.commentTextField.y = heightScreen - 40/667.0*heightScreen;
    [self.view addSubview:self.commentTextField];
    //使textfield成为第一响应者
    //[self.commentTextField becomeFirstResponder];
    
    //增加监听，当键盘出现或者变更时发出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //监听，键盘收起时的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //使textfield成为第一响应者
    [self.commentTextField becomeFirstResponder];
    
}






- (void)clickCollect:(id)sender{
    YYLog(@"点击了收藏");
}

#pragma mark ----- textfield的协议事件
//textfield点击了回车后执行的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //取消第一响应者
    [self.commentTextField resignFirstResponder];
    [self.coverBtn removeFromSuperview];
    NSString *commendStr = self.commentTextField.text;
//buid(用户号)，bsid（当前内容的编号），nickname(昵称)，headimg（头像），content（内容）
    YYAccount *account = [YYAccountTool account];
    NSString *buserName = account.userNickName;
    if (buserName.length == 0) {
        buserName = account.userPhone;
    }
    YYLog(@"aaaaaaa:%@",buserName);
    
    if (buserName == 0) {
        //未登录跳转到登录界面
        YYLoginController *loginVC = [YYLoginController new];
        [self.navigationController pushViewController:loginVC animated:YES];
        return YES;
    }
    
    NSString *urlStr = nil;
    YYLog(@"aaaaaaa%@",self.whereClick);
    if ([self.whereClick isEqualToString:@"1"]) {
        if ([self.model.from isEqualToString:@"1"]) {
            urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=27&buid=%@&bsid=%ld&content=%@&bruid=%@",account.userUID,(long)self.bsid,commendStr,[NSNull null]];
        }else if ([self.model.from isEqualToString:@"2"]){
            urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=271&buid=%@&bcpid=%ld&content=%@&bruid=%@",account.userUID,(long)self.bsid,commendStr,[NSNull null]];
        }
        

    }else{
        if ([self.model.from isEqualToString:@"1"]) {
            urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=27&buid=%@&bsid=%ld&content=%@&bruid=%@",account.userUID,(long)self.bsid,commendStr,self.replyID];
        }else if ([self.model.from isEqualToString:@"2"]){
            urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=271&buid=%@&bcpid=%ld&content=%@&bruid=%@",account.userUID,(long)self.bsid,commendStr,self.replyID];
        }
        
        
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
        YYLog(@"%@",dic[@"msg"]);
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"成功");
            [MBProgressHUD showSuccess:@"发送评论成功" toView:self.view];
            [self getModelsArray];
        }else{
            [MBProgressHUD showSuccess:@"网络连接错误" toView:self.view];
        }
        
        
    }];
    self.whereClick = nil;
    return YES;
    
    
}


//键盘出现
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *frameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [frameValue CGRectValue];
    
    
    self.commentTextField.y = keyboardRect.origin.y - self.commentTextField.frame.size.height;
    
    
}

//键盘收起时

- (void)keyboardWillHide:(NSNotification *)aNotification{
    self.commentTextField.y = heightScreen;
    [self.commentTextField removeFromSuperview];
}

#pragma mark ----- coverBtn被点击触发的事件

- (void)clickCoverBtn{
    [self.commentTextField resignFirstResponder];
    
    [self.coverBtn removeFromSuperview];
}


#pragma mark ----- 表的delegate和data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        //修改12_24
        return self.hotCommentModel.count+1;
    }else{
        if (self.modelArrays.count == 0) {
            return 2;
        }else{
            return self.modelArrays.count+1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self setheadTableviewcellWithTitle:@"热门评论"];
            return cell;
        }else{
            YYDetaileCommentTableViewCell *cell = nil;
            if ([self.model.from isEqualToString:@"1"]) {
                cell = [YYDetaileCommentTableViewCell DetailCommentTableViewCell:tableView WithPort:28];
            }else if ([self.model.from isEqualToString:@"2"]){
                cell = [YYDetaileCommentTableViewCell DetailCommentTableViewCell:tableView WithPort:281];
            }
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
                YYDetaileCommentTableViewCell *cell = nil;
                if ([self.model.from isEqualToString:@"1"]) {
                    cell = [YYDetaileCommentTableViewCell DetailCommentTableViewCell:tableView WithPort:28];
                }else if ([self.model.from isEqualToString:@"2"]){
                    cell = [YYDetaileCommentTableViewCell DetailCommentTableViewCell:tableView WithPort:281];
                }
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

#pragma mark ----- cell的点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.replyID = 0;
    self.replyNick = nil;
    YYDetailCommentModel *model = self.modelArrays[indexPath.row-1];
    self.replyID = model.userID;
    self.replyNick = model.userName;
    self.whereClick = @"2";
    
    return [self clickComment];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {

        return self.rowHeight;
    }else{
        if (self.modelArrays.count == 0) {
            return self.rowHeight;
        }else{
            return self.rowHeight + 86/667.0*[UIScreen mainScreen].bounds.size.height;//前面的是可变高度，后面的是除了评论外其他的高度
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getModelsArray{
    //[self.modelArrays removeAllObjects];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([self.model.from isEqualToString:@"1"]) {
        parameters[@"mode"] = @"26";
        parameters[@"bsid"] = [NSString stringWithFormat:@"%d",self.HeadViewModel.bsid];
    }else if ([self.model.from isEqualToString:@"2"]){
        parameters[@"mode"] = @"261";
        parameters[@"bcpid"] = [NSString stringWithFormat:@"%d",self.HeadViewModel.bsid];
    }
    
   
    
    YYLog(@"%@",parameters);
    [self.manager GET:@"http://www.sxeto.com/fruitApp/Buyer" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        YYLog(@"-=-=-=-=-==-=-=-请求发送成功%@",responseObject[@"msg"]);
        YYLog(@"%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            [self.modelArrays removeAllObjects];
            NSInteger count = responseObject.allKeys.count;//定义一个计数的
            if (count == 0) {
                count =1;
            }
            for (int i = 0; i < count-1; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                
                NSDictionary *commentDic = responseObject[key];
                YYLog(@"%@",commentDic);
                
                NSString *timeStr = commentDic[@"time"];
                
                NSString *zanStr = commentDic[@"hot"];
                
                NSString *commentIDStr = nil;
                if ([self.model.from isEqualToString:@"1"]) {
                    commentIDStr = commentDic[@"id"];
                }else if ([self.model.from isEqualToString:@"2"]){
                    commentIDStr = commentDic[@"bcpcid"];
                }
                
                NSString *strUrl1 =[NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",commentDic[@"headimg"]];
                NSString *strUrl = strUrl1;
                
                
#pragma mark ----- 对谁说
                NSString *commentReplyMan = nil;//username
                
                if (![commentDic[@"r_nickname"] isEqual:[NSNull null]]) {
                    commentReplyMan = commentDic[@"r_nickname"];
                }
                if ([commentDic[@"r_nickname"] isEqual:[NSNull null]]) {
                    commentReplyMan = nil;
                    YYLog(@"ceshi-------");
                }
                YYLog(@"%@",commentReplyMan);
                
                //NSString *commentReplyMan = commentDic[@"r_nickname"];
                NSString *commentReplyUserID = commentDic[@"buid"];
                
                YYLog(@"%@",commentDic);
                YYLog(@"%@",timeStr);
                YYLog(@"%lld",timeStr.longLongValue);
                YYDetailCommentModel *commentModel = [YYDetailCommentModel detailCommentModelWithHeadImageStr:strUrl andUserName:commentDic[@"nickname"] andTime:[self timeWithLastTime:timeStr.longLongValue] andCommentContent:commentDic[@"content"] andCommentNumberOfZan:zanStr.integerValue andCommentID:commentIDStr.integerValue andToMan:commentReplyMan andUserID:commentReplyUserID];
                [self.modelArrays addObject:commentModel];
                YYLog(@"-----------------------------------%lu",(unsigned long)self.modelArrays.count);
            }
            //修改12_42
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
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"失败%@",error);
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

- (NSMutableArray *)modelArrays{
    //[UIImage imageNamed:@"bgq_circle_leftTopHeadImage"]
    if (!_modelArrays) {
        _modelArrays = [[NSMutableArray alloc] init];

        
    }
    return _modelArrays;
}

- (NSMutableArray *)hotCommentModel{
    if (!_hotCommentModel) {
        _hotCommentModel = [[NSMutableArray alloc] init];
    }
    return _hotCommentModel;
}

#pragma mark ----- 点关注的方法

- (void)attationBtnGuanZhuWith:(NSString *)attation bfuid:(NSString *)bfuid{
    YYAccount *account = [YYAccountTool account];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=24&buid=%@&bfuid=%@&flag=1",account.userUID,bfuid];
    YYLog(@"%@",urlStr);
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        YYLog(@"%@",responseObject);
        YYLog(@"关注成功");
        
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
        YYLog(@"取消关注成功");
        //[self refreshControlTableView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"取消关注失败");
    }];
    
}





@end
