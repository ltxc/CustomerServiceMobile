
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"
#import "SharedConstants.h"

@interface ApplicationDataSynchController : DataSynchController<SynchController,RKObjectLoaderDelegate>
@property (weak, nonatomic, readonly) NSArray* appicationdata;
@end
