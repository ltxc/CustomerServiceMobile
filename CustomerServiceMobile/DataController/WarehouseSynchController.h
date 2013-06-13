//
//  WarehouseSynchController.h
//  CustomerServiceMobile
//
//  Created by LTXC on 11/28/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "DataSynchController.h"

@interface WarehouseSynchController : DataSynchController<RKObjectLoaderDelegate>
@property (weak,readonly, nonatomic) NSArray* warehouses;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;

@end
