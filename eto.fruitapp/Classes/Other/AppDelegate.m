//
//  AppDelegate.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/28.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "AppDelegate.h"
#import "YYTabBarController.h"
#import "YYFruitTool.h"
#import "YYSquareViewController.h"
#import "YYAccountTool.h"
#import "YYGoLoginController.h"

#import "YYHelloAFViewController.h"


#import "YYMapViewController.h"
#import <CoreLocation/CoreLocation.h>
//微信支付
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "WXApiObject.h"

//极光推送
#import "APService.h"

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import <MOBFoundation/MOBFoundation.h>

//短信验证
#import <SMS_SDK/SMSSDK.h>
//APPKey:d717de8a0d38
//APPSECRET:b7eb0dfc52b0380c6117e9329fbc3291

@interface AppDelegate ()
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation AppDelegate
- (CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
    }
    return _manager;
}
#pragma mark 从uid判断是否已登录
- (void)goToController{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    YYAccount *account = [YYAccountTool account];
    if (account.landed) {
        YYTabBarController *tabBarController = [[YYTabBarController alloc] init];
        
        self.window.rootViewController = tabBarController;
        self.tabbarController = tabBarController;
    }
    else{
#pragma mark ----- 登录进去的滚动视图
        YYHelloAFViewController *afScrollView = [[YYHelloAFViewController alloc] init];
       // YYGoLoginController *goLogin = [[YYGoLoginController alloc] init];
        self.window.rootViewController = afScrollView;
    }

    [self.window makeKeyAndVisible];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    YYLog(@"%@",NSHomeDirectory());
    
    [self goToController];
    
    
       //向用户授权当使用该软件时使用定位
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.manager requestWhenInUseAuthorization];
    }
    
    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    //若没有订单信息则存入沙盒
    if (![[YYFruitTool shareFruitTool] ordersFromDocuments]){
        [[YYFruitTool shareFruitTool] addOrders];
       
    }
    
    //从本地推送消息打开软件
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        [application setApplicationIconBadgeNumber:0];
    }
    //从远程推送打开
    else if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [application setApplicationIconBadgeNumber:0];
    }
    
    //极光推送
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    
    //分享
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[@(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             //[ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
//                         case SSDKPlatformTypeQQ:
//                             [ShareSDKConnector connectQQ:[QQApiInterface class]
//                                        tencentOAuthClass:[TencentOAuth class]];
//                             break;
//                         case SSDKPlatformTypeSinaWeibo:
//                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                      
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx59efa52c43efd39a"
                                            appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                      break;
                      
                  default:
                      break;
              }
          }];
#warning 短信验证
    [SMSSDK registerApp:@"d717de8a0d38"
             withSecret:@"b7eb0dfc52b0380c6117e9329fbc3291"];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [application setApplicationIconBadgeNumber:0];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                                                      YYLog(@"result = %@",resultDic);
                                                    
                                                  }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了, 所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就 是在这个方法里面处理跟 callback 一样的逻辑】
            YYLog(@"result = %@",resultDic);
           
        }];
    }
//    return  [WXApi haxndleOpenURL:url delegate:self];
    return YES;
}
- (void)sendPay_demo
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
   
}
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
  
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
 
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
     
    }
}

-(void) onResp:(BaseResp*)resp
{
    YYLog(@"The response of wechat.");
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [application setApplicationIconBadgeNumber:0];
    // Required
    [APService handleRemoteNotification:userInfo];
}


@end
