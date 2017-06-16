//
//  YYAddRemarksController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/17.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYAddRemarksController.h"

@interface YYAddRemarksController ()<UITextViewDelegate>
@property(nonatomic, strong)UILabel *placephlodr;

@property (nonatomic, weak) UITextView *textView;
@end

@implementation YYAddRemarksController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(previousVC)];
    
    self.view.backgroundColor = YYGrayColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加UITextView
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 74, widthScreen, 100)];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    self.textView = textView;
    
    textView.font = [UIFont systemFontOfSize:17];
    textView.scrollEnabled = NO;
    textView.textAlignment = NSTextAlignmentLeft;
    
    textView.delegate = self;
    
    // 添加一个label显示placephlodr;当无内容时显示
    self.placephlodr = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, widthScreen, 30)];
    self.placephlodr.text = @"  给商家留言";
    self.placephlodr.textColor = YYGrayLineColor;
    [self.view addSubview:self.placephlodr];
   
    
    //添加保存按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 190, 345, 40)];
    [self.view addSubview:btn];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:22];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"11"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveMessage) forControlEvents:UIControlEventTouchUpInside];
}
- (void)previousVC{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击确定
- (void)saveMessage{
   
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        self.placephlodr.hidden = NO;
        return;
    }
    self.placephlodr.hidden = YES;
}

@end
