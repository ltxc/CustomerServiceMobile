//
//  CoreDataPostSynch.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/3/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "CoreDataPostSynch.h"

@implementation CoreDataPostSynch
@synthesize resultHandlingBlock=_resultHandlingBlock;
@synthesize isOK = _isOK;
id _postedObject = nil;

-(id)init:(NSString *)controllerName objectStore:(RKManagedObjectStore *)objectStore baseURL:(NSString *)baseURL rootKeyPath:(NSString *)rootKeyPath notificationName:(NSString *)notificationName  postedObjectClass:(Class)postedObjectClass  mapBlock:(DataSynchEntityMappingBlock)mapBlock resultHandlingBlock:(DatSynchResultHandlingBlock)resultHandlingBlock
{
    if(self = [super init:controllerName objectStore:objectStore baseURL:baseURL rootKeyPath:rootKeyPath notificationName:notificationName mapBlock:mapBlock])
    {
        
        //register the mapping provider
        _resultHandlingBlock = resultHandlingBlock;
        _postedObjectClass = postedObjectClass;
        
        [self.objectManager.router routeClass:postedObjectClass toResourcePath:baseURL forMethod:RKRequestMethodPOST];
        
        RKObjectMapping* mapping = [self entityMapping];

        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:rootKeyPath];
        RKObjectMapping* serializationMapping = [mapping inverseMapping];
        
        [self.objectManager.mappingProvider setSerializationMapping:serializationMapping forClass:postedObjectClass];
    }
    return self;
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    [super objectLoader:objectLoader didLoadObject:object];
    if(nil!=object&&nil!=_resultHandlingBlock)
    {
        _isOK = _resultHandlingBlock(_postedObject, object);
    }
    
}


-(BOOL)load:(id)postedObject
{
    [self reset];
    _isOK = NO;
    RKObjectLoader *loader = [self.objectManager loaderForObject:postedObject
                                                          method:RKRequestMethodPOST];
    loader.serializationMIMEType = RKMIMETypeJSON;
    
    loader.delegate = self;
    loader.method = RKRequestMethodPOST;
    
    [loader setCacheTimeoutInterval:0.1];
    if(self.isASynch)
    {
        [loader send];
    }
    else{
        
        [loader sendSynchronously];
    }

    return _isOK;
    
}
@end
