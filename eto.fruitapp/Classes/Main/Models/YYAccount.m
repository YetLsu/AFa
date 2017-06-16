//
//  YYAccount.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/16.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYAccount.h"

@implementation YYAccount
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userNickName forKey:YYUserNickName];
    [aCoder encodeObject:self.userPhone forKey:YYUserPhone];
    [aCoder encodeObject:self.userUID forKey:YYUserUID];
    [aCoder encodeObject:self.userIconImage forKey:YYUserIconImage];
    [aCoder encodeObject:self.userIconUrlStr forKey:YYUserIconStr];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.userIconImage = [aDecoder decodeObjectForKey:YYUserIconImage];
        self.userNickName = [aDecoder decodeObjectForKey:YYUserNickName];
        self.userPhone = [aDecoder decodeObjectForKey:YYUserPhone];
        self.userUID = [aDecoder decodeObjectForKey:YYUserUID];
        self.userIconUrlStr = [aDecoder decodeObjectForKey:YYUserIconStr];
    }
    return self;
}
@end
