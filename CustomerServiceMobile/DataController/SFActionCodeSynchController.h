//
//  SFActionCodeSynchController.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"

@interface SFActionCodeSynchController : DataSynchController<RKObjectLoaderDelegate>
@property (weak,readonly, nonatomic) NSArray* actionCodes;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end
