//
//  YYAccountMessageController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/1.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYAccountMessageController.h"
#import "YYSetUserNameController.h"
#import "YYSetPassWordController.h"
#import "YYAccountTool.h"
#import "YYTabBarController.h"
#import "YYGoLoginController.h"



@interface YYAccountMessageController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, weak) UITableView *tableView;


@property (nonatomic, strong)  AFHTTPRequestOperationManager *manager;
@end

@implementation YYAccountMessageController
- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
/**
 *  懒加载头像
 */
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        
    }
    return _iconView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    CGFloat margin = 15/375.0 * widthScreen;
    self.title = @"用户设置";
    //设置view的背景颜色
    self.view.backgroundColor = YYViewBGColor;
    
    //增加tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 186) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    self.tableView = tableView;
    
    //增加退出登录按钮
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin, 205, widthScreen - margin * 2, 42)];
    [self.view addSubview:logoutBtn];
    
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_yellowbg"] forState:UIControlStateNormal];
    
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 退出登录
- (void)logoutBtnClick{
    YYAccount *account = [YYAccountTool account];
    account.userIconImage = nil;
    account.userNickName = nil;
    account.userPhone = nil;
    account.userUID = nil;
    account.userBackgroundImage = nil;
    account.userBackgroundUrlStr = nil;
    
    [YYAccountTool saveAccount:account];
    
//    YYTabBarController *tabbar = [[YYTabBarController alloc] init];
//    
//    [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
//    tabbar.selectedIndex = 3;
//2月24日修改
    YYGoLoginController *gologin = [[YYGoLoginController alloc] init];
    [self presentViewController:gologin animated:YES completion:nil];
    
    
    
}

#pragma mark tableview的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = 0;

    if (indexPath.row == 0) {
        
        self.iconView.frame = CGRectMake(325/375.0 * widthScreen, 7, 30, 30);
        self.iconView.layer.cornerRadius = self.iconView.frame.size.width/2.0;
        self.iconView.layer.masksToBounds = YES;
        [cell.contentView addSubview:self.iconView];
        
        UIImage *image = [YYAccountTool account].userIconImage;
        if (!image) {
            image = [UIImage imageNamed:@"profile_placeholderIcon"];
        }
        self.iconView.image = image;
        cell.textLabel.text = @"头像";
        return cell;
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"手机";
        cell.detailTextLabel.text = [YYAccountTool account].userPhone;
        return cell;
    }
    switch (indexPath.row) {
        case 1:
            cell.textLabel.text = @"昵称";
            YYLog(@"%@",[YYAccountTool account].userNickName);
            cell.detailTextLabel.text = [YYAccountTool account].userNickName;
            break;
        case 2:
            cell.textLabel.text = @"修改密码";
            break;
        default:
            break;
    }
    
    cell.detailTextLabel.textColor = YYGrayTextColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
/**
 *  点击某行单元格
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YYLog(@"修改头像");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"拍照", nil];
        [actionSheet showInView:self.view];
    }
    else if (indexPath.row == 1){
        YYSetUserNameController *UserNameController = [[YYSetUserNameController alloc] initWithTitle:@"用户名" placedor:@"用户名" footTexe:@"用户名只能修改一次" andTag:0];
        [self.navigationController pushViewController:UserNameController animated:YES];
    }
    else if (indexPath.row == 2){
        YYSetPassWordController *setPasswordController = [[YYSetPassWordController alloc] initWithTag:0];
        [self.navigationController pushViewController:setPasswordController animated:YES];
    }
    else if (indexPath.row == 3){
//        YYSetPassWordController *setPhoneController = [[YYSetPassWordController alloc] initWithTag:1];
//        [self.navigationController pushViewController:setPhoneController animated:YES];
        return;
    }
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
    dic[@"mode"] = @"45";
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
        if ([dic[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"修改成功");
            if ([self.delegate respondsToSelector:@selector(setUserIcon:)]) {
                [self.delegate setUserIcon:image];
            }
            self.iconView.image = image;
            
            
            account.userIconImage = image;
            [YYAccountTool saveAccount:account];
            [MBProgressHUD showSuccess:@"成功修改头像"];
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"changeYYGossipViewControllericon" object:self userInfo:@{@"image":image}];
         
            [picker dismissViewControllerAnimated:YES completion:nil];
           
        }else{
            [MBProgressHUD showError:@"网络错误"];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
        YYLog(@"解析数据%@\n\n错误%@",dic,error);
    }];
}
@end
