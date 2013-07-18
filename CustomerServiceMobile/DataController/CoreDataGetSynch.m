//
//  CoreDataSynch.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/26/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "CoreDataGetSynch.h"

@implementation CoreDataGetSynch



-(id)init:(NSString*)controllerName objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName  mapBlock:(DataSynchEntityMappingBlock)mapBlock fetchBlock:(RKObjectMappingProviderFetchRequestBlock)fetchRequestBlock
{
    if(self = [super init:controllerName objectStore:objectStore baseURL:baseURL rootKeyPath:rootKeyPath notificationName:notificationName mapBlock:mapBlock])
    {
        
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:rootKeyPath];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:self.baseURL withFetchRequestBlock:fetchRequestBlock];
    }
    return self;
}


-(void)load:(DataSynchResourcePathBlock)resourcePathBlock
{
    [self reset];
    
    NSString *resourcePath = self.baseURL;
    if(resourcePathBlock!=nil)
    {
        resourcePath = resourcePathBlock(self.baseURL, nil);
    }
    
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:resourcePath];
    
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    [loader setCacheTimeoutInterval:0.1];
    if(self.isASynch)
    {
        [loader send];
    }
    else{
        
        [loader sendSynchronously];
    }
    
}





@end
