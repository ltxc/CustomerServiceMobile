//
//  CoreDataSynch.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/26/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchBase.h"

/**
 * CoreDataSynch is used to synch by calling a simple get http call.
 * 
 */
@interface CoreDataSynch : DataSynchBase<RKObjectLoaderDelegate>
@property (weak,readonly, nonatomic) id result;
@property (nonatomic)BOOL isASynch;
@property (strong,nonatomic) NSString* entityName;
@property (strong, nonatomic) NSString* rootKeyPath;
@property (strong, nonatomic) NSString* baseURL;
@property (strong,nonatomic) RKManagedObjectStore* objectStore;
@property (strong,nonatomic) DataSynchNotificationMessageBlock notificationMessageBlock;


-(id)init:(NSString*)controllerName objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName mapBlock:(DataSynchEntityMappingBlock)mapBlock fetchBlock:(RKObjectMappingProviderFetchRequestBlock)fetchRequestBlock;
-(void)load:(DataSynchResourcePathBlock)resourcePathBlock;
-(void)saveRKCache;
@end
