//
//  YYProfileViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/28.
//  Copyright © 2015年 wyy. All rights reserved.

#import "YYProfileViewController.h"
#import "YYAccountMessageController.h"
#import "YYOrderViewController.h"
#import "YYAddressController.h"
#import "YYSuggestController.h"
#import "YYMoreViewController.h"
#import "YYPushCenterController.h"
#import "YYMyWalletController.h"
#import "YYAccountTool.h"
#import "YYMyCircleFriendProfileController.h"
#import "YYProfileCollectViewController.h"
#import "YYGoLoginController.h"

#define YYSetUserName @" YYSetUserName"

@interface YYProfileViewController ()<UIActionSheetDelegate, YYAccountMessageControllerDelegate>
/**
 *  用户信息
 */
@property (nonatomic, strong)YYAccount *account;
@property (weak, nonatomic) UILabel *accountLabel;

@property (weak, nonatomic) UIView *loginRegisterView;
@property (weak, nonatomic) UITableView *proFilePableview;
/**
 *  头像
 */
@property (weak, nonatomic) UIImageView *iconView;

//tableviewHeaderView
@property (nonatomic, weak)UIView *headerView;


@end

@implementation YYProfileViewController
- (YYAccount *)account{
    if (!_account) {
        _account = [YYAccountTool account];
        YYLog(@"userName:%@\n userPhone:%@\n userIocn%@\n userUID%@\n userIconStr%@",_account.userNickName,_account.userPhone,_account.userIconImage,_account.userUID,_account.userIconUrlStr);
    }
    
    return _account;
}
- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, widthScreen, 260-64)];
        self.tableView.tableHeaderView = headerView;
        self.headerView = headerView;
        
        //把顶部图片上的控件添加到headerView中
        
        //添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserName) name:YYSetUserName object:nil];

        
        [self addHeaderView];
    }
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setNeedsDisplay];
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[YYFruitTool createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.accountLabel.text = [YYAccountTool account].userNickName;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //改回导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[YYFruitTool createImageWithColor:YYNavigationBarColor] forBarMetrics:UIBarMetricsDefault];
}
#pragma mark同步用户信息
-(void)uploadUserMessage{
    YYAccount *account = [YYAccountTool account];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=40&buid=%@",account.userUID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        YYLog(@"%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"获取个人资料成功");
            //修改用户名
            NSString *accountName = responseObject[@"nickname"];
            account.userNickName = accountName;
            if (accountName.length == 0) {
                accountName = responseObject[@"username"];
            }
            self.accountLabel.text = accountName;
 
            //修改头像
            NSString *userIconImgUrlStr = [@"http://www.sxeto.com/fruitApp/" stringByAppendingString:responseObject[@"headimg"]];
            
            userIconImgUrlStr = [userIconImgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            YYLog(@"%@",userIconImgUrlStr);
            account.userIconUrlStr = userIconImgUrlStr;
            
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:userIconImgUrlStr] placeholderImage:account.userIconImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    YYLog(@"请求出错");
                    return;
                }
                account.userIconImage  = image;
                [YYAccountTool saveAccount:account];
            }];

        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //获取帐户资料
    [self uploadUserMessage];

    UIImage *rightImage = [UIImage imageNamed:@"profile_settingMessage"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(editMessage)];
    
    self.tableView.rowHeight = 50;
    
}


/**
 *  修改个人信息
 *
 */
- (void)editMessage{
    YYLog(@"修改个人信息");
    YYAccountMessageController *accountController = [[YYAccountMessageController alloc] init];
    accountController.delegate = self;
    [self.navigationController pushViewController:accountController animated:YES];
}

#pragma mark 把顶部图片上的控件添加到headerView中CGRectMake(0, -64, widthScreen, 260-64)

- (void)addHeaderView{

    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, widthScreen, 260)];
    headerImage.image = [UIImage imageNamed:@"profile_TopBG"];
    [self.headerView addSubview:headerImage];
    
    //增加用户头像
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((widthScreen - 68)/2.0, 82 - 64, 68, 68)];
    iconView.layer.cornerRadius = iconView.frame.size.width/2.0;//设置圆的半径
    iconView.layer.masksToBounds = YES;
    [self.headerView addSubview:iconView];
    self.iconView = iconView;
    
    UIImage *userIcon = self.account.userIconImage;
    if (!userIcon) {
        userIcon = [UIImage imageNamed:@"profile_placeholderIcon"];
    }
    iconView.image = userIcon;
    
    //点击头像到设置页面
    UIButton *gotoEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoEdit.frame = iconView.frame;
    gotoEdit.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:gotoEdit];
    [gotoEdit addTarget:self action:@selector(editMessage) forControlEvents:UIControlEventTouchUpInside];
    
    //增加用户名label
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, widthScreen, 26)];
    userName.textAlignment = NSTextAlignmentCenter;
    
    //读取用户配置文件
    NSString *userNameText = self.account.userNickName;
    if (userNameText.length == 0) {
        userNameText = self.account.userPhone;
    }
    userName.text = userNameText;
    [self.headerView addSubview:userName];
    self.accountLabel = userName;
    
//    //增加下面的三个按钮
//    UIView *btnView = [[UIView alloc] init];
//    btnView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
//    btnView.frame = CGRectMake(0, 260 - 45- 64, widthScreen, 45);
//    [self.headerView addSubview:btnView];
//    
//    CGFloat width = widthScreen/3.0;
//    [self addBtnWithSuperView:btnView frame:CGRectMake(0, 0, width, 45) target:self action:@selector(localPush) image:[UIImage imageNamed:@"profile_pushIcon"] title:@"通知" andIconSize:CGSizeMake(16, 16)];
//    [self addBtnWithSuperView:btnView frame:CGRectMake(width, 0, width, 45) target:self action:@selector(walletClick) image:[UIImage imageNamed:@"profile_wallet"] title:@"钱包" andIconSize:CGSizeMake(21, 16)];
//    [self addBtnWithSuperView:btnView frame:CGRectMake(width * 2, 0, width, 45) target:self action:@selector(feiendClick) image:[UIImage imageNamed:@"profile_circleFriend"] title:@"圈友" andIconSize:CGSizeMake(14, 16)];
}
///**
// *  通知
// */
//- (void)localPush{
//    YYPushCenterController *pushController = [[YYPushCenterController alloc] init];
//    [self.navigationController pushViewController:pushController animated:YES];
//}
///**
// *  钱包
// */
//- (void)walletClick{
//
//    YYMyWalletController *myWallet = [[YYMyWalletController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:myWallet animated:YES];
//}
///**
// *  圈友
// */
//- (void)feiendClick{
//    YYLog(@"圈友");
//}
- (void)addBtnWithSuperView:(UIView *)superView frame:(CGRect)btnFrame target:(id)target action:(SEL)seletion image:(UIImage *)image title:(NSString *)title andIconSize:(CGSize)iconSize{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
//    [btn setViewFrame:btnFrame];
    [superView addSubview:btn];
    
    //增加图片
    CGFloat imageX = (btn.width - iconSize.width)/2.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 6, iconSize.width, iconSize.height)];
    imageView.image = image;
    [btn addSubview:imageView];

   //增加label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, widthScreen/3.0, 12)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    [btn addSubview:label];
    
    [btn addTarget:target action:seletion forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YYPushCenterController *pushController = [[YYPushCenterController alloc] init];
        [self.navigationController pushViewController:pushController animated:YES];
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            YYMyCircleFriendProfileController *circleFriend = [[YYMyCircleFriendProfileController alloc] initWithWhereToHere:@"1"];
            [self.navigationController pushViewController:circleFriend animated:YES];
        }
        else if (indexPath.row == 1){
            YYLog(@"跳转到收藏页面");
            YYProfileCollectViewController *collectVC = [[YYProfileCollectViewController alloc]init];
            [self.navigationController pushViewController:collectVC animated:YES];
        }
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            YYSuggestController *suggestController = [[YYSuggestController alloc] init];
            [self.navigationController pushViewController:suggestController animated:YES];
        }
        else if (indexPath.row == 1){
            YYMoreViewController *moreViewController = [[YYMoreViewController alloc] init];
            [self.navigationController pushViewController:moreViewController animated:YES];
        }
    }
}
#pragma mark tableview数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 1;
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = 0;
    
    switch (indexPath.section) {
        case 0:
            [self setCell:cell andimage:[UIImage imageNamed:@"profile_myOrder"] andiconFrame:CGRectMake(16, 15, 18.5, 20) andText:@"我的通知"];
            break;
        case 1:
            if (indexPath.row == 0) {
                [self setCell:cell andimage:[UIImage imageNamed:@"profile_address"] andiconFrame:CGRectMake(16, 15.75, 18.5, 18.5) andText:@"我的圈友"];
            }
            else if (indexPath.row == 1){
                [self setCell:cell andimage:[UIImage imageNamed:@"profile_myfavorite"] andiconFrame:CGRectMake(16, 16, 18, 18) andText:@"我的收藏"];
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                [self setCell:cell andimage:[UIImage imageNamed:@"profile_opinions"] andiconFrame:CGRectMake(16, 15.75, 18.5, 18.5) andText:@"意见反馈"];
            }
            else if (indexPath.row == 1){
                [self setCell:cell andimage:[UIImage imageNamed:@"profile_aboutMe"] andiconFrame:CGRectMake(16, 15.75, 18.5, 18.5) andText:@"关于我们"];
            }
            break;
        default:
            break;
    }
    
    return cell;
}
//设置单元格
- (void)setCell:(UITableViewCell *)cell andimage:(UIImage *)image andiconFrame:(CGRect)iconFrame andText:(NSString *)text{
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    iconView.image = image;
    [cell.contentView addSubview:iconView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, 50)];
    textLabel.text = text;
    [cell.contentView addSubview:textLabel];
}
#pragma mark 修改头像后在个人信息修改
- (void)setUserIcon:(UIImage *)image{
    self.iconView.image = image;
}
#pragma mark 修改昵称后在个人信息修改
- (void)setUserName{
    YYLog(@"称后在个人信息修改");
    self.accountLabel.text = [YYAccountTool account].userNickName;
}
@end
