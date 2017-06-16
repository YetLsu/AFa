//
//  WYTextView.m
//  发表消息的框
//
//  Created by Apple on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "WYTextView.h"

@interface WYTextView () <UITextViewDelegate>

@property (nonatomic,weak) UILabel *placeholderLabel;

@end

@implementation WYTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        //添加一个现实提醒文字的label
        UILabel *placehoderLabel = [[UILabel alloc] init];
        placehoderLabel.numberOfLines = 0;
        placehoderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placehoderLabel];
        
        self.placeholderLabel = placehoderLabel;
        
        //设置默认文字颜色
        self.placeholderColor = [UIColor lightGrayColor];
        
        //设置默认字体
        self.font = [UIFont systemFontOfSize:11];
        
        //监听内部文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
        //为textview添加一个手势
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewOnClick)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)textViewOnClick {
    
    [self becomeFirstResponder];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变
- (void)textDidChange{
    
    self.placeholderLabel.hidden = self.hasText;
}

#pragma mark - 公共方法
- (void)setText:(NSString *)text {
    
    [super setText:text];
    [self textDidChange];
}


- (void)setAttributedText:(NSAttributedString *)attributedText {
    
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
    //设置文字
    self.placeholderLabel.text = placeholder;
    //重新计算子控件frame
    [self setNeedsLayout];
    
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
    
}


- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGRect rect = CGRectMake(5, 8, self.frame.size.width - 2 * 5, 0);
    
    
    //self.placeholderLabel.y = 8;
    //self.placeholderLabel.x = 5;
    //self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x ;
    self.placeholderLabel.frame = rect;
    //CGSize maxSize = CGSizeMake(self.placeholderLabel.frame.size.width, MAXFLOAT);
    CGSize placehoderSize = [self.placeholder boundingRectWithSize:CGSizeMake(self.placeholderLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size;
    
     rect.size.height = placehoderSize.height;
    self.placeholderLabel.frame = rect;
}




@end
