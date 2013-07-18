//
//  CoreDataSynch.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/16/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "CoreDataSynch.h"



@implementation CoreDataSynch
@synthesize objectStore=_objectStore;
@synthesize baseURL=_baseURL;
@synthesize rootKeyPath=_rootKeyPath;
@synthesize notificationMessageBlock=_notificationMessageBlock;
@synthesize result=_result;
@synthesize isASynch=_isASynch;

DataSynchEntityMappingBlock _mapBlock;

-(id)init:(NSString*)controllerName objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName mapBlock:(DataSynchEntityMappingBlock)mapBlock
{
    if(self = [super init:controllerName notificationName:notificationName])
    {
        _isASynch = YES;
        _objectStore = objectStore;
        _baseURL = baseURL;
        _rootKeyPath = rootKeyPath;
        _mapBlock = mapBlock;
        
    }
    return self;
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    if(_isASynch)
    {
        //notify synch finished
        [super notify:self.notificationName status:self.status message:self.message object:nil];
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
            NSUInteger count = [objects count];
            self.message = [NSString stringWithFormat:kCoreDataSynchNotificationRecordTemplate,self.controllerName, count];
        }
        if(_isASynch)
        {
            //notify synch finished
            [self notify:super.notificationName status:self.status message:self.message object:objects];
        }
        [self saveRKCache];  
    }
}





-(RKManagedObjectMapping *) entityMapping
{
    self.objectManager.objectStore = _objectStore;
    return _mapBlock(_objectStore);
}

@end
