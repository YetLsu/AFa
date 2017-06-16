//
//  YYCollectionArticleModel.m
//  eto.fruitapp
//
//  Created by Apple on 16/1/21.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "YYCollectionArticleModel.h"

@implementation YYCollectionArticleModel

- (instancetype)initWithBccid:(NSString *)bccid withBcid:(NSString *)bcid withTime:(NSString *)time withHeadimg:(NSString *)headimg withImg:(NSString *)img withIntro:(NSString *)intro withTitle:(NSString *)title withUserName:(NSString *)userName{
    if (self = [super init]) {
        self.bccid = bccid;
        self.bcid = bcid;
        
        self.time = time;
        NSString *head = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp%@",headimg];
        NSURL *url = [NSURL URLWithString:head];
        self.headimg = url;
        
        NSURL *url1 = [NSURL URLWithString:img];
        self.img = url1;
        
        self.intro = intro;
        
        self.title = title;
        
        self.userName = userName;
        
     
    }
    return self;
}



@end
