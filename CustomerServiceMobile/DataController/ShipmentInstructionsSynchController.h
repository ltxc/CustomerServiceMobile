
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"

@interface ShipmentInstructionsSynchController : DataSynchController
@property (weak,readonly, nonatomic) NSArray* objects;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end
