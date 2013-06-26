
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"
#import "CycleCountMaster.h"
@interface CycleCountController : DataSynchController
@property (nonatomic) BOOL isBinCount;
-(BOOL)post:(CycleCountMaster*)cycleCountMaster;
-(RKObjectMapping *) cycleCountMapping;

@end
