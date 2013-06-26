
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//
#import "DataSynchController.h"

@interface ShippingListSynchController : DataSynchController
@property (weak,readonly, nonatomic) NSArray* shippingLists;
-(id)init;
-(NSInteger)load;
-(RKManagedObjectMapping *) entityMapping;

@end
