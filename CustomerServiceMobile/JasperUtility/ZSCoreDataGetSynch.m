//
//  CoreDataSynch.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/26/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSCoreDataGetSynch.h"

@implementation ZSCoreDataGetSynch



-(id)init:(NSString*)controllerName appurl:(NSString*)appurl appname:(NSString*)appname objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName  mapBlock:(ZSRestDataSynchEntityMappingBlock)mapBlock fetchBlock:(RKObjectMappingProviderFetchRequestBlock)fetchRequestBlock
{
    if(self = [super init:controllerName appurl:appurl appname:appname objectStore:objectStore baseURL:baseURL rootKeyPath:rootKeyPath notificationName:notificationName mapBlock:mapBlock resultHandlingBlock:nil])
    {
        
          
        //register the mapping provider
        RKObjectMapping* mapping = [self entityMapping:objectStore];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:rootKeyPath];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:self.baseURL withFetchRequestBlock:fetchRequestBlock];
    }
    return self;
}


-(void)load:(ZSDataSynchResourcePathBlock)resourcePathBlock
{
    [super loadGet:resourcePathBlock];
}





@end
