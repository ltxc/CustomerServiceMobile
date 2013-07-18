//
//  RepairMasterDataSynch.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/28/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "RepairMasterDataSynch.h"
#import "SharedConstants.h"
#import "CoreDataGetSynch.h"
#import "ActionCode.h"
#import "StopCode.h"
#import "RepairStation.h"
#import "Activity.h"


@implementation RepairMasterDataSynch
@synthesize notificationName=_notificationName;
@synthesize objectStore=_objectStore;
@synthesize coreDataSynchObjects=_coreDataSynchObjects;

-(id)init:(NSString*)notificationName objectStore:( RKManagedObjectStore*)objectStore
{
    if(self=[super init:@"RepairMasterDataSynch" notificationName:notificationName])
    {
        _notificationName=notificationName;
        _objectStore=objectStore;
        
        //create all repair master data synch objects here
        //Action Code
        CoreDataGetSynch* actionCodeSynch =[ [CoreDataGetSynch alloc] init:@"Action Code" objectStore:objectStore baseURL:kUrlBaseActionCode rootKeyPath:kKeyPathActionCode notificationName:nil mapBlock:^(RKManagedObjectStore *objectStore) {
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[ActionCode class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathActionCodeCodeID,kKeyPathActionCodeActivityID, kKeyPathActionCodeDescr,nil];            
            
            mapping.primaryKeyAttribute = kKeyPathActionCodeCodeID;
            return mapping;
        } fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [ActionCode fetchRequest];
        }];
        actionCodeSynch.isASynch = NO;
        
        //Activity
        CoreDataGetSynch* activitySynch = [[CoreDataGetSynch alloc] init:@"Activity" objectStore:objectStore baseURL:kUrlBaseActivity rootKeyPath:kKeyPathActivity notificationName:nil mapBlock:^(RKManagedObjectStore *objectStore) {
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[Activity class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathActivityActivityID,kKeyPathActivityBPartGCLID, kKeyPathActivityDescr,nil];
            
            mapping.primaryKeyAttribute = kKeyPathActivityActivityID;
            return mapping;

            
        } fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [Activity fetchRequest];
        }];
        activitySynch.isASynch = NO;
        
        //RepairStation
        CoreDataGetSynch* repairStationSynch = [[CoreDataGetSynch alloc]init:@"Repair Station" objectStore:objectStore baseURL:kUrlBaseRepairStation rootKeyPath:kKeyPathRepairStation notificationName:nil mapBlock:^(RKManagedObjectStore *objectStore) {
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[RepairStation class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathRepairStationStationID,kKeyPathRepairStationWarehouseID, kKeyPathRepairStationDescr,nil];
            
            mapping.primaryKeyAttribute = kKeyPathRepairStationStationID;
            return mapping;

        } fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [RepairStation fetchRequest];
        }];
        repairStationSynch.isASynch = NO;
        
        //StopCode
        CoreDataGetSynch* stopCodeSynch = [[CoreDataGetSynch alloc] init:@"Stop Code" objectStore:objectStore baseURL:kUrlBaseStopCode rootKeyPath:kKeyPathStopCode notificationName:nil mapBlock:^(RKManagedObjectStore *objectStore) {
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[StopCode class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathStopCodeStopCodeID,kKeyPathStopCodeDescr,nil];
            
            mapping.primaryKeyAttribute = kKeyPathStopCodeStopCodeID;
            return mapping;
        } fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [StopCode fetchRequest];
        }];
        stopCodeSynch.isASynch = NO;
        
        
        _coreDataSynchObjects = [NSArray arrayWithObjects:actionCodeSynch,activitySynch,repairStationSynch,stopCodeSynch, nil];
    }
    return self;
}

//Don't use the return RKObjectManager, which has nothing to do with each of the RKObjectManager within the associated CoreDataSynch object.
-(RKObjectManager *)setAuthentication:(RKRequestAuthenticationType)authType username:(NSString *)username password:(NSString *)password
{
    if (_coreDataSynchObjects) {
        for (CoreDataGetSynch* coreDataSynch in _coreDataSynchObjects) {
            [coreDataSynch setAuthentication:authType username:username password:password];
        }
    }
    return self.objectManager;
}

-(void)load
{
    NSString* template = @"%@\n%@";
    if (_coreDataSynchObjects) {
        self.status = [NSNumber numberWithInt:1];
        self.message = @"";
        for (CoreDataGetSynch* coreDataSynch in _coreDataSynchObjects) {
           //proces each one
            [coreDataSynch load:nil];
            if (![coreDataSynch.status isEqualToNumber:[NSNumber numberWithInt:1]]) {
                self.status = coreDataSynch.status;
            }
            if ([self.message length]==0) {
                self.message = coreDataSynch.message;
            }
            else
            {
                self.message = [NSString stringWithFormat:template,self.message,coreDataSynch.message];
            }
        }
    }  
    
    //send notification
    [self notify:_notificationName status:self.status message:self.message object:nil];
}

@end
