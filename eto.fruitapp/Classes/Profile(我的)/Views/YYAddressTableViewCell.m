//
//  YYAddressTableViewCell.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/29.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYAddressTableViewCell.h"
#import "YYAddressCellModel.h"

@interface YYAddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation YYAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithAddressCell{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YYAddressTableViewCell" owner:nil options:nil] lastObject];
        
    }
    return self;
}
- (void)setAddressModel:(YYAddressCellModel *)AddressModel{
    _AddressModel =AddressModel;
    
    self.nameLabel.text = AddressModel.name;
    self.nameLabel.textColor = [UIColor grayColor];
    self.addressLabel.text = AddressModel.address;
    self.phoneLabel.text = AddressModel.phone;
}
@end
