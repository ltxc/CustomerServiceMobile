//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"
#import "ShippingHeader.h"
@interface ShippingTransactionController : DataSynchController
@property (nonatomic) BOOL isPart;
-(BOOL)post:(ShippingHeader*)shippingHeader;
-(RKObjectMapping *) shippingMapping;
@end
