//
//  YYCircleTableViewCell2.m
//  圈子_V1
//
//  Created by Apple on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCircleTableViewCell2.h"
#import "YYCircleModel.h"
#import "UIImageView+WebCache.h"
#import "YYAccountTool.h"


#define YY16WidthMargin 16/375.0*widthScreen
#define YY10WidthMargin 10/375.0*widthScreen
#define YY5HeightMargin 5/667.0*heightScreen
#define YY10HeightMargin 10/667.0*heightScreen
#define YY15HeightMargin 15/667.0*heightScreen
#define widthScreen [UIScreen mainScreen].bounds.size.width //屏幕宽
#define heightScreen [UIScreen mainScreen].bounds.size.height //屏幕高
@interface YYCircleTableViewCell2 ()
@property (nonatomic,weak) UIImageView *leftImageView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *replyLabel;
@property (nonatomic,weak) UILabel *contentLabel;
@property (nonatomic,weak) UILabel *joinAndReadLabel;
@property (nonatomic,weak) UIButton *addButton;
//其他属性
@property (nonatomic,copy) NSString *titleT;
/** 圈子的ID bcid */
@property (nonatomic,assign) int bcid;


@end
@implementation YYCircleTableViewCell2
//获取可变的标题的内容
- (NSString *)title{
    _titleT = [NSString stringWithFormat:@"#%@#", self.model.prefixTitle];
    return _titleT;
    
}



+ (id)circleTableViewUn:(UITableView *)tableView{
    //static NSString *ID = @"cell2";
    YYCircleTableViewCell2 *cell = [[YYCircleTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //左图
        UIImageView *leftIV = [[UIImageView alloc] init];
        leftIV.backgroundColor = [UIColor yellowColor];
        leftIV.frame = CGRectMake(YY16WidthMargin, YY10WidthMargin, 60/375.0*widthScreen, 60/667.0*heightScreen);
        [self.contentView addSubview:leftIV];
        self.leftImageView = leftIV;
        
        
        //描述性内容
        UILabel *contentlb = [[UILabel alloc] init];
        contentlb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin, 18/667.0*heightScreen + 13 + YY5HeightMargin, 370/2/375.0*widthScreen, 12);
        contentlb.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
        contentlb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:contentlb];
        self.contentLabel = contentlb;
        
        //参与阅读
        UILabel *joinAndreadlb = [[UILabel alloc] init];
        joinAndreadlb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin, 18/667.0*heightScreen + 13 + YY5HeightMargin +12 +YY5HeightMargin, 370/2/375.0*widthScreen, 10);
        joinAndreadlb.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
        joinAndreadlb.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:joinAndreadlb];
        self.joinAndReadLabel = joinAndreadlb;
        
        //加入的按钮
        UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        joinBtn.frame = CGRectMake(widthScreen - 128/2 - YY16WidthMargin, 18/667.0*heightScreen + 13 + YY5HeightMargin, 128/2/375.0*widthScreen, 29/667.0*heightScreen);
        //[joinBtn setBackgroundColor:[UIColor yellowColor]];
        
        [joinBtn setImage:[UIImage imageNamed:@"bgq_circle_joinCircle"] forState:UIControlStateNormal];
        [joinBtn setImage:[UIImage imageNamed:@"bgq_circle_joinCircle"] forState:UIControlStateHighlighted];
        [joinBtn setImage:[UIImage imageNamed:@"bgq_circle_HavejoinCircle"] forState:UIControlStateSelected];
        
        [self.contentView addSubview:joinBtn];
        [joinBtn addTarget:self action:@selector(clickAddCircle:) forControlEvents:UIControlEventTouchUpInside];
        self.addButton = joinBtn;
        
        
        //设置cell的高度
        self.cellRowHeight = self.leftImageView.frame.size.height + 2*YY10WidthMargin;
    }
    return self;
}

- (void)setModel:(YYCircleModel *)model{
    _model = model;
    NSURL *iconURLStr = [NSURL URLWithString:_model.leftImageName];
    
    [self.leftImageView sd_setImageWithURL:iconURLStr placeholderImage:[UIImage imageNamed:@"bgq_circle_headImage"]];
    YYLog(@"%@",_model.leftImageName);
    //self.leftImageView.image = [UIImage imageNamed:_model.leftImageName];
    self.titleT = [NSString stringWithFormat:@"#%@#",_model.prefixTitle];
    
    //前缀的标题
    UILabel *titlelb = [[UILabel alloc] init];
    CGSize size1 = [self.titleT boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
//    YYLog(@"A------------%f",size1.width);
    if (size1.width > (394/2)/375.0*widthScreen) {
        size1.width = (394/2)/375.0*widthScreen;
    }
//    YYLog(@"B------------%f",size1.width);
    titlelb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin, 18/667.0*heightScreen, size1.width, 13);
    titlelb.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titlelb];
    self.titleLabel = titlelb;
    
    //回复数
    UILabel *replylb = [[UILabel alloc] init];
    replylb.frame = CGRectMake(YY16WidthMargin + 60/375.0*widthScreen + YY10WidthMargin +size1.width+5,18/667.0*heightScreen+13 - 10 , 65/375.0*widthScreen, 9);
    replylb.textColor = [UIColor colorWithRed:181/255.0 green:151/255.0 blue:39/255.0 alpha:1];
//    YYLog(@"c----------%f",replylb.frame.origin.x);
    replylb.font = [UIFont systemFontOfSize:8];
    [self.contentView addSubview:replylb];
    self.replyLabel = replylb;
    
    self.titleLabel.text = self.titleT;
    self.replyLabel.text = [NSString stringWithFormat:@"今日：%ld",(long)_model.replyNumber];
    self.contentLabel.text = _model.content;
    self.joinAndReadLabel.text = [NSString stringWithFormat:@"%ld人参与丨%ld 阅读",(long)_model.joinNumber,(long)_model.readNumber];
    
    self.bcid = model.bcid;
    
        if (model.join == NO  ) {//0表示未关注
            self.addButton.hidden = NO;
        }else{//表示已关注
            self.addButton.hidden = NO;
            self.addButton.selected = YES;
        }
    

}

- (void)clickAddCircle:(UIButton *)sender{
#warning 添加添加圈的方法
    YYLog(@"加入圈");
    if (sender.selected == YES) {
        YYLog(@"取消关注");
        sender.selected = NO;
        [self.delegate quitCircle:self.bcid];
    }else{
        YYLog(@"关注");
        sender.selected = YES;
        [self.delegate joinToCircle:self.bcid];
    }
    
    
//    YYAccount *account = [YYAccountTool account];
//    NSString *urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=24&buid=%@&bcuid=%d&flag=0",account.userUID,self.bcid];
//    YYLog(@"%@",urlStr);
//    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        YYLog(@"%@",responseObject);
//        YYLog(@"取消关注成功");
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        YYLog(@"取消关注失败");
//    }];

    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
