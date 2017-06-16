//
//  WYToolBar.m
//  发表消息的框
//
//  Created by Apple on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "WYToolBar.h"

@interface WYToolBar ()
@property (nonatomic,weak) UIButton * emotionButton;//表情按钮;

@end

@implementation WYToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //添加所有子控件
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 添加所有的子控件
        //[self addButtonWithIcon:@"compose_camerabutton_background" highIcon:@"compose_camerabutton_background_highlighted" tag:DSComposeToolbarButtonTypeCamera];
        
        //话题
        [self addButtonWithIcon:@"compose_trendbutton_background" highIcon:@"compose_trendbutton_background_highlighted" tag:DSComposeToolbarButtonTypeTrend];
        //表情
        UIButton *emotionBtn =  [self addButtonWithIcon:@"compose_emoticonbutton_background" highIcon:@"compose_emoticonbutton_background_highlighted" tag:DSComposeToolbarButtonTypeEmotion];
        self.emotionButton = emotionBtn;
        //图片
        [self addButtonWithIcon:@"compose_toolbar_picture" highIcon:@"compose_toolbar_picture_highlighted" tag:DSComposeToolbarButtonTypePicture];
//        //@
//        [self addButtonWithIcon:@"compose_mentionbutton_background" highIcon:@"compose_mentionbutton_background_highlighted" tag:DSComposeToolbarButtonTypeMention];
//        
        
    }
    return self;
}


/**
 *  添加一个按钮
 *
 *  @param icon     默认图标
 *  @param highIcon 高亮图标
 */
- (UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(DSComposeToolbarButtonType)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [self addSubview:button];
    return button;
}



- (void)setShowEmotionButton:(BOOL)showEmotionButton {
    
    _showEmotionButton = showEmotionButton;
    if (showEmotionButton) { // 显示表情按钮
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    } else { // 切换为键盘按钮
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}



- (void)buttonClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]){
        
        [self.delegate composeTool:self didClickedButton:(int)button.tag];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = (int)self.subviews.count;
    CGFloat buttonW = self.frame.size.width / count;
    CGFloat buttonH = self.frame.size.height;
    for (int i = 0; i<count; i++) {
        UIButton *button = self.subviews[i];
        CGRect rect = CGRectMake(i *buttonW, 0, buttonW, buttonH);
        button.frame = rect;
//        button.y = 0;
//        button.width = buttonW;
//        button.height = buttonH;
//        button.x = i * buttonW;
    }
}



@end
