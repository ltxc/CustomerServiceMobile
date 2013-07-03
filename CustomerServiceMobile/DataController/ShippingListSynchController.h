
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//
#import "DataSynchBase.h"

@interface ShippingListSynchController : DataSynchBase
@property (weak,readonly, nonatomic) NSArray* shippingLists;
-(id)init;
-(NSInteger)load;
-(RKManagedObjectMapping *) entityMapping;

@end
