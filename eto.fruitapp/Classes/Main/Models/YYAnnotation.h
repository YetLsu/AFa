//
//  YYAnnotation.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/23.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface YYAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
