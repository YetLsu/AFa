//
//  YYCircleWriteSomethingViewController.m
//  圈子_V1
//
//  Created by Apple on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCircleWriteSomethingViewController.h"
#import "WYTextView.h"
#import "WYToolBar.h"
#import "JKImagePickerController.h"
#import "DSComposePhotosView.h"
#import "YYCircleModel.h"
#import "YYAccountTool.h"

@interface YYCircleWriteSomethingViewController ()<DSComposeToolbarDelegate,UITextViewDelegate,JKImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>

//是否正在切换键盘
@property (nonatomic ,assign, getter=isChangingKeyboard) BOOL ChangingKeyboard;

//@property (nonatomic,weak) UITextView *textView;
@property (nonatomic,weak) WYTextView *textView;
@property (nonatomic,weak) WYToolBar *toolBar;
@property (nonatomic , weak) DSComposePhotosView *photosView;


@property (nonatomic,copy) NSString *themeContent;
@property (nonatomic,assign) NSInteger len;

@property (nonatomic,assign) NSInteger mode;//是否有主题


@property (nonatomic, strong) YYCircleModel *model;
@end

@implementation YYCircleWriteSomethingViewController
- (instancetype)initWithModel:(YYCircleModel *)model{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (instancetype)initWithMode:(NSInteger)mode{
    if (self = [super init]) {
        self.mode = mode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写几句";
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.model.prefixTitle == nil) {
        self.themeContent = @"";
    }else{
       self.themeContent = [NSString stringWithFormat:@"#%@# ",self.model.prefixTitle]; 
    }
    
    
    self.len = self.themeContent.length;
    [self setUpTextView];
    [self setUpToolBar];
    [self setupPhotosView];
    [self setupTopRightBarbutton];
 
}

- (void)setupTopRightBarbutton{
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(widthScreen -  YY16WidthMargin - 60, 2, 60, 40);
    [registBtn setTitle:@"发送" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(clickRightBar) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registBtn];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bgq_write_send_1"]  style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBar)];
    //self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}
- (void)clickRightBar{
    YYLog(@"发送");//就是个UIimage;
    YYLog(@"%lu",(unsigned long)self.textView.text.length);
    YYLog(@"%ld",(long)self.len);
    if (self.model.prefixTitle == nil && self.textView.text.length == (self.len-1) && self.photosView.selectedPhotos.count == 0) {
        [MBProgressHUD showError:@"不能发送为空"];
    }else if (self.model.prefixTitle != nil && self.textView.text.length == self.len && self.photosView.selectedPhotos.count == 0){
        [MBProgressHUD showError:@"不能发送为空"];
        
    }else{
        YYAccount *account = [YYAccountTool account];
        NSString *sendStr = @"http://www.sxeto.com/fruitApp/upload.php";
        NSURL *url = [NSURL URLWithString:sendStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10];
        
        request.HTTPMethod = @"POST";
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        
        if (self.model.prefixTitle == nil) {
            dic[@"mode"] = @"22";
        }else{
            dic[@"mode"] = @"221";
            dic[@"bcid"] = [NSString stringWithFormat:@"%d",self.model.bcid] ;
        }
        
        dic[@"buid"] = account.userUID;
        
        NSString *nickName = account.userNickName;
        if (nickName.length == 0) {
            nickName = account.userPhone;
        }
        
        dic[@"content"] =  self.textView.text;
        NSMutableArray *imgArray = [NSMutableArray array];
        
        for (UIImage *image in self.photosView.selectedPhotos) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
            NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [imgArray addObject:imageStr];
        }
        dic[@"imglist"] = imgArray;
        
        YYLog(@"%@",dic);
        
        NSError *error = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error) {
            YYLog(@"解析出错");
        }
        request.HTTPBody = bodyData;
        YYLog(@"%@sel",self.photosView.selectedPhotos);
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (connectionError) {
                YYLog(@"发送失败%@",connectionError);
                return ;
            }
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            YYLog(@"%@",dict);
            if ([dict[@"msg"] isEqualToString:@"ok"]) {
                //得到一个msg，和一个bcpid：帖子的id
                [MBProgressHUD showSuccess:@"发送成功"];
                self.textView.text = @"";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"writeSomething" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [MBProgressHUD showError:@"网络连接错误"];
            }
        }];

    }
  
}

//设置textView
- (void)setUpTextView{
    // 1.创建输入控件
    WYTextView *textView = [[WYTextView alloc] init];
    
    textView.alwaysBounceVertical = YES ;//垂直方向上有弹簧效果
    textView.frame = CGRectMake(YY16WidthMargin, 0, widthScreen - 2 *YY16WidthMargin, heightScreen);
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 2.设置提醒文字
    if (self.len == 0) {
        self.len = 1;
    }
    textView.placeholder = @"写点啥...";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.themeContent];
    [str  addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236/255.0 green:193/255.0 blue:41/255.0 alpha:1] range:NSMakeRange(0,self.len-1)];
    
    textView.attributedText = str;
    
    // 3.设置字体
    textView.font = [UIFont systemFontOfSize:15];
    //UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 4.监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

// 添加显示图片的相册控件
- (void)setupPhotosView {
    
    DSComposePhotosView *photosView = [[DSComposePhotosView alloc] init];
    CGRect rect = CGRectMake(0, 118/667.0*heightScreen, self.textView.frame.size.width, self.textView.frame.size.height);
    photosView.frame = rect;
    //photosView.width = self.textView.frame.size.width;
    //photosView.height = self.textView.frame.size.height;
    // photosView.y = 70;
    [photosView.addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    photosView.addButton.hidden = YES;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
    //self.photosView.backgroundColor = [UIColor blueColor];
}

- (void)addButtonClicked {
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.photosView.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    NSLog(@"button clicked");
}


#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.photosView.assetsArray = [NSMutableArray arrayWithArray:assets];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        if ([self.photosView.assetsArray count] > 0){
            
            self.photosView.addButton.hidden = NO;
        }
        [self.photosView.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//设置工具条
- (void)setUpToolBar{
    WYToolBar *toolbar = [[WYToolBar alloc] initWithFrame:CGRectMake(0, heightScreen - 44, widthScreen, 44)];
    [self.view addSubview:toolbar];
    toolbar.delegate = self;
    self.toolBar = toolbar;
}

#pragma mark - 键盘处理
/**
 *  键盘即将隐藏：工具条（toolbar）随着键盘移动
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    //需要判断是否自定义切换的键盘
    if (self.isChangingKeyboard) {
        self.ChangingKeyboard = NO;
        return;
    }
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.transform = CGAffineTransformIdentity;//回复之前的位置
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
}

#pragma mark - SWComposeToolbarDelegate
/**
 *  监听toolbar内部按钮的点击
 */
- (void)composeTool:(WYToolBar *)toolbar didClickedButton:(DSComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case DSComposeToolbarButtonTypeCamera: // 照相机
            [self openCamera];
            break;
            
        case DSComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case DSComposeToolbarButtonTypeEmotion: // 表情
            [self openEmotion];
            break;
            
        case DSComposeToolbarButtonTypeTrend:    //话题
            [self openTrend];
            
        default:
            break;
    }
}

/**
 *  打开照相机
 */
- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 *  打开相册
 */
- (void)openAlbum
{
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.photosView.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)openEmotion{
    YYLog(@"writeViewControl----------------点击表情");
    
}

- (void)openTrend{
    YYLog(@"wwriteviewcontrol -------------- 点击话题 ");
}

#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}




@end
