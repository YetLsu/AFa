//
//  YYAnnotationView.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/23.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYAnnotationView.h"
#import "YYAnnotation.h"

@implementation YYAnnotationView
+ (instancetype)annotationViewWithMapView:(MKMapView *)mapView{
    static NSString *ID = @"YYAnnotationView";
    YYAnnotationView *annotationView = (YYAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (!annotationView) {
        annotationView = [[YYAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annotationView.canShowCallout = YES;
    }
    return annotationView;
}
- (void)setAnnotation:(YYAnnotation *)annotation
{
    
    [super setAnnotation:annotation];
}
@end
