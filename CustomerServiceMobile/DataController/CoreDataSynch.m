//
//  CoreDataSynch.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/26/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "CoreDataSynch.h"

@implementation CoreDataSynch
@synthesize objectStore=_objectStore;
@synthesize baseURL=_baseURL;
@synthesize rootKeyPath=_rootKeyPath;
@synthesize notificationName=_notificationName;
@synthesize notificationMessageBlock=_notificationMessageBlock;
@synthesize result=_result;
@synthesize isASynch=_isASynch;

DataSynchEntityMappingBlock _mapBlock;


-(id)init:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName  mapBlock:(DataSynchEntityMappingBlock)mapBlock fetchBlock:(RKObjectMappingProviderFetchRequestBlock)fetchRequestBlock
{
    if(self = [super init:@"CoreDataSynch"])
    {
        _isASynch = YES;
        _objectStore = objectStore;
        _baseURL = baseURL;
        _rootKeyPath = rootKeyPath;
        _notificationName = notificationName;
        _mapBlock = mapBlock;
        
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:rootKeyPath];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:_baseURL withFetchRequestBlock:fetchRequestBlock];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    if(_isASynch)
    {
        //notify synch finished
        [self notify:_notificationName status:self.status message:self.message object:nil];
    }
}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    if(nil!=objects)
    {
        _result = objects;
        if (nil!=_notificationMessageBlock) {
            self.message = _notificationMessageBlock(objects);
        }
        else
        {
            NSUInteger count = 0;
            if ([objects isKindOfClass:[NSArray class]]) {
                count = [(NSDictionary*)objects count];
            }
           
            self.message = [NSString stringWithFormat:kCoreDataSynchNotificationRecordTemplate, count];
        }
        if(_isASynch)
        {
        //notify synch finished
        [self notify:_notificationName status:self.status message:self.message object:objects];
        }
        [self saveRKCache];
        
    }
}

-(void)load:(DataSynchResourcePathBlock)resourcePathBlock
{
    [self reset];

    NSString *resourcePath = _baseURL;
    if(resourcePathBlock!=nil)
    {
        resourcePath = resourcePathBlock(_baseURL);
    }
    
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:resourcePath];
    
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    [loader setCacheTimeoutInterval:0.1];
    if(_isASynch)
    {
        [loader send];
    }
    else{
       [loader sendSynchronously];
    }

}



-(RKManagedObjectMapping *) entityMapping
{
    self.objectManager.objectStore = _objectStore;
    return _mapBlock(_objectStore);
}


#pragma mark - Notification

-(void)notify:(NSString*) notificationName status:(NSNumber*) status message:(NSString*) message object:(id) object
{
    
    if(notificationName!=nil)
    {
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithKeysAndObjects:kCoreDataSynchNotificationStatusKey,status,kCoreDataSynchNotificationMessageKey, message, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:object userInfo:userInfo];
    }
}


-(void)addNotificationObserver:(id) observer selector:(SEL)selector
{
    if(nil!=observer)
    {
        [self removeNotificationObserver:observer notificationName:_notificationName];
        [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:_notificationName object:nil];
    }
    
    
}
-(void)removeNotificationObserver:(id) observer notificationName:(NSString*)notificationName
{
    
    if(nil!=observer)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:notificationName object:nil];
    }
}


-(void)saveRKCache
{
    NSError* error = nil;
    [self.objectStore.managedObjectContextForCurrentThread save:&error];
    if(error)
    {
        NSLog(@"RK Cache Save failed: %@", error);
    }
}

@end
