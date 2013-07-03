//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchBase.h"

@interface CycleCountMasterController : DataSynchBase
@property (weak,readonly, nonatomic) NSArray* cycleCountMasters;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end
