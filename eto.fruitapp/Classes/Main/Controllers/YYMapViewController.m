//
//  YYWebViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/23.
//  Copyright © 2015年 wyy. All rights reserved.
//


#import "YYMapViewController.h"
#import "YYAnnotationView.h"
#import "YYAnnotation.h"

@interface YYMapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>
@property (nonatomic, weak) MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *geocoder;
//商家的经纬度从创建控制器的方法传入
@property (nonatomic, assign) CLLocationCoordinate2D shopCoordinate;
@property (nonatomic, assign, getter=isFirst) BOOL first;
@end

@implementation YYMapViewController
- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (instancetype) initWithCoordinate:(CLLocationCoordinate2D)shopcoordinate{
    if (self = [super init]) {
        self.shopCoordinate = shopcoordinate;
        
    }
    return self;
}
- (CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        //设置定位精度
        _manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //定位频率,每隔10米定位一次
        CLLocationDistance distance = 10;
        _manager.distanceFilter = distance;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //把mapView添加到控制器的View上
    [self addMapViewAndsetMapWithFrame:CGRectMake(0, 0, widthScreen, heightScreen * 0.94)];
    
    //在view上添加底部的三个按钮的view
    [self addBottomViewHaveThreeBtnWithFrame:CGRectMake(0, heightScreen * 0.94, widthScreen, heightScreen * 0.06)];
    
    //开始定位
    [self.manager startUpdatingLocation];
    //添加当前位置的大头针
    [self addShopAnnotation];
   
}
/**
 *在view上添加底部的三个按钮的view
 */
- (void)addBottomViewHaveThreeBtnWithFrame:(CGRect)bottomFrame{
    UIView *bottomView = [[UIView alloc] initWithFrame:bottomFrame];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor redColor];
    //增加第一个按钮
    CGFloat width = bottomFrame.size.width / 3;
    CGFloat height = bottomFrame.size.height;
    [self addBtnWithTarget:self andSelector:@selector(findMyself) andFrame:CGRectMake(0, 0, width, height)andSuperView:bottomView andBackGroundColor:[UIColor blueColor] andTitle:@"定位"];
    [self addBtnWithTarget:self andSelector:@selector(toDescWay) andFrame:CGRectMake(width, 0, width, height) andSuperView:bottomView andBackGroundColor:[UIColor greenColor] andTitle:@"线路"];
    
    [self addBtnWithTarget:self andSelector:@selector(navigation) andFrame:CGRectMake(width * 2, 0, width, height) andSuperView:bottomView andBackGroundColor:[UIColor orangeColor] andTitle:@"导航"];
    
}

//添加按钮
- (void)addBtnWithTarget:(id)target andSelector:(SEL)selector andFrame:(CGRect)btnFrame andSuperView:(UIView *)superView andBackGroundColor:(UIColor *)color andTitle:(NSString *)title{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [superView addSubview: btn];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:color];

}
/**
 *  导航
 *
 */
- (void)navigation{

    CLLocation *destLocation = [[CLLocation alloc] initWithLatitude:self.shopCoordinate.latitude longitude:self.shopCoordinate.longitude];
    [self.geocoder reverseGeocodeLocation:destLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *destCp = [placemarks firstObject];
        MKPlacemark *destMp = [[MKPlacemark alloc] initWithPlacemark:destCp];
        MKMapItem *destItem = [[MKMapItem alloc] initWithPlacemark:destMp];
        
        MKMapItem *sourceItem = [MKMapItem mapItemForCurrentLocation];
        
        
        // 1.将起点和终点item放入数组中
        NSArray *items = @[sourceItem, destItem];
        
        // 2.设置Options参数(字典)
        NSDictionary *options = @{
                                  MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking,
                                  MKLaunchOptionsMapTypeKey : @(MKMapTypeSatellite),
                                  MKLaunchOptionsShowsTrafficKey : @YES
                                  };
        
        [MKMapItem openMapsWithItems:items launchOptions:options];
        
    }];

}
/**
 *  线路
 *
 */
- (void)toDescWay{
    
//    [self.geocoder geocodeAddressString:@"绍兴" completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (placemarks.count == 0 || error) return;
//        
//        // 2.1.获取CLPlaceMark对象
//        CLPlacemark *clpm = [placemarks firstObject];
//        
//        // 2.2.利用CLPlacemark来创建MKPlacemark
//        MKPlacemark *mkpm = [[MKPlacemark alloc] initWithPlacemark:clpm];
//        
//        // 2.3.创建目的地的MKMapItem对象
//        MKMapItem *destItem = [[MKMapItem alloc] initWithPlacemark:mkpm];
//        
//        [self drawLineFromSourceToDescWithDestItem:destItem];
//        
//    }];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.shopCoordinate.latitude longitude:self.shopCoordinate.longitude];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            YYLog(@"%@",error);
        }
        CLPlacemark *clpm = [placemarks firstObject];
        
        MKPlacemark *mkpm = [[MKPlacemark alloc] initWithPlacemark:clpm];
        
        MKMapItem *destItem = [[MKMapItem alloc] initWithPlacemark:mkpm];
        
        [self drawLineFromSourceToDescWithDestItem:destItem];
    }];
    

}
/**
 *  画出商家到当前位置的路线
 */
- (void)drawLineFromSourceToDescWithDestItem:(MKMapItem *)destItem{
    
    MKMapItem *sourceItem = [MKMapItem mapItemForCurrentLocation];
    
    // 1.创建MKDirectionsRequest对象
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = sourceItem;
    
    request.destination = destItem;
    //交通方式
    request.transportType = MKDirectionsTransportTypeWalking;
    
    // 2.创建MKDirections对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 3.请求/计算(当请求到路线信息的时候会来到该方法)
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        // 3.1.当有错误,或者路线数量为0直接返回
        if (error || response.routes.count == 0) {
            YYLog(@"%@",error);
            return;
        }
        
        YYLog(@"%ld", response.routes.count);
        
        // 3.2.遍历所有的路线
        for (MKRoute *route in response.routes) {
            
            // 3.3.取出路线(遵守MKOverlay)
            MKPolyline *polyLine = route.polyline;
            
            // 3.4.将路线添加到地图上
            [self.mapView addOverlay:polyLine];
        }
        
    }];
    
}

/**
 *  当一个遮盖添加到地图上时会执行该方法
 *
 *  @param overlay 遵守MKOverlay的对象
 *
 *  @return 画线的渲染
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(MKPolyline *)overlay
{
    MKPolylineRenderer *poly = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    poly.strokeColor = [UIColor redColor];
    poly.lineWidth = 5.0;
    
    return poly;
}
/**
 *  定位到自己
 *
 */
- (void)findMyself{
   
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate, span) animated:YES];
}
/**
 *  添加大头针
 *
 */
- (void)addShopAnnotation{
    YYAnnotation *myannotation = [[YYAnnotation alloc] init];
    myannotation.title = @"老王水果店";
    myannotation.subtitle = @"正在营业";
    myannotation.coordinate = self.shopCoordinate;
    [self.mapView addAnnotation:myannotation];
}
/**
 *  添加mapView到控制器上
 */
- (void)addMapViewAndsetMapWithFrame:(CGRect )mapFrame{
    MKMapView *mapView = [[MKMapView alloc] init];
    mapView.frame = mapFrame;
    [self.view addSubview:mapView];
    
    self.mapView = mapView;
    self.mapView.delegate = self;
    //设置地图的样式
    self.mapView.mapType = MKMapTypeStandard;
    //设置地图的跟随方式
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;

}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 设置用户的位置为地图的中心点
    
    YYLog(@"定位到用户当前位置");
 
}
//改变地图区域
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self.mapView removeFromSuperview];
    [self.view addSubview:mapView];
}

#pragma mark 在地图上添加大头针会调用的方法
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    MKAnnotationView *myannotationView = [[MKAnnotationView alloc] init];
//    
//    myannotationView.canShowCallout = YES;
//    return myannotationView;
//    
//}
- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView{
    if (!self.isFirst) {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        MKCoordinateRegion region = MKCoordinateRegionMake(self.shopCoordinate, span);
        [mapView setRegion:region animated:YES];
        self.first = !self.isFirst;
        
    }
}
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    
//    //MKModernUserLocationView
//    for (MKAnnotationView *annoView in views) {
//        // 如果是系统的大头针View直接返回
//        if ([annoView.annotation isKindOfClass:[MKUserLocation class]]) return;
//        
//        // 取出大头针View的最终应该在位置
//        CGRect endFrame = annoView.frame;
//        
//        // 给大头针重新设置一个位置
//        annoView.frame = CGRectMake(endFrame.origin.x, 0, endFrame.size.width, endFrame.size.height);
//        
//        // 执行动画
//        [UIView animateWithDuration:0.5 animations:^{
//            annoView.frame = endFrame;
//        }];
//    }
//}

@end
