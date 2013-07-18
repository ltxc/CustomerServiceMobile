//
//  CoreDataSynch.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/16/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchBase.h"

@interface CoreDataSynch : DataSynchBase<RKObjectLoaderDelegate>
@property (weak,readonly, nonatomic) id result;
@property (nonatomic)BOOL isASynch;
@property (strong,nonatomic) NSString* entityName;
@property (strong, nonatomic) NSString* rootKeyPath;
@property (strong, nonatomic) NSString* baseURL;
@property (strong,nonatomic) RKManagedObjectStore* objectStore;
@property (strong,nonatomic) DataSynchNotificationMessageBlock notificationMessageBlock;
//baseURL is the relative path to the base url set at the RKObjectManager level.
-(id)init:(NSString*)controllerName objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName mapBlock:(DataSynchEntityMappingBlock)mapBlock;
-(RKManagedObjectMapping *) entityMapping;
@end
