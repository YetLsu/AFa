//
//  YYSuggestController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/3.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSuggestController.h"

@interface YYSuggestController ()<UITextViewDelegate>
@property(nonatomic, weak) UILabel *placeholder;

@property (nonatomic, weak) UITextView *textView;

@property (nonatomic, weak) UITextField *phoneField;

@end

@implementation YYSuggestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YYViewBGColor;
    self.title = @"意见反馈";
    
    //增加textView
    [self addMyTextView];
    
    //添加发送
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
   
    //添加手机号UITextField
    self.phoneField = [self addFieldWithFrame:CGRectMake(16, 16 + 250 + 16, 375 - 32, 35)];
    
    //添加客服电话label
    UILabel *serviceLabel = [[UILabel alloc] init];
    [serviceLabel setViewFrame:CGRectMake(16, 16 + 250 +16 + 35 + 10, 70, 20)];
    serviceLabel.text = @"客服电话:";
    
    serviceLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:serviceLabel];
    
    //增加电话按钮
    NSString *phone = @"60000000000";
    UIButton *servicePhoneBtn = [[UIButton alloc] init];
    servicePhoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    CGSize phoneSize = [phone boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    [servicePhoneBtn setViewFrame:CGRectMake(16 + 70 + 5, 16 + 250 +16 + 35 + 10, phoneSize.width, 20)];
    [self.view addSubview:servicePhoneBtn];
    
    [servicePhoneBtn setTitleColor:[UIColor colorWithRed:0 green:1/255.0 blue:179/255.0 alpha:1] forState:UIControlStateNormal];
    [servicePhoneBtn setTitle:phone forState:UIControlStateNormal];
    [servicePhoneBtn addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加下面的label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    [label setViewFrame:CGRectMake(16, 16 + 250 +16 + 35 + 10 + 20 + 10, 375 - 16, 20)];
    [self.view addSubview:label];
    label.text = @"相信有了您的支持，我们异地过会做的更好";
    label.textColor = YYGrayTextColor;
}
/**
 *  号码被点击
 *
 */
- (void)phoneClick{
    YYLog(@"打电话");
}
/**
 *  添加手机号UITextField
 */
- (UITextField *)addFieldWithFrame:(CGRect)fieldFrame{
    UITextField *field = [[UITextField alloc] init];
    field.backgroundColor = [UIColor whiteColor];
    [field setViewFrame:fieldFrame];
    [self.view addSubview:field];
    field.placeholder = @"手机或QQ（选填）";
    
    
    UIView *view = [[UIView alloc] init];
    [view setViewFrame:CGRectMake(0, 0, 10, 35)];
    field.leftViewMode = UITextFieldViewModeAlways;
    field.leftView = view;
    
    return field;
}
/**
 *  点击发送按钮
 *
 */
- (void)sendClick{
    YYLog(@"发送");
}
/**
 *  增加textView
 */
- (void)addMyTextView{
    UITextView *textView = [[UITextView alloc] init];
    [textView setViewFrame:CGRectMake(16, 16, 375 - 32, 250)];
    self.textView = textView;
    [self.view addSubview:textView];
    self.textView = textView;
    
    textView.font = [UIFont systemFontOfSize:17];
    textView.scrollEnabled = NO;
    textView.textAlignment = NSTextAlignmentLeft;
    
    textView.delegate = self;
    
    // 添加一个label显示placephlodr;当无内容时显示
    UILabel *placeholder = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, widthScreen, 30)];
    [placeholder setFrame:CGRectMake(16, 16, widthScreen - 32, 35)];
    placeholder.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:placeholder];
    self.placeholder = placeholder;
    self.placeholder.text = @" 请在这里写下对阿发app的意见";
    self.placeholder.textColor = YYGrayLineColor;

}
/**
 *  当textField内容改变时
 *
 */
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        self.placeholder.hidden = NO;
        return;
    }
    self.placeholder.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
