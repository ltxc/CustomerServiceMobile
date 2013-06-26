//
//  SFRepairStationSynchController.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "SFRepairStationSynchController.h"
#import "MyRestkit.h"
#import "RepairStation.h"

@implementation SFRepairStationSynchController
@synthesize repairStations=_repairStations;

-(id)init
{
    if(self = [super init:kEntityCarrier])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kKeyPathCarrier];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseCarrier withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [RepairStation fetchRequest];
        }];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    //notify synch finished
    [[SDRestKitEngine sharedEngine] notify:kNotificationNameCarrier status:self.status message:self.message object:nil];
}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    if(nil!=objects)
    {
        _repairStations= objects;
        self.message = [NSString stringWithFormat:kMessageSynchRecordTemplate, [objects count]];
        //notify synch finished
        [[SDRestKitEngine sharedEngine] notify:kNotificationNameCarrier status:self.status message:self.message object:objects];
        [[SDDataEngine sharedEngine] saveRKCache];
        
    }
}

-(void)load
{
    [self reset];
    NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
    NSString *resourcePath = [kUrlBaseCarrier appendQueryParams:dictionary];
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:resourcePath];
    
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    [loader setCacheTimeoutInterval:0.1];
    [loader send];
}



-(RKManagedObjectMapping *) entityMapping
{
    RKManagedObjectStore* objectStore = [[SDDataEngine sharedEngine] rkManagedObjectStore];
    
    self.objectManager.objectStore = objectStore;
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[RepairStation class] inManagedObjectStore:objectStore];
    [mapping mapAttributes:kKeyPathCarrierCarrierID,kKeyPathLastChangeDate, nil];
    [mapping mapKeyPath:kKeyPathServerID toAttribute:kAttributeServerID];
    
    mapping.primaryKeyAttribute = kKeyPathCarrierCarrierID;
    return mapping;
}

@end
