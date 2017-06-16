//
//  DSComposePhotosView.h
//  发表消息的框
//
//  Created by Apple on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSComposePhotosView : UIView
@property (nonatomic , retain) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *assetsArray;
@property (nonatomic , strong) UIButton *addButton;
@property (nonatomic , strong) NSArray *selectedPhotos;

@end
