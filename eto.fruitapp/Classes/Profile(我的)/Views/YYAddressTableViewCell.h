//
//  YYAddressTableViewCell.h
//  eto.fruitapp
//
//  Created by wyy on 15/10/29.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYAddressCellModel;

@interface YYAddressTableViewCell : UITableViewCell



@property(nonatomic, strong)YYAddressCellModel *AddressModel;
- (instancetype)initWithAddressCell;
@end
