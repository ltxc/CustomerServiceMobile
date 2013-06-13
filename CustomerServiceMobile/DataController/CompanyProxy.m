//
//  CompanyProxy.m
//  CustomerServiceMobile
//
//  Created by LTXC on 12/9/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "CompanyProxy.h"

@implementation CompanyProxy
-(CompanyProxy*)initWithID:(NSString*)company_id
{
    self = [super init];
    if (self) {
        self.company_id = company_id;
    }
    return self;
    
}
@end
