//
//  YYCirclePersonTableViewCell.m
//  圈子_V1
//
//  Created by Apple on 15/12/18.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCirclePersonTableViewCell.h"
#import "YYPersonCellModel.h"
#import "YYFruitTool.h"

#define YY16WidthMargin 16/375.0*widthScreen
#define YY10WidthMargin 10/375.0*widthScreen
#define YY5HeightMargin 5/667.0*heightScreen
#define YY10HeightMargin 10/667.0*heightScreen
#define YY15HeightMargin 15/667.0*heightScreen
#define widthScreen [UIScreen mainScreen].bounds.size.width //屏幕宽
#define heightScreen [UIScreen mainScreen].bounds.size.height //屏幕高
#define YYthemecolor [UIColor colorWithRed:236/255.0 green:195/255.0 blue:47/255.0 alpha:0.8]

@interface YYCirclePersonTableViewCell ()
@property (nonatomic,weak)UIImageView *leftImageView;//头像
@property (nonatomic,weak)UILabel *nameLabel;//用户名
@property (nonatomic,weak)UILabel *timeLabel;//时间
@property (nonatomic,weak)UILabel *contentLabel;//内容
@property (nonatomic,weak)UILabel *themeLabel;//主题
@property (nonatomic,weak)UIView *picsView;//图片

@property (nonatomic,weak)UIButton *shareButton;//分享按钮
@property (nonatomic,weak)UIButton *commentButton;//评论按钮
@property (nonatomic,weak)UIButton *zanButton;//赞按钮

@property (nonatomic,weak)UILabel *shareLabelNumber;//分享数的label
@property (nonatomic,weak)UIImageView *zanImageView;//赞的图
@property (nonatomic,weak)UILabel *zanLabelNumber;//赞的数目


//设置一个全局的值
@property (nonatomic,assign) CGFloat y;//高度


@end
@implementation YYCirclePersonTableViewCell

+(id)circlePersonTableViewCell:(UITableView *)tableView{
    static NSString *indenti = @"Cell";
    YYCirclePersonTableViewCell *cell = [[YYCirclePersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenti];
        return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //用户头像
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin, YY10HeightMargin, 35/375.0*widthScreen, 35/667.0*heightScreen)];
        [self.contentView addSubview:headImageView];
        self.leftImageView = headImageView;
        self.y = headImageView.frame.origin.y + headImageView.frame.size.height;
        
        //用户名
        UILabel *namelb = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.frame.origin.x + headImageView.frame.size.width + YY10WidthMargin, YY15HeightMargin, widthScreen - (headImageView.frame.origin.x + headImageView.frame.size.width + YY10WidthMargin + YY16WidthMargin), 12)];
        namelb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:namelb];
        self.nameLabel = namelb;
        
        //时间
        UILabel *timelb = [[UILabel alloc] initWithFrame:CGRectMake(namelb.frame.origin.x, namelb.frame.origin.y + YY10HeightMargin+namelb.frame.size.height, namelb.frame.size.width, 10)];
        timelb.font = [UIFont systemFontOfSize:10];
        timelb.textColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
        [self.contentView addSubview:timelb];
        self.timeLabel = timelb;
        
        
    }
    return self;
}

- (void)setModel:(YYPersonCellModel *)model{
    YYPersonCellModel *model1 = model;
    
    //主题
    NSString *tempTheme = [NSString stringWithFormat:@"#%@#",model1.theme];
    NSInteger len1 = tempTheme.length;
    NSString *tempContent = [NSString stringWithFormat:@"%@%@",tempTheme,model.content];
#pragma mark ----- 同一个label不同的颜色
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tempContent];
    

    //得到内容的尺寸
    CGSize size1 = [tempContent boundingRectWithSize:CGSizeMake((widthScreen - 2*YY16WidthMargin), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
    //设置内容的label
    UILabel *contentlb = [[UILabel alloc] initWithFrame:CGRectMake(YY16WidthMargin, self.y+YY10HeightMargin, size1.width, size1.height)];
        contentlb.numberOfLines = 0;
    contentlb.font = [UIFont systemFontOfSize:13];
    //设置字的颜色
    [str addAttribute:NSForegroundColorAttributeName value:YYthemecolor range:NSMakeRange(0,len1)];
    
    contentlb.attributedText = str;
    
    [self.contentView addSubview:contentlb];
    self.contentLabel = contentlb;
    
    
    //设置图片的内容
     //获取图片的数量
    
    NSInteger number = model1.picArray.count;
    if (number > 9) {
        number = 9;
    }
    //设置存放图片的View
    UIView *picV = nil;
    if (number == 0) {
        picV = [[UIView alloc] initWithFrame:CGRectMake(0, contentlb.frame.origin.y + contentlb.frame.size.height , (YY16WidthMargin + 85/375.0*widthScreen)*3 + YY16WidthMargin, YY16WidthMargin)];
    }else if (number > 0 && number < 4){
        picV = [[UIView alloc] initWithFrame:CGRectMake(0, contentlb.frame.origin.y + contentlb.frame.size.height , (YY16WidthMargin + 85/375.0*widthScreen)*3 + YY16WidthMargin, YY16WidthMargin + (YY16WidthMargin + 85/375.0*widthScreen)*1)];
    }else if (number >3 &&number < 7){
        picV = [[UIView alloc] initWithFrame:CGRectMake(0, contentlb.frame.origin.y + contentlb.frame.size.height , (YY16WidthMargin + 85/375.0*widthScreen)*3 + YY16WidthMargin, YY16WidthMargin + (YY16WidthMargin + 85/375.0*widthScreen)*2)];
        
    }else{
        picV = [[UIView alloc] initWithFrame:CGRectMake(0, contentlb.frame.origin.y + contentlb.frame.size.height , (YY16WidthMargin + 85/375.0*widthScreen)*3 + YY16WidthMargin, YY16WidthMargin + (YY16WidthMargin + 85/375.0*widthScreen)*3)];
    }
    [self.contentView addSubview:picV];
    //测试
    //picV.backgroundColor = [UIColor yellowColor];
    
    //设置存放图片的ImageView
    for (int i = 0; i < number; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(YY16WidthMargin +(85/375.0*widthScreen +YY16WidthMargin)*(i%3), YY16WidthMargin + (85/667.0*heightScreen +YY16WidthMargin)*(i/3), 85/375.0*widthScreen, 85/667.0*heightScreen)];
        imageView.image = [UIImage imageNamed:model1.picArray[i]];
        [picV addSubview:imageView];
        //NSLog(@"%ld",i);
    }
    
    YYFruitTool *tool = [YYFruitTool new];
    //设置灰色的线
    [tool addLineViewWithFrame:CGRectMake(0, picV.frame.origin.y + picV.frame.size.height+1, widthScreen, 1) andView:self.contentView];
    UIView *grayViewLine = [[UIView alloc] initWithFrame:CGRectMake(0, picV.frame.origin.y + picV.frame.size.height+1, widthScreen, 0.5)];
    //grayViewLine.backgroundColor = [UIColor grayColor];
    //[self.contentView addSubview:grayViewLine];
    
    //存放3个按钮的View
    UIView *threeButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, grayViewLine.frame.origin.y + grayViewLine.frame.size.height, widthScreen, 30)];
    [self.contentView addSubview:threeButtonView];
    //测试
    //threeButtonView.backgroundColor = [UIColor blueColor];
    //设置3个按钮
    //第一个view
    UIView *viewPre = [[UIView alloc] initWithFrame:CGRectMake(widthScreen/3.0/2 - 20, threeButtonView.frame.size.height/2.0 - 6, 40, 12)];

    [threeButtonView addSubview:viewPre];
    //测试
    //viewPre.backgroundColor = [UIColor blueColor];
    
    UIImageView *viewImagePre = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    viewImagePre.image = [UIImage imageNamed:@"bgq_person_share"];
    [viewPre addSubview:viewImagePre];
    
    UILabel *shareNumber = [[UILabel alloc]initWithFrame:CGRectMake(viewImagePre.frame.size.width, 0, viewPre.frame.size.width - viewImagePre.frame.size.width, viewPre.frame.size.height)];
    shareNumber.textColor = [UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:1];
    shareNumber.textAlignment = 1;
    shareNumber.font = [UIFont systemFontOfSize:12];
    [viewPre addSubview:shareNumber];
    self.shareLabelNumber = shareNumber;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, threeButtonView.frame.size.width/3.0, threeButtonView.frame.size.height);
    shareBtn.backgroundColor = [UIColor clearColor];
    
    [threeButtonView addSubview:shareBtn];
    self.shareButton = shareBtn;
    [self.shareButton addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    
    //第二个view
    UIView *viewCur = [[UIView alloc] initWithFrame:CGRectMake(widthScreen/6.0 - 24 + widthScreen/3.0, threeButtonView.frame.size.height/2.0 - 6, 48, 12)];
//    CGRect rect2 = viewCur.frame;
//    rect2.origin.x = threeButtonView.frame.size.width/6*3 - viewCur.frame.size.width/2.0;
//    rect2.origin.y = threeButtonView.center.y - viewCur.frame.size.height/2.0;
//    viewCur.frame = rect2;
    [threeButtonView addSubview:viewCur];
    
    UIImageView *viewImageCur = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    viewImageCur.image = [UIImage imageNamed:@"bgq_detail_comment"];
    [viewCur addSubview:viewImageCur];
    
    UILabel *commentlb = [[UILabel alloc]initWithFrame:CGRectMake(viewImageCur.frame.size.width, 0, viewCur.frame.size.width - viewImageCur.frame.size.width, viewCur.frame.size.height)];
    commentlb.textColor = [UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:1];
    commentlb.textAlignment = 1;
    commentlb.text =@"评论";
    commentlb.font = [UIFont systemFontOfSize:12];
    [viewCur addSubview:commentlb];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(threeButtonView.frame.size.width/3.0, 0, threeButtonView.frame.size.width/3.0, threeButtonView.frame.size.height);
    commentBtn.backgroundColor = [UIColor clearColor];
    
    [threeButtonView addSubview:commentBtn];
    self.commentButton = commentBtn;
    [self.commentButton addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];

    
    //第三个view
    UIView *viewNex = [[UIView alloc] initWithFrame:CGRectMake(widthScreen/6.0-24+widthScreen/3.0*2, threeButtonView.frame.size.height/2.0 - 6 , 48, 12)];
    
    [threeButtonView addSubview:viewNex];
    
    UIImageView *viewImageNex = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    viewImageNex.image = [UIImage imageNamed:@"zan"];
    [viewNex addSubview:viewImageNex];
    self.zanImageView = viewImageNex;
    
    UILabel *zanlb = [[UILabel alloc]initWithFrame:CGRectMake(viewImageNex.frame.size.width, 0, viewNex.frame.size.width - viewImageNex.frame.size.width, viewNex.frame.size.height)];
    zanlb.textColor = [UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:1];
    zanlb.textAlignment = 1;
    zanlb.font = [UIFont systemFontOfSize:12];
    [viewNex addSubview:zanlb];
    self.zanLabelNumber = zanlb;
    
    UIButton *zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zanBtn.frame = CGRectMake(threeButtonView.frame.size.width/3.0*2, 0, threeButtonView.frame.size.width/3.0, threeButtonView.frame.size.height);
    zanBtn.backgroundColor = [UIColor clearColor];
    
    [threeButtonView addSubview:zanBtn];
    self.zanButton = zanBtn;
    [self.zanButton addTarget:self action:@selector(clickZan:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置竖线
    
    [tool addLineViewWithFrame:CGRectMake(threeButtonView.frame.size.width/3.0,5, 0.5, 20) andView:threeButtonView];
    //UIView *shuLine1 = [[UIView alloc] initWithFrame:CGRectMake(threeButtonView.frame.size.width/3.0, 5, 1, 20)];
    //shuLine1.backgroundColor = [UIColor grayColor];
    //[threeButtonView addSubview:shuLine1];
    [tool addLineViewWithFrame:CGRectMake(threeButtonView.frame.size.width/3.0*2, 5, 0.5, 20) andView:threeButtonView];
    //UIView *shuLine2 = [[UIView alloc] initWithFrame:CGRectMake(threeButtonView.frame.size.width/3.0*2, 5, 1, 20)];
    //shuLine2.backgroundColor = [UIColor grayColor];
    //[threeButtonView addSubview:shuLine2];
   
    
    //对视图的内容进行赋值

    self.leftImageView.image = [UIImage imageNamed:model1.leftImageName];
    self.nameLabel.text = model1.userName;
    self.timeLabel.text = model1.time;
    
    
    self.shareLabelNumber.text = [NSString stringWithFormat:@"%ld",(long)model1.shareNumber];
    self.zanLabelNumber.text = [NSString stringWithFormat:@"%ld",(long)model1.zanNumber];
    
    
    self.rowHeight = threeButtonView.frame.origin.y +threeButtonView.frame.size.height;
    
}

- (void)clickShare:(UIButton *)sender{
    
    NSLog(@" YYCirclePersonTableViewCell.m  点击了分享");
}

- (void)clickComment:(UIButton *)sender{
    NSLog(@" YYCirclePersonTableViewCell.m   点击了评论");
}

- (void)clickZan:(UIButton *)sender{
    NSLog(@" YYCirclePersonTableViewCell.m 点击了赞");
    sender.enabled = NO;
    self.zanImageView.image = [UIImage imageNamed:@"bgq_detailCircle_Zan"];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
