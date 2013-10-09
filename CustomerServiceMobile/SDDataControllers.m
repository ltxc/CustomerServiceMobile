//
//  SDDataSynchControllers.m
//  SFCMobile
//
//  Created by Jinsong Lu on 7/22/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "SDDataControllers.h"
#import "SharedConstants.h"
#import "ZSSDDataEngine.h"
#import "SDUserPreference.h"
#import "ZSGUIHelper.h"
#import "ZSProcessResult.h"
#import "UserProfile.h"



@implementation SDDataControllers
@synthesize username=_username;
@synthesize password=_password;
@synthesize appname=_appname;
@synthesize appurl=_appurl;
@synthesize repairs=_repairs;



+(SDDataControllers *)shared
{
    static SDDataControllers *sharedDataSynchControllers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataSynchControllers = [[SDDataControllers alloc] init];
    });
    
    return sharedDataSynchControllers;
}

-(SDDataControllers *) setAuthentication:(NSString*) username password:(NSString *) password  appurl:(NSString*)appurl appname:(NSString*)appname
{
    self.username = username;
    self.password = password;
    self.appname = appname;
    self.appurl = appurl;
    return self;
}



+(ZSTransientDataGetSynch *) sharedAssignStationController
{
    static ZSTransientDataGetSynch *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initialize the TransientDataGetSynch object
        sharedController = [[ZSTransientDataGetSynch alloc] init:@"Assign Station" appurl:[SDUserPreference sharedUserPreference].ServiceServer appname:[SDUserPreference sharedUserPreference].ServiceAPPName baseURL:kUrlBaseAssignStation  rootKeyPath:kKeyPathProcessResult notificationName:kNotificationAssignStation mapBlock:^(RKManagedObjectStore * objectStore) {
            RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[ZSProcessResult class]];
            [mapping mapAttributes:kKeyPathProcessResultTransactionID,kKeyPathProcessResultType,kKeyPathProcessResultStatus,kKeyPathProcessResultMessage,kKeyPathProcessResultDate, nil];
            
            return mapping;
        } resultHandlingBlock:^BOOL(id postedObject, id result) {
            return YES;
        }
                            ];
        
    });
    sharedController.isASynch = YES;
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDDataControllers shared].username password:[SDDataControllers shared].password];
    
    return sharedController;
}


//Assign Station Controller Calling
-(void)assignStation:(NSString *)orderId serialNo:(NSString *)serialNo stationId:(NSString *)stationId clientId:(NSString *) clientId
{
    
    
    ZSTransientDataGetSynch* controller = [SDDataControllers sharedAssignStationController];
    
    
    [controller addNotificationObserver:self notificationName:kNotificationAssignStation selector:@selector(synchNotifiedAssignStation:)];
    
    
    [controller load:^(NSString* baseUrl,id postedObject){
        NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamOrderId,orderId,kQueryParamSerialNo,serialNo,kQueryParamStationId,stationId, kQueryParamClientId, clientId, nil];
        return [kUrlBaseAssignStation stringByAppendingQueryParameters:dictionary];
    }];
}

-(void) synchNotifiedAssignStation:(NSNotification *)notification
{
    
    ZSProcessResult* processResult = (ZSProcessResult*)[(NSArray*)notification.object objectAtIndex:0];
    
    NSString* message = processResult.process_message;
    NSString* status = processResult.process_status;
    
    if ([status isEqual:@"COMPLETED"]&&notification.object!=nil) {
        
        [ZSGUIHelper alert:message title:@"Process Result" template:nil delegate:nil];
        
    }
    
    else
    {
        [ZSGUIHelper alert:message title:@"Process Result" template:nil delegate:nil];
        
    }
    
    [[SDDataControllers sharedAssignStationController]removeNotificationObserver:self notificationName:kNotificationAssignStation];
    
    
    
}



@end
