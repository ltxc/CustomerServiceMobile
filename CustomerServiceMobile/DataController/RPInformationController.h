//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchBase.h"
#import "RPInformation.h"
@interface RPInformationController : DataSynchBase
-(id)init;

-(RPInformation *)query:(NSString*)request_id;
-(RKObjectMapping *) entityMapping;

@end
