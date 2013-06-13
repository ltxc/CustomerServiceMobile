//
//  WarehouseProxy.m
//  CustomerServiceMobile
//
//  Created by LTXC on 12/9/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "WarehouseProxy.h"

@implementation WarehouseProxy
-(WarehouseProxy*)initWithID:(NSString*)warehoud_id
{
    self = [super init];
    if (self) {
        self.warehouse_id = warehoud_id;
    }
    return self;

}

@end
