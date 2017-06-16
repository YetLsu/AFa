//
//  YYAddAddressController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/3.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYAddAddressController.h"

@interface YYAddAddressController ()
@property (nonatomic, weak) UITextField *contactField;//联系人
@property (nonatomic, weak) UIButton *manBtn;//选先生，tag为0
@property (nonatomic, weak) UIButton *womanBtn;//选女士，tag为1
@property (nonatomic, weak) UITextField *phoneField;//手机号码
@property (nonatomic, weak) UITextField *probablyAddressField;//大概的地址
@property (nonatomic, weak) UITextField *specificAddressField;//具体的地址门牌号

@end

@implementation YYAddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增收货地址";
    self.view.backgroundColor = YYViewBGColor;
    
    //添加输入内容的view
    [self addContentViewWithFrame:CGRectMake(0, 10, widthScreen, 240)];
    
    //添加保存按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 270, widthScreen - 30, 42)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_yellowbg"] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
}

- (void)addContentViewWithFrame:(CGRect)viewFrame{
    UIView *contentView = [[UIView alloc] initWithFrame:viewFrame];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat headerMargin = 25/375.0 *widthScreen;
    CGFloat lineMargin = 15/375.0 * widthScreen;
    CGFloat height = 48;
    
    //增加联系人输入框
    self.contactField = [self textFieldWithLabelTitle:@"联系人:" andplaceholder:@"请填写收货人的姓名" andFrame:CGRectMake(headerMargin, 0, widthScreen - headerMargin, height) andSuperView:contentView];
    
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(headerMargin + 64 , 48, widthScreen - headerMargin - 64 - 16, 0.5) andView:contentView];
    
    //添加选择性别的单元格
    self.manBtn = [self sexBtnWithTitle:@"先生" andFrame:CGRectMake(headerMargin + 64, 58, 65, 48)];
    self.manBtn.tag = 0;
    self.womanBtn = [self sexBtnWithTitle:@"女士" andFrame:CGRectMake(headerMargin + 64 + 65 + 10, 58, 65, 48)];
    self.womanBtn.tag = 1;
    
    [[YYFruitTool shareFruitTool]addLineViewWithFrame:CGRectMake(lineMargin, height * 2, widthScreen - lineMargin * 2, 0.5) andView:contentView];
    
    //添加手机号码输入框
    self.phoneField = [self textFieldWithLabelTitle:@"手机号码:" andplaceholder:@"请填写收货手机号码" andFrame:CGRectMake(headerMargin, height * 2, widthScreen - headerMargin, height) andSuperView:contentView];
    
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(lineMargin, height * 3, widthScreen - lineMargin * 2, 0.5) andView:contentView];
    
    self.probablyAddressField = [self textFieldWithLabelTitle:@"收货地址:" andplaceholder:@"学校、写字楼、小区、街道" andFrame:CGRectMake(headerMargin, height * 3, widthScreen - headerMargin, height) andSuperView:contentView];
    
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(lineMargin, height * 4, widthScreen - lineMargin * 2, 0.5) andView:contentView];
    
    self.specificAddressField = [self textFieldWithLabelTitle:nil andplaceholder:@"门牌号、楼号等详细信息" andFrame:CGRectMake(headerMargin, height * 4, widthScreen - headerMargin, height) andSuperView:contentView];
}

/**
 *  添加输入框
 *
 */
- (UITextField *)textFieldWithLabelTitle:(NSString *)labelTitle andplaceholder:(NSString *)placeholder andFrame:(CGRect)viewFrame andSuperView:(UIView *)superView{
    UIView *labelFieldView = [[UIView alloc] initWithFrame:viewFrame];
    [superView addSubview:labelFieldView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, viewFrame.size.height)];
    label.text = labelTitle;
    [labelFieldView addSubview:label];
    
    UITextField *contactField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, widthScreen - 80 - 25/375.0 *widthScreen, viewFrame.size.height)];
    contactField.placeholder = placeholder;
    [labelFieldView addSubview:contactField];
    self.contactField = contactField;

    return contactField;
}
/**
 *  添加选择性别按钮和label
 *
 */
- (UIButton *)sexBtnWithTitle:(NSString *)title andFrame:(CGRect)btnSuperViewFrame{
    UIView *btnSuperView = [[UIView alloc] initWithFrame:btnSuperViewFrame];
    [self.view addSubview:btnSuperView];
    
    //添加按钮图标
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 14, 20, 20)];
    [btnSuperView addSubview:btn];
    
    [btn setImage:[UIImage imageNamed:@"profile_noSelect"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"profile_select"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(selectSexWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 40, 48)];
    label.text = title;
    
    [btnSuperView addSubview:label];
    
    return btn;
}
/**
 *  选择性别
 */
- (void)selectSexWithBtn:(UIButton *)btn{
    if (btn.tag == 0) {
        self.manBtn.selected = !self.manBtn.selected;
        self.womanBtn.selected = NO;
    }
    else if (btn.tag == 1){
        self.womanBtn.selected = !self.womanBtn.selected;
        self.manBtn.selected = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
