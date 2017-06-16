//
//  YYWebViewController.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/23.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class YYAnnotation;
@interface YYMapViewController : UIViewController

@property (nonatomic,strong)YYAnnotation *annotation;
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)shopcoordinate;
@end
