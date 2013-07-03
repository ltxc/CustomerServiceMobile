//
//  DataController.h
//  CustomerServiceMobile
//
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#define kCoreDataSynchNotificationStatusKey @"status"
#define kCoreDataSynchNotificationMessageKey @"message"
#define kCoreDataSynchNotificationRecordTemplate @"%@: %d records received..."
#define kCoreDataSynchNotificationFailedTemplate @"Server may not be reachable. Detail:%@"

typedef RKManagedObjectMapping*(^DataSynchEntityMappingBlock)(RKManagedObjectStore*);
typedef NSString*(^DataSynchResourcePathBlock)(NSString* baseUrl);
typedef NSString*(^DataSynchNotificationMessageBlock)(id objects);

@interface DataSynchBase : NSObject <RKObjectLoaderDelegate>
@property (strong,atomic) RKObjectManager* objectManager;
@property (strong,atomic) NSString* controllerName;
@property (atomic) NSNumber* status;
@property (strong,atomic) NSString* message;
@property (strong,atomic) NSString* url;
@property (strong,nonatomic) NSString* notificationName;
@property (strong,nonatomic) RKManagedObjectStore* objectStore;

-(id)init:(NSString*)controllerName notificationName:(NSString*)notificationName;
-(RKObjectManager *) setAuthentication:(RKRequestAuthenticationType) authType username:(NSString*) username  password:(NSString*)password;
-(void)reset;

-(void)addNotificationObserver:(id)observer notificationName:(NSString*)notificationName selector:(SEL)selector;
-(void)removeNotificationObserver:(id) observer notificationName:(NSString*)notificationName;
-(void)notify:(NSString*) notificationName status:(NSNumber*) status message:(NSString*) message object:(id) object;
@end
