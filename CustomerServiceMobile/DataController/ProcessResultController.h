//
//  ProcessResultController.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/14/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"
#import "ProcessResult.h"

@interface ProcessResultController : DataSynchController<RKObjectLoaderDelegate>

-(id)init;
-(ProcessResult*)query:(NSString*)ipad_id type:(NSString*)type;
-(RKManagedObjectMapping *) entityMapping;
@end
