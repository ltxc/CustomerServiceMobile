//
//  CoreDataSynch.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/26/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"




typedef RKManagedObjectMapping*(^DataSynchEntityMappingBlock)(RKManagedObjectStore*);
typedef NSString*(^DataSynchResourcePathBlock)(NSString* baseUrl);
typedef NSString*(^DataSynchNotificationMessageBlock)(id objects);

@interface CoreDataSynch : DataSynchController<RKObjectLoaderDelegate>
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
