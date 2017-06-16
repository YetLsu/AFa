//
//  YYCollectionArticleViewController.m
//  eto.fruitapp
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "YYCollectionArticleViewController.h"

@interface YYCollectionArticleViewController () <UIWebViewDelegate>
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation YYCollectionArticleViewController

- (instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (UIActivityIndicatorView *)activityIndicator{
    if (!_activityIndicator) {
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    }
    return _activityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我收藏的文章";
    UIWebView *WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0 ,widthScreen , heightScreen)];
    
    //NSString *a = @"http://www.sxeto.com/fruitApp/article/demo.html#2";
    //NSURL *b = [NSURL URLWithString:a];
    

    [self.view addSubview:WebView];
    WebView.delegate = self;
    [WebView loadRequest:[NSURLRequest requestWithURL:self.url]];

    
}

#pragma mark ----- WebView的方法
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, heightScreen)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    [self.activityIndicator setCenter:view.center];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:self.activityIndicator];
    
    [self.activityIndicator startAnimating];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    YYLog(@"---------%f",webView.scrollView.contentSize.height);
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    YYLog(@"webViewDidFinishLoad");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
