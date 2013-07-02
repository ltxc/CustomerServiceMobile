//
//  RepairMasterDataSynch.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/28/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//


#import "DataSynchController.h"

@interface RepairMasterDataSynch : DataSynchController
@property (strong,nonatomic) NSString* notificationName;
@property (strong,nonatomic) RKManagedObjectStore* objectStore;
@property (strong,nonatomic) NSArray* coreDataSynchObjects;

-(id)init:(NSString*)notificationName objectStore:( RKManagedObjectStore*)objectStore;
-(void)load;
@end
