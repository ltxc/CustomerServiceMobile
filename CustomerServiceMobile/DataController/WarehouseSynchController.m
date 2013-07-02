//
//  WarehouseSynchController.m
//  CustomerServiceMobile
//
//  Created by LTXC on 11/28/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "WarehouseSynchController.h"
#import "Warehouse.h"
#import "MyRestkit.h"

@implementation WarehouseSynchController
@synthesize warehouses=_warehouses;
-(id)init
{
    if(self = [super init:kEntityWarehouse notificationName:nil])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kKeyPathWarehouse];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseWarehouse withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [Warehouse fetchRequest];
        }];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    //notify synch finished
    [[SDRestKitEngine sharedEngine] notify:kNotificationNameWarehouse status:self.status message:self.message object:nil];
}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    if(nil!=objects)
    {
        _warehouses = objects;
        self.message = [NSString stringWithFormat:kMessageSynchRecordTemplate, [objects count]];
        //notify synch finished
        [[SDRestKitEngine sharedEngine] notify:kNotificationNameWarehouse status:self.status message:self.message object:objects];
        [[SDDataEngine sharedEngine] saveRKCache];
        
    }
}

-(void)load
{
    [self reset];
    NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
    NSString *resourcePath = [kUrlBaseWarehouse appendQueryParams:dictionary];
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
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[Warehouse class] inManagedObjectStore:objectStore];
    [mapping mapAttributes:kKeyPathWarehouseWarehouseID,kKeyPathWarehouseDescr, nil];
    //[mapping mapKeyPath:kKeyPathWarehouseWarehouseID toAttribute:kAttributeWarehouseWarehouseId];
    //[mapping mapKeyPath:kKeyPathWarehouseDescr toAttribute:kAttributeWarehouseDescr];
     mapping.primaryKeyAttribute = kKeyPathWarehouseWarehouseID;
    return mapping;
}

@end
