//
//  ManAdjustReasonController.h
//  CustomerServiceMobile
//
//  Created by LTXC on 12/3/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "DataSynchController.h"

@interface ManAdjustReasonController : DataSynchController
@property (weak,readonly, nonatomic) NSArray* reasons;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end
