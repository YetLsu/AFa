//
//  YYDynamicMessageCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/20.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYDynamicMessageCell.h"
#import "YYDynamicMessageModel.h"

@interface YYDynamicMessageCell ()
@property (nonatomic, weak) UIImageView *iconImageView;

@property (nonatomic, weak) UILabel *nickNameLabel;

@property (nonatomic, weak) UILabel *dateLabel;

@property (nonatomic, weak) UILabel *dynamicMessageLabel;

@property (nonatomic, weak) UILabel *shareNumberLabel;

@property (nonatomic, weak) UILabel *zanNumberLabel;

@property (nonatomic,weak) UILabel *commentNumberLabel;

@property (nonatomic, weak) UIButton *attentionBtn;

@property (nonatomic, weak) UIView *bottomView;
//分享按钮图片，x值设置frame时设置
@property (nonatomic, weak) UIImageView *shareView;

//赞按钮图片，x值设置frame时设置
@property (nonatomic, weak) UIImageView *zanView;

@property (nonatomic, weak) UIView *imagesSuperView;

@property (nonatomic,copy) NSString *attation;

@property (nonatomic,copy) NSString *bfuid;

@property (nonatomic,assign) int bsid;//这条说说的id

@property (nonatomic,assign) NSInteger user_id;//说这条说说的用户在数据空中的id

@end

@implementation YYDynamicMessageCell
+ (instancetype)dynamicMessageCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"YYDynamicMessageCell";
    
    YYDynamicMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YYDynamicMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = 0;
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //1头像图片
        CGFloat iconImageViewW = 35/375.0*widthScreen;
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY10HeightMargin, iconImageViewW, iconImageViewW)];
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width/2.0;//设置圆的半径
        iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        //2昵称
        CGFloat nickNameX = YY16WidthMargin + iconImageViewW + YY10WidthMargin;
        CGFloat nickNameY = 12/667.0*heightScreen;
        CGFloat nickNameH = 15;
        CGFloat nickNameW = 150;
        UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickNameX, nickNameY, nickNameW, nickNameH)];
        [self.contentView addSubview:nickNameLabel];
        self.nickNameLabel = nickNameLabel;
        self.nickNameLabel.font = [UIFont systemFontOfSize:14];
        
        
        //3时间
        CGFloat dateX = nickNameX;
        CGFloat dateY = nickNameY +nickNameH + 3;
        CGFloat dateH = 14;
        CGFloat dateW = 150;
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateX, dateY, dateW, dateH)];
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        self.dateLabel.textColor = YYGrayTextColor;
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        
        //4关注按钮
        CGFloat btnX = widthScreen - YY16WidthMargin - 50;
        CGFloat btnY = YY15HeightMargin;
        CGFloat btnW = 50;
        CGFloat btnH = 25;
        UIButton *attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [attentionBtn addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:attentionBtn];
        self.attentionBtn = attentionBtn;
        [self.attentionBtn setImage:[UIImage imageNamed:@"bgq_detail_attention"] forState:UIControlStateNormal];
        [self.attentionBtn setImage:[UIImage imageNamed:@"bgq_detail_haveAttention"] forState:UIControlStateHighlighted];
        [self.attentionBtn setImage:[UIImage imageNamed:@"bgq_detail_haveAttention"] forState:UIControlStateSelected];
        
        
        //5正文label,高度在设置frame时设置
        CGFloat contentLabelX = YY16WidthMargin;
        CGFloat contentLabelY = iconImageViewW + YY10HeightMargin * 2;
        CGFloat contentLabelW = widthScreen - YY16WidthMargin * 2;
        UILabel *dynamicLabel = [[UILabel alloc] init];
        [self.contentView addSubview:dynamicLabel];
        self.dynamicMessageLabel = dynamicLabel;
        self.dynamicMessageLabel.x = contentLabelX;
        self.dynamicMessageLabel.y = contentLabelY;
        self.dynamicMessageLabel.width = contentLabelW;
        self.dynamicMessageLabel.textColor = YYGrayTextColor;
        self.dynamicMessageLabel.numberOfLines = 0;
        self.dynamicMessageLabel.font = [UIFont systemFontOfSize:15];
        
        //6图片在设置frame时动态创建
        
        //7创建下方的三个按钮的bottomView，y值在设置frame时设置
        UIView *bottomView = [[UIView alloc] init];
        [self.contentView addSubview:bottomView];
        self.bottomView = bottomView;
        self.bottomView.x = 0;
        self.bottomView.width = widthScreen;
        self.bottomView.height = 30;
        [self addSubViewOnBottomView];
        
        
    }
    return self;
}
#pragma mark重写frame的setter方法
- (void)setModel:(YYDynamicMessageModel *)model{
    _model = model;
    
    self.user_id = model.user_id;
    self.bsid = model.bsid;
    self.attation = model.attention;
    self.bfuid = model.buid;
    
    self.iconImageView.image = nil;
    self.nickNameLabel.text = nil;
    self.dateLabel.text = nil;
    self.dynamicMessageLabel.text = nil;
    [self.attentionBtn setImage:[UIImage imageNamed:@"bgq_detail_attention"] forState:UIControlStateNormal];
    [self.imagesSuperView removeFromSuperview];
    
    
    
//    self.iconImageView.image = [UIImage imageNamed:@"bgq_circle_leftTopHeadImage"];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImageUrlStr]  placeholderImage:[UIImage imageNamed:@"bgq_circle_leftTopHeadImage"] options:SDWebImageLowPriority];
    
    self.nickNameLabel.text = model.nickName;
    
    self.dateLabel.text = model.date;
    //设置关注按钮
    if ([model.attention isEqualToString:@"2"]) {//2表示自己的已关注
        self.attentionBtn.hidden = YES;
    }else{
        if ([model.attention isEqualToString:@"0"]) {//0表示未关注
            self.attentionBtn.hidden = NO;
            self.attentionBtn.selected = NO;
        }else{//表示已关注
           self.attentionBtn.hidden = NO;
            self.attentionBtn.selected = YES;
        }
        
    }
    //设置文字
    NSString *contentText = model.dynamicMessage;
    
    CGSize contentTextSize = [YYFruitTool calculateSizeWithText:contentText andFont:[UIFont systemFontOfSize:15] andSize:CGSizeMake(widthScreen - 2*YY16WidthMargin, 120)];
    
    self.dynamicMessageLabel.height = contentTextSize.height;
    self.dynamicMessageLabel.text = model.dynamicMessage;
    
    //设置图片图片的view包含了上下间距
    CGFloat superViewY = self.dynamicMessageLabel.y + self.dynamicMessageLabel.height;
    CGFloat imagesHeight = [self setImagesWithArray:model.imageUrlStrsArray andImagesSuperViewY:superViewY];
    
    self.bottomView.y = superViewY + imagesHeight;
    
    NSString *shareNumberStr = [NSString stringWithFormat:@"%ld",(long)model.shareNumber];
//    YYLog(@"%@",shareNumberStr);
    self.shareNumberLabel.text = shareNumberStr;
    CGSize shareSize = [YYFruitTool calculateSizeWithText:shareNumberStr andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    self.shareView.x = (widthScreen/3.0 - shareSize.width- 12 - 8/375.0*widthScreen)/2.0;
    self.shareNumberLabel.x = self.shareView.x + shareSize.width + 8/375.0*widthScreen;
    self.shareNumberLabel.width = shareSize.width;
    
    NSString *zanNumberStr = [NSString stringWithFormat:@"%ld",(long)model.zanNumber];
    self.zanNumberLabel.text = zanNumberStr;
    CGSize zanSize = [YYFruitTool calculateSizeWithText:zanNumberStr andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.zanView.x = (widthScreen/3.0 - zanSize.width - 12 - 8/375.0*widthScreen)/2.0;
    self.zanNumberLabel.x = self.zanView.x + zanSize.width + 8/375.0*widthScreen;
    self.zanNumberLabel.width = zanSize.width;
    
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%ld",model.commentNumber];
    
    self.rowheight = self.bottomView.y + 30;
    
    
}
-(void)receiveMessage:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    NSString *User_id = userInfo[@"attentionTag"];
    NSString *Bsid = userInfo[@"bsid"];
    NSInteger user_id = User_id.integerValue;
    NSInteger bsid = Bsid.integerValue;
    
    if (self.user_id == user_id && self.bsid != bsid) {
        self.attentionBtn.selected = !self.attentionBtn.selected;
    }
    
    //self.view.backgroundColor = userInfo[@"Color"];
    
}

#pragma mark根据数组设置图片
- (CGFloat)setImagesWithArray:(NSArray *)imageUrlStrsArray andImagesSuperViewY:(CGFloat)superViewY{
    UIView *imagesSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, superViewY, widthScreen, 0)];
    [self.contentView addSubview:imagesSuperView];
    self.imagesSuperView = imagesSuperView;
    if (imageUrlStrsArray.count == 0) {
       
        imagesSuperView.height = YY10HeightMargin;
    }
    else if (imageUrlStrsArray.count == 1) {//一张图片时高宽设为100，100
        CGFloat imageH = 125/320.0*widthScreen;
        imagesSuperView.height = imageH + YY10HeightMargin*2;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY10HeightMargin, imageH, imageH)];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = self.bsid * 100 + 0;
        [imagesSuperView addSubview:imageView];
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.frame = imageView.frame;
        Btn.tag = self.bsid *100 +10 +0;
        [Btn addTarget:self action:@selector(clickPicture:) forControlEvents:UIControlEventTouchUpInside];
        
        [imagesSuperView addSubview:Btn];
        //先显示默认图片
        [imageView sd_setImageWithURL:[imageUrlStrsArray firstObject]];
    }
    else{//图片数量大于1
        CGFloat imageW = (widthScreen - 4*YY16WidthMargin)/3.0;
        CGFloat imageH = imageW;

        if (imageUrlStrsArray.count <= 3) {
            imagesSuperView.height = YY10HeightMargin*2 + imageH;
        }
        else if (imageUrlStrsArray.count>3 &&imageUrlStrsArray.count<=6){
            imagesSuperView.height = YY10HeightMargin * 3 + 2*imageH;
        }
        else if (imageUrlStrsArray.count>6&&imageUrlStrsArray.count<=9){
            imagesSuperView.height = YY10HeightMargin * 4+ 3*imageH;
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
            imageView.tag = self.bsid*100 + i;
            [imagesSuperView addSubview:imageView];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
            Btn.frame = imageView.frame;
            Btn.tag = self.bsid *100 +10 +i;
            [Btn addTarget:self action:@selector(clickPicture:) forControlEvents:UIControlEventTouchUpInside];
            [imagesSuperView addSubview:Btn];
            
            
            NSString *urlStr = imageUrlStrsArray[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
            
        }
    }
//    YYLog(@"图片高度%f",imagesSuperView.height);
    return imagesSuperView.height;
}
#pragma mark ----- 点击图片之后的事件

- (void)clickPicture:(UIButton *)sender{
    NSInteger imageViewTag = sender.tag - 10;
    [self.delegate enlargePicture:imageViewTag];
    
}

#pragma mark底部三个按钮点击后触发的方法
- (void)shareBtnClick{
    YYLog(@"分享");
}
- (void)commentBtnClick{
    YYLog(@"评论");
    if ([self.delegate respondsToSelector:@selector(commentBtnToControllerClickWithModel:)]){
        [self.delegate commentBtnToControllerClickWithModel:self.model];

    }
    
}
- (void)zanBtnClick{
    YYLog(@"赞");
}
#pragma mark设置底部的按钮赞和转发 根据个数来
- (void)addSubViewOnBottomView{
    //加线
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(0, 0, widthScreen, 0.5) andView:self.bottomView];
    
    //设置分享，间距8
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthScreen/3.0, 30)];
    [self.bottomView addSubview:shareBtn];
    
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(widthScreen/3.0-0.5, 5, 0.5, 20) andView:shareBtn];
    CGFloat Y = 9;
    CGFloat imageW = 12;
    CGFloat imageH = 12;
    UIImageView *shareView = [[UIImageView alloc] init];
    shareView.y = Y;
    shareView.width = imageW;
    shareView.height = imageH;
    [shareBtn addSubview:shareView];
    self.shareView = shareView;
    self.shareView.image = [UIImage imageNamed:@"bgq_person_share"];
    
    UILabel *shareLabel = [[UILabel alloc] init];
    [shareBtn addSubview:shareLabel];
    self.shareNumberLabel = shareLabel;
    self.shareNumberLabel.y = Y;
    self.shareNumberLabel.height = 12;
    self.shareNumberLabel.font = [UIFont systemFontOfSize:14];
    self.shareNumberLabel.textColor = YYGrayTextColor;
    
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //设置评论

    CGSize commentSize = [YYFruitTool calculateSizeWithText:@"评论" andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(widthScreen/3.0, 0, widthScreen/3.0, 30)];
    [self.bottomView addSubview:commentBtn];
    
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(widthScreen/3.0-0.5, 5, 0.5, 20) andView:commentBtn];
    
    UIImageView *commentView = [[UIImageView alloc] init];
    commentView.x = (widthScreen/3.0 - commentSize.width-imageW - 8/375.0*widthScreen)/2.0;
    commentView.y = Y;
    commentView.width = imageW;
    commentView.height = imageH;
    [commentBtn addSubview:commentView];
    commentView.image = [UIImage imageNamed:@"bgq_detail_comment"];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentView.x + commentView.width + 8/375.0*widthScreen, Y, commentSize.width, imageH)];
    //commentLabel.text = @"评论";
    commentLabel.font = [UIFont systemFontOfSize:14];
    commentLabel.textColor = YYGrayTextColor;
    [commentBtn addSubview:commentLabel];
    self.commentNumberLabel = commentLabel;
    
    [commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //设置赞
    UIButton *zanBtn = [[UIButton alloc] initWithFrame:CGRectMake(widthScreen/3.0 * 2, 0, widthScreen/3.0, 30)];
    [self.bottomView addSubview:zanBtn];
    
    UIImageView *zanView = [[UIImageView alloc] init];
    zanView.image = [UIImage imageNamed:@"bgq_zan"];
    zanView.y = Y;
    zanView.width = imageW;
    zanView.height = imageH;
    [zanBtn addSubview:zanView];
    self.zanView = zanView;
    
    UILabel *zanLabel = [[UILabel alloc] init];
    [zanBtn addSubview:zanLabel];
    self.zanNumberLabel = zanLabel;
    self.zanNumberLabel.y = Y;
    self.zanNumberLabel.height = 12;
    self.zanNumberLabel.font = [UIFont systemFontOfSize:14];
    self.zanNumberLabel.textColor = YYGrayTextColor;
    
    [zanBtn addTarget:self action:@selector(zanBtnClick) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark ----- 关注按钮的点击

- (void)clickAttention:(UIButton *)sender{
    YYLog(@"关注");
    if (sender.selected == YES) {
        YYLog(@"取消关注");
        sender.selected = NO;
//        if ([self.delegate respondsToSelector:@selector(pushControllerWithController:)]) {
//            [self.delegate pushControllerWithController:dataile];
//        }else{
//            
//        }
        [self.delegate attationBtnQuGuanWith:self.attation bfuid:self.bfuid];
    }else{
        YYLog(@"关注");
        sender.selected = YES;
        [self.delegate attationBtnGuanZhuWith:self.attation bfuid:self.bfuid];

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
