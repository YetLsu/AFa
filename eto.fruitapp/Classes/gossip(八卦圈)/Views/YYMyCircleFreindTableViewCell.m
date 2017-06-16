//
//  YYMyCircleFreindTableViewCell.m
//  圈子_V1
//
//  Created by Apple on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYMyCircleFreindTableViewCell.h"
#import "YYMyCircleFriendModel.h"
#import "UIImageView+WebCache.h"


#define YY16WidthMargin 16/375.0*widthScreen
#define YY10HeightMargin 10/667.0*heightScreen
#define YY10WidthMargin 10/375.0*widthScreen
#define YY15HeightMargin 15/667.0*heightScreen
#define widthScreen [UIScreen mainScreen].bounds.size.width //屏幕宽
#define heightScreen [UIScreen mainScreen].bounds.size.height //屏幕高

#define YY108color [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1]

@interface YYMyCircleFreindTableViewCell ()<UIAlertViewDelegate>
@property (nonatomic,weak) UIImageView *leftImageView;
@property (nonatomic,weak) UILabel *userNameLB;
@property (nonatomic,weak) UILabel *contentLB;
@property (nonatomic,weak) UIButton *attentionBtn;//关注按钮


@property (nonatomic,strong) NSString *attation;

@property (nonatomic,strong) NSString *bfuid;


@end

@implementation YYMyCircleFreindTableViewCell


+(id)myCircleFreindTableViewCellWiThTableView:(UITableView *)tableView{
     static NSString *indenti = @"YYMyCircleFreindTableViewCell";
    YYMyCircleFreindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenti];
    if (!cell) {
        cell = [[YYMyCircleFreindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenti];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //左上的头像
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY10HeightMargin, 55/375.0*widthScreen, 55/667.0*heightScreen)];
        leftImageView.layer.cornerRadius = leftImageView.frame.size.width/2.0;//设置圆的半径
        leftImageView.layer.masksToBounds = YES;
        
        
        [self.contentView addSubview:leftImageView];
        self.leftImageView = leftImageView;
        
        //用户名
        UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(leftImageView.frame.origin.x +leftImageView.frame.size.width + YY10WidthMargin, YY15HeightMargin, widthScreen - (leftImageView.frame.origin.x +leftImageView.frame.size.width + YY10WidthMargin + 100/375.0*widthScreen), 12)];
        userName.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:userName];
        self.userNameLB = userName;
        
        
        //内容
        UILabel *contentlb = [[UILabel alloc] initWithFrame:CGRectMake(userName.frame.origin.x, userName.frame.origin.y + userName.frame.size.height + YY10HeightMargin, 192/375.0*widthScreen, 27)];
        contentlb.font = [UIFont systemFontOfSize:11];
        contentlb.numberOfLines = 0;
        contentlb.textColor = YY108color;
        [self.contentView addSubview:contentlb];
        self.contentLB = contentlb;
        
        //是否关注
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(widthScreen - YY16WidthMargin - 50/375.0*widthScreen, 28/667.0*heightScreen, 50/375.0*widthScreen, 25/667.0*heightScreen);
        [button setImage:[UIImage imageNamed:@"bgq_detail_attention"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"bgq_detail_haveAttention"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        self.attentionBtn = button;
        //[UIImage imageNamed:@"bgq_detail_attention"]//100*50加关注
        //[UIImage imageNamed:@"bgq_detail_haveAttention"]//100*50已关注
    }

    return self;
}


- (void)setModel:(YYMyCircleFriendModel *)model{
    YYMyCircleFriendModel *model1 = model;
    self.rowHeight = self.contentLB.frame.origin.y + self.contentLB.frame.size.height + 5/667.0*heightScreen;
    //YYPersonCellModel *model = self.modelArrays[indexPath.row];
    //头像设置
    self.leftImageView.image = [UIImage imageNamed:model1.leftImageStr];
    NSURL *iconURLStr = [NSURL URLWithString:model.leftImageStr];
    
    [self.leftImageView sd_setImageWithURL:iconURLStr placeholderImage:[UIImage imageNamed:@"bgq_circle_headImage"]];
    
    
    
    self.userNameLB.text = model1.friendName;
    self.contentLB.text = model1.contentStr;
    self.bfuid = model1.buid;
    //设置关注按钮
    if ([model.attention isEqualToString:@"2"]) {//2表示自己的已关注
        self.attentionBtn.hidden = YES;
    }else{
        if ([model.attention isEqualToString:@"0"]) {//0表示未关注
            self.attentionBtn.hidden = NO;
        }else{//表示已关注
            self.attentionBtn.hidden = NO;
            self.attentionBtn.selected = YES;
        }
        
    }
    
    
}

- (void)clickAttention:(UIButton *)sender{
    YYLog(@"关注");
    if (sender.selected == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"是否取消对这位圈友的关注" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是的", nil];
        //显示出来
        [alertView show];
       
    }else{
        YYLog(@"关注");
        sender.selected = YES;
        [self.delegate attationBtnGuanZhuWith:self.attation bfuid:self.bfuid];
    }
}

#pragma mark ----- 弹出框的协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        YYLog(@"取消关注");
        self.attentionBtn.selected = NO;
        [self.delegate attationBtnQuGuanWith:self.attation bfuid:self.bfuid];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
