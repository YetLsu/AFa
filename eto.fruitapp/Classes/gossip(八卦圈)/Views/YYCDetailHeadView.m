//
//  YYCDetailHeadView.m
//  圈子_V1
//
//  Created by Apple on 15/12/19.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCDetailHeadView.h"
#import "YYDynamicMessageModel.h"

#define YY5HeightMargin 5/667.0*heightScreen

@interface YYCDetailHeadView ()

@property (nonatomic,weak)UILabel *nameLabel;//用户名
@property (nonatomic,weak)UILabel *timeLabel;//时间
@property (nonatomic,weak)UILabel *contentLabel;//内容
//@property (nonatomic,weak)UILabel *themeLabel;//主题
@property (nonatomic,weak)UIView *picsView;//图片

@property (nonatomic,assign) CGFloat y;

@property (nonatomic,weak) UIButton *attention;//关注

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic,copy) NSString *attaionFlag;//关注的状态

@property (nonatomic,copy) NSString *bfuid;//需要关注或者取消关注的那个人的id


@end

@implementation YYCDetailHeadView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //修改
        //用户头像
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame = CGRectMake(YY16WidthMargin, YY10HeightMargin, 35/375.0*widthScreen, 35/667.0*heightScreen);
        
        [headBtn addTarget:self action:@selector(clickHeadViewPic:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:headBtn];
        self.goToPersonBtn = headBtn;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:headBtn.bounds];
        [headBtn addSubview:iconView];
        
        iconView.layer.cornerRadius = iconView.frame.size.width/2.0;//设置圆的半径
        iconView.layer.masksToBounds = YES;
        self.iconView = iconView;
        self.y = headBtn.frame.origin.y + headBtn.frame.size.height;
        
        //修改
        //用户名
        UILabel *namelb = [[UILabel alloc] initWithFrame:CGRectMake(headBtn.frame.origin.x + headBtn.frame.size.width + YY10WidthMargin, YY15HeightMargin, widthScreen - (headBtn.frame.origin.x + headBtn.frame.size.width + YY10WidthMargin + YY16WidthMargin), 12)];
        namelb.font = [UIFont systemFontOfSize:12];
        [self addSubview:namelb];
        self.nameLabel = namelb;
        
        //时间
        UILabel *timelb = [[UILabel alloc] initWithFrame:CGRectMake(namelb.frame.origin.x, namelb.frame.origin.y + YY10HeightMargin+namelb.frame.size.height, namelb.frame.size.width, 10)];
        timelb.font = [UIFont systemFontOfSize:10];
        timelb.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
        [self addSubview:timelb];
        self.timeLabel = timelb;
        
#pragma mark ----- 关注按钮
        UIButton *isAttation = [UIButton buttonWithType:UIButtonTypeCustom];
        isAttation.frame = CGRectMake(widthScreen - YY16WidthMargin - 50/375.0*widthScreen, YY10HeightMargin*2, 50/375.0*widthScreen, 25/667.0*heightScreen);
        [isAttation setImage:[UIImage imageNamed:@"bgq_detail_attention"] forState:UIControlStateNormal];
        [isAttation setImage:[UIImage imageNamed:@"bgq_detail_haveAttention"] forState:UIControlStateHighlighted];
        [isAttation setImage:[UIImage imageNamed:@"bgq_detail_haveAttention"] forState:UIControlStateSelected];
        [isAttation addTarget:self action:@selector(clickAtt:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:isAttation];
        self.attention = isAttation;
    }
    return self;
}

- (void)setModel:(YYDynamicMessageModel *)model{
    _model = model;
    YYDynamicMessageModel *model1 = model;
    //设置内容的label
    NSString *tempContent = model1.dynamicMessage;
    //得到内容的尺寸
    CGSize size1 = [tempContent boundingRectWithSize:CGSizeMake((widthScreen - 2*YY16WidthMargin), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    //设置内容的label
    UILabel *contentlb = [[UILabel alloc] initWithFrame:CGRectMake(YY16WidthMargin, self.y+YY10HeightMargin, size1.width, size1.height)];
    contentlb.textColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1];
    contentlb.numberOfLines = 0;
    contentlb.font = [UIFont systemFontOfSize:14];
    [self addSubview:contentlb];
    self.contentLabel = contentlb;
//设置打开时的关注状态
    if ([model.attention isEqualToString:@"2"]) {//2表示自己的已关注
        self.attention.hidden = YES;
    }else{
        if ([model.attention isEqualToString:@"0"]) {//0表示未关注
            self.attention.hidden = NO;
            self.attention.selected = NO;
        }else{//表示已关注
            self.attention.hidden = NO;
            self.attention.selected = YES;
        }
        
    }
    
    
    
    
//    NSInteger number = model1.imageUrlStrsArray.count;
//    if (number > 9) {
//        number = 9;
//    }
    UIView *picV = [[UIView alloc] initWithFrame:CGRectMake(0, contentlb.frame.origin.y + contentlb.frame.size.height , widthScreen, YY16WidthMargin)];;
    [self addSubview:picV];
    NSArray *imageUrlStrsArray = model1.imageUrlStrsArray;
    if (imageUrlStrsArray.count == 0) {
        
        picV.height = YY10HeightMargin;
    }
    else if (imageUrlStrsArray.count == 1) {//一张图片时高宽设为100，100
        CGFloat imageH = 125/320.0*widthScreen;
        picV.height = imageH + YY10HeightMargin*2;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY10HeightMargin, imageH, imageH)];
        imageView.tag = 60;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [picV addSubview:imageView];
        
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.frame = imageView.frame;
        Btn.tag = 100 +60 ;
        
        [Btn addTarget:self action:@selector(clickPicture:) forControlEvents:UIControlEventTouchUpInside];
        [picV addSubview:Btn];
        //先显示默认图片
    
        [imageView sd_setImageWithURL:[imageUrlStrsArray firstObject]];
    }
    else{//图片数量大于1
        CGFloat imageW = (widthScreen - 4*YY16WidthMargin)/3.0;
        CGFloat imageH = imageW;
        
        if (imageUrlStrsArray.count <= 3) {
            picV.height = YY10HeightMargin*2 + imageH;
        }
        else if (imageUrlStrsArray.count>3 &&imageUrlStrsArray.count<=6){
            picV.height = YY10HeightMargin * 3 + 2*imageH;
        }
        else if (imageUrlStrsArray.count>6&&imageUrlStrsArray.count<=9){
            picV.height = YY10HeightMargin * 4+ 3*imageH;
        }
        CGFloat imageX = 0;
        CGFloat imageY = 0;
        CGFloat line = 0;//第几行
        CGFloat column = 0;//第几列
        for (int i = 0; i < imageUrlStrsArray.count; i++) {
            line = i /3;
            column = i%3;
            imageX = YY16WidthMargin + column*(imageW + YY16WidthMargin);
            imageY = YY10HeightMargin + (imageH + YY10HeightMargin) *line;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
            imageView.image = [UIImage imageNamed:@"bgq_detail_picture"];
            [picV addSubview:imageView];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = 60 + i;
            
            UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Btn.frame = imageView.frame;
            Btn.tag = 100 + 60 +i;
            [Btn addTarget:self action:@selector(clickPicture:) forControlEvents:UIControlEventTouchUpInside];
            [picV addSubview:Btn];
            
            NSString *urlStr = imageUrlStrsArray[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
            
        }
    }

    //赋值
    self.viewHeight = picV.frame.origin.y + picV.frame.size.height;
        //修改

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model1.iconImageUrlStr] placeholderImage:[UIImage imageNamed:@"bgq_circle_leftTopHeadImage"]];

//    [self.leftBtn setIm]
   // self.leftImageView.image = [UIImage imageNamed:model1.leftImageName];
    self.nameLabel.text = model1.nickName;
    self.timeLabel.text = model1.date;
    //self.themeLabel.text = tempTheme;
    self.contentLabel.text = tempContent;
    
    self.attaionFlag = model1.attention;
    self.bfuid = model1.buid;
    
}

- (void)clickPicture:(UIButton *)sender{
    NSInteger imageViewTag = sender.tag - 100;
    if ([self.delegate respondsToSelector:@selector(enlargePicture:)]) {
        [self.delegate enlargePicture:imageViewTag];
    }
    
}



//修改
- (void)clickHeadViewPic:(UIButton *)sender{
    [self.delegate pushToPersonViewControl:self.model];
}

- (void)clickAtt:(UIButton *)sender{
    YYLog(@"关注");
    if (sender.selected == YES) {
        YYLog(@"取消关注");
        sender.selected = NO;
        [self.delegate attationBtnQuGuanWith:self.attaionFlag bfuid:self.bfuid];
    }else{
        YYLog(@"关注");
        sender.selected = YES;
        [self.delegate attationBtnGuanZhuWith:self.attaionFlag bfuid:self.bfuid];
    }

}



@end
