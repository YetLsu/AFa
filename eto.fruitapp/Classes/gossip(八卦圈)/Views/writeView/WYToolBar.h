//
//  WYToolBar.h
//  发表消息的框
//
//  Created by Apple on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    DSComposeToolbarButtonTypeCamera,//照相机
    DSComposeToolbarButtonTypePicture, //相册
    DSComposeToolbarButtonTypeMention, //提到@
    DSComposeToolbarButtonTypeTrend,//话题
    DSComposeToolbarButtonTypeEmotion //表情
}DSComposeToolbarButtonType;

@class WYToolBar;
@protocol DSComposeToolbarDelegate <NSObject>

- (void)composeTool:(WYToolBar *)toolbar didClickedButton:(DSComposeToolbarButtonType)buttonType;

@end

@interface WYToolBar : UIView
@property (nonatomic ,weak) id<DSComposeToolbarDelegate>delegate;

@property (nonatomic ,assign ,getter=isShowEmotionButton) BOOL showEmotionButton;

@end
