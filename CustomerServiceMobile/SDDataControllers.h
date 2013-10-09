//
//  SDDataSynchControllers.h
//  SFCMobile
//
//  Created by Jinsong Lu on 7/22/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "ZSCoreDataGetSynch.h"
#import "UserProfileController.h"
#import "ZSTransientDataGetSynch.h"
#import "ZSRestDataPostSynch.h"


@interface SDDataControllers : NSObject
@property (strong,atomic) NSString* username;
@property (strong,atomic) NSString* password;
@property (strong,atomic) NSString* appurl;
@property (strong,atomic) NSString* appname;
@property (strong,nonatomic) NSMutableDictionary* repairs;
+(SDDataControllers*)shared;

-(SDDataControllers *) setAuthentication:(NSString*) username password:(NSString *) password appurl:(NSString*)appurl appname:(NSString*)appname;

+(ZSTransientDataGetSynch *) sharedAssignStationController;

//assign station
-(void)assignStation:(NSString *)orderId serialNo:(NSString *)serialNo stationId:(NSString *)stationId clientId:(NSString *) clientId;

@end
