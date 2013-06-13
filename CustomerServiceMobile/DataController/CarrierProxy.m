//
//  CarrierProxy.m
//  CustomerServiceMobile
//
//  Created by LTXC on 12/9/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "CarrierProxy.h"

@implementation CarrierProxy
-(CarrierProxy*)initWithID:(NSString*)carrier_id
{
    self = [super init];
    if (self) {
        self.carrier_id = carrier_id;
    }
    return self;
    
}
@end
