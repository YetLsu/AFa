//
//  YYDetaileCommentTableViewCell.m
//  YYDetaileCommentCellModel
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYDetaileCommentTableViewCell.h"
#import "YYDetailCommentModel.h"
#import "YYDetailCommentFrame.h"


@interface YYDetaileCommentTableViewCell ()
@property (nonatomic,weak) UIImageView *headImageView;
@property (nonatomic,weak) UILabel *userNameLabel;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UILabel *commentContent;
@property (nonatomic,weak) UIButton *zanButton;
@property (nonatomic,weak) UILabel *zanNumber;

@property (nonatomic,assign) NSInteger port;



@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation YYDetaileCommentTableViewCell
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager  = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)DetailCommentTableViewCell:(UITableView *)tableView WithPort:(NSInteger)port{
    
    static NSString *indenti = @"commentCell";
    YYDetaileCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenti];

    if (!cell) {
        cell = [[YYDetaileCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenti WithPort:port];
        //cell.port = port;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithPort:(NSInteger) port{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        //设定端口
        self.port = port;
        //头像
        UIImageView *view1 = [[UIImageView alloc] init];
        view1.frame = CGRectMake(YY16WidthMargin, YY16WidthMargin, 45/375.0*widthScreen, 45/667.0*heightScreen);
        view1.layer.cornerRadius = view1.frame.size.width/2.0;//设置圆的半径
        view1.layer.masksToBounds = YES;
        [self.contentView addSubview:view1];
//        self.headImageView.contentMode = UIViewContentModeScaleToFill;
        self.headImageView = view1;
//        self.headImageView.backgroundColor = [UIColor redColor];
        
        
        //用户昵称显示
        UILabel *view2 = [[UILabel alloc] init];
        view2.frame = CGRectMake(YY16WidthMargin+45/375.0*widthScreen+YY16WidthMargin, 18/667.0*heightScreen, 100, 15);
        view2.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:view2];
        self.userNameLabel = view2;
        
        //回复
        UILabel *replylb = [[UILabel alloc] init];
        replylb.frame = CGRectMake(view2.frame.origin.x + YY10WidthMargin, view2.frame.origin.y + view2.frame.size.height + 5/667.0*heightScreen-2, 200/375.0*widthScreen, 10);
        replylb.font = [UIFont systemFontOfSize:10];
        self.toLabel = replylb;
        
        
        //时间
        UILabel *view3 = [[UILabel alloc] init];
        view3.frame = CGRectMake(YY16WidthMargin+45/375.0*widthScreen+YY16WidthMargin, 53/667.0*heightScreen, 100, 13);
        view3.textAlignment = NSTextAlignmentLeft;
        view3.font = [UIFont systemFontOfSize:11];
        view3.textColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1];
        [self.contentView addSubview:view3];
        
        self.timeLabel = view3;
        
        //内容
        UILabel *view4 = [[UILabel alloc] init];
        view4.frame = CGRectMake(YY16WidthMargin+45/375.0*widthScreen+YY16WidthMargin, 150/2/667.0*heightScreen+2, 570/2/375.0*widthScreen, 30);
        [self.contentView addSubview:view4];
        view4.font = [UIFont systemFontOfSize:14];
        view4.textColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1];
        view4.numberOfLines = 0;
        self.commentContent = view4;
        
        //赞的数量 (12_10)
        UILabel *view5 = [[UILabel alloc] init];
        view5.frame = CGRectMake(widthScreen-16-21, 34, 21, 14);
        view5.textColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1];
        view5.font = [UIFont systemFontOfSize:14];
        view5.textAlignment = 1;
        [self.contentView addSubview:view5];
        self.zanNumber = view5;
        
        //赞(12_10)
        UIButton *view6 = [UIButton buttonWithType:UIButtonTypeCustom];
        view6.frame = CGRectMake(widthScreen-16-21-18, 31, 17, 17);
        [view6 setImage:[UIImage imageNamed:@"littleCold_zan"] forState:UIControlStateNormal];
        [view6 setImage:[UIImage imageNamed:@"littleCold_zan_Highlighted"] forState:UIControlStateHighlighted];
        [view6 setImage:[UIImage imageNamed:@"littleCold_zan_Highlighted"] forState:UIControlStateDisabled];
        [view6 addTarget:self action:@selector(zanNumberAdd:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:view6];
        self.zanButton = view6;
        
    }
    return self;
}


- (void)setCellFrame:(YYDetailCommentFrame *)cellFrame{
    _cellFrame = cellFrame;
    YYDetailCommentModel *model = cellFrame.model;
    
    self.headImageView.image = nil;
    self.userNameLabel.text = nil;
    self.timeLabel.text = nil;
    self.commentContent.text = nil;
    self.zanNumber.text = nil;
    self.toLabel.text = nil;
    
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageStr] placeholderImage:[UIImage imageNamed:@"14"]];
    //self.headImageView.image = [UIImage imageNamed:@"14"];
    self.userNameLabel.text = model.userName;
    self.timeLabel.text = model.time;
    self.commentContent.text = model.commentContent;
    self.zanNumber.text = [NSString stringWithFormat:@"%ld",(long)model.CommentNumberOfZan];

    self.cellSize = [model.commentContent boundingRectWithSize:CGSizeMake(570/2/375.0*widthScreen, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    //YYLog(@"++++++++++++++++++++++++++++++%@",model.toMan);
#pragma mark ----- 判断服务器返回的username
    if (model.toMan == nil ) {
        self.toLabel.hidden = YES;
    }else{
        self.toLabel.text = [NSString stringWithFormat:@"对%@说:",model.toMan];
        [self.contentView addSubview:self.toLabel];
        self.toLabel.hidden = NO;
    }
    

    self.commentContent.frame = CGRectMake((16+45+16)/375.0*widthScreen, 68/667.0*heightScreen, self.cellSize.width, self.cellSize.height);
    //设置赞的状态
    BOOL zan = [[YYFruitDatabaseTool shareFruitTool] selectZanCommentWithCommentID:model.commentID];
    if (zan) {
        self.zanButton.enabled = NO;
    }
    else{
        self.zanButton.enabled = YES;
    }
    YYLog(@"%ld",(long)model.commentID);
    //model.commentID
}

- (void)zanNumberAdd:(UIButton *)sender{
    YYLog(@"评论点赞%ld",(long)self.cellFrame.model.commentID);
   
    //修改12_24
    //评论点赞urlhttp://www.sxeto.com/fruitApp/Buyer.php?mode=36&bacid=2
    NSString *urlStr = nil;
    YYLog(@"=============%ld",(long)self.port);
    YYLog(@"-=-=-=-=-=-%ld",self.cellFrame.model.commentID);
    if (self.port == 28) {
       urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=28&bscid=%ld",(long)self.cellFrame.model.commentID];
        YYLog(@"啦啦啦啦啦");
        YYLog(@"++++++++++++++++++++++++++++++++++%ld",(long)self.cellFrame.model.commentID);
    }else if(self.port == 36){
       urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=36&bacid=%ld",(long)self.cellFrame.model.commentID];
        YYLog(@"%@",urlStr);
    }else if (self.port == 281){
        urlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=281&bcpcid=%ld",(long)self.cellFrame.model.commentID];
        YYLog(@"%@",urlStr);
    }
    
   
    
    [self.manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        YYLog(@"%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {//点赞成功
            sender.enabled = NO;
            YYLog(@"点赞成功");
            NSString *numberofZan = responseObject[@"hot"];
            self.zanNumber.text = [NSString stringWithFormat:@"%ld",numberofZan.integerValue];
            [[YYFruitDatabaseTool shareFruitTool] addZanCommentWithCommentID:self.cellFrame.model.commentID];
            if ([self.delegate respondsToSelector:@selector(commentCellZanClick)]) {
                [self.delegate commentCellZanClick];
            }
        }
        else return;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YYLog(@"发送失败%@",error);
    }];
}


@end
