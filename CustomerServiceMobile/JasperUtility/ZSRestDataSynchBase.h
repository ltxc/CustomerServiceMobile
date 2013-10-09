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

#define kZSRestDataSynchNotificationStatusKey @"status"
#define kZSRestDataSynchNotificationMessageKey @"message"
#define kZSRestDataSynchNotificationResult @"result"
#define kZSRestDataSynchNotificationRecordTemplate @"%@: %d records received..."
#define kZSRestDataSynchNotificationFailedTemplate @"Server may not be reachable. Detail:%@"

typedef RKObjectMapping*(^ZSRestDataSynchEntityMappingBlock)(RKManagedObjectStore*);
typedef NSString*(^ZSDataSynchResourcePathBlock)(NSString* baseUrl, id postedObject);
typedef NSString*(^ZSDataSynchNotificationMessageBlock)(id objects);
typedef BOOL(^ZSDatSynchResultHandlingBlock)(id postedObject, id result);

@interface ZSRestDataSynchBase : NSObject <RKObjectLoaderDelegate>
@property (strong,atomic) RKObjectManager* objectManager;
@property (strong,atomic) NSString* controllerName;
@property (strong,atomic) NSString* appname;
@property (strong,atomic) NSString* appurl;
@property (atomic) NSNumber* status;
@property (strong,atomic) NSString* message;
@property (strong,atomic) NSString* url;
@property (strong,nonatomic) NSString* notificationName;
@property (strong,nonatomic) RKManagedObjectStore* objectStore;

-(id)init:(NSString*)controllerName notificationName:(NSString*)notificationName appurl:(NSString*)appurl appname:(NSString*)appname;
-(RKObjectManager *) setAuthentication:(RKRequestAuthenticationType) authType username:(NSString*) username  password:(NSString*)password ;
-(void)reset;

-(void)addNotificationObserver:(id)observer notificationName:(NSString*)notificationName selector:(SEL)selector;
-(void)removeNotificationObserver:(id) observer notificationName:(NSString*)notificationName;
-(void)notify:(NSString*) notificationName status:(NSNumber*) status message:(NSString*) message object:(id) object;
-(NSNumber*) getNotificationStatus:(NSNotification *)notification;
-(NSString*)getNofiticationInfo:(NSNotification *)notification actionname:(NSString*) actionName;
-(void)saveRKCache;
@end
