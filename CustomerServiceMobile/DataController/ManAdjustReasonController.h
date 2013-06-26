//
//  ManAdjustReasonController.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"

@interface ManAdjustReasonController : DataSynchController
@property (weak,readonly, nonatomic) NSArray* reasons;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end
