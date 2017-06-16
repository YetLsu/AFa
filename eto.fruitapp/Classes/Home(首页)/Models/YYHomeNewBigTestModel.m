//
//  YYHomeNewBigTestModel.m
//  eto.fruitapp
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "YYHomeNewBigTestModel.h"

@implementation YYHomeNewBigTestModel

- (instancetype)initWithIcon:(NSString *)icon withAuthorName:(NSString *)authorName withTItle:(NSString *)title withImagePic:(NSString *)imagePic withBid:(NSInteger)bid withContentURL:(NSString *)content withIntro:(NSString *)intro withDate:(long long)date{
    if (self = [super init]) {
        NSURL *URLicon = [NSURL URLWithString:icon];
        self.iconUrl = URLicon;
        self.authorName = authorName;
        self.title = title;
        NSURL *URLimage = [NSURL URLWithString:imagePic];
        self.imagePicUrl = URLimage;
        self.bid = bid;
        NSURL *contentUrl = [NSURL URLWithString:content];
        self.contentURL = contentUrl;
        self.intro = intro;
        self.date = date;
    }
    return self;
}


@end
