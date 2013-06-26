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
@interface DataSynchController : NSObject <RKObjectLoaderDelegate>
@property (strong,atomic) RKObjectManager* objectManager;
@property (strong,atomic) NSString* controllerName;
@property (atomic) NSNumber* status;
@property (strong,atomic) NSString* message;
@property (strong,atomic) NSString* url;

-(id)init:(NSString*)controllerName;
-(RKObjectManager *) setAuthentication:(RKRequestAuthenticationType) authType username:(NSString*) username  password:(NSString*)password;
-(void)reset;

@end
