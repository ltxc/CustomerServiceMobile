//
//  CoreDataSynch.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/26/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"


#define kCoreDataSynchNotificationStatusKey @"status"
#define kCoreDataSynchNotificationMessageKey @"message"
#define kCoreDataSynchNotificationRecordTemplate @"Total %d records received..."
#define kCoreDataSynchNotificationFailedTemplate @"Server may not be reachable. Detail:%@"

typedef RKManagedObjectMapping*(^DataSynchEntityMappingBlock)(RKManagedObjectStore*);
typedef NSString*(^DataSynchResourcePathBlock)(NSString* baseUrl);
typedef NSString*(^DataSynchNotificationMessageBlock)(id objects);

@interface CoreDataSynch : DataSynchController<RKObjectLoaderDelegate>
@property (weak,readonly, nonatomic) id result;
@property (nonatomic)BOOL isASynch;
@property (strong,nonatomic) NSString* notificationName;
@property (strong,nonatomic) NSString* entityName;
@property (strong, nonatomic) NSString* rootKeyPath;
@property (strong, nonatomic) NSString* baseURL;
@property (strong,nonatomic) RKManagedObjectStore* objectStore;
@property (strong,nonatomic) DataSynchNotificationMessageBlock notificationMessageBlock;


-(id)init:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName mapBlock:(DataSynchEntityMappingBlock)mapBlock fetchBlock:(RKObjectMappingProviderFetchRequestBlock)fetchRequestBlock;
-(void)load:(DataSynchResourcePathBlock)resourcePathBlock;


-(void)addNotificationObserver:(id) observer selector:(SEL)selector;
-(void)removeNotificationObserver:(id) observer notificationName:(NSString*)notificationName;
@end
