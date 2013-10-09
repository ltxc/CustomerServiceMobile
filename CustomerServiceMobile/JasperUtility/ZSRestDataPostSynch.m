//
//  CoreDataPostSynch.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/3/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSRestDataPostSynch.h"

@implementation ZSRestDataPostSynch


id _zspostedObject = nil;

-(id)init:(NSString *)controllerName appurl:(NSString*)appurl appname:(NSString*)appname objectStore:(RKManagedObjectStore *)objectStore baseURL:(NSString *)baseURL rootKeyPath:(NSString *)rootKeyPath notificationName:(NSString *)notificationName  postedObjectClass:(Class)postedObjectClass  mapBlock:(ZSRestDataSynchEntityMappingBlock)mapBlock targetMapBlock:(ZSRestDataSynchEntityMappingBlock)targetMapBlock  resultHandlingBlock:(ZSDatSynchResultHandlingBlock)resultHandlingBlock
{
    if(self = [super init:controllerName appurl:appurl appname:appname objectStore:objectStore baseURL:baseURL rootKeyPath:rootKeyPath notificationName:notificationName mapBlock:mapBlock resultHandlingBlock:resultHandlingBlock])
    {
        self.targetMapBlock = targetMapBlock;
        //register the mapping provider
        _postedObjectClass = postedObjectClass;
        
        self.sourceMapping = [self entityMapping:nil];
        
        RKObjectMapping* serializationMapping = [self.sourceMapping inverseMapping]; //object-c=>json
        
        if (targetMapBlock==nil) {
            self.targetMapping = self.sourceMapping;
        }
        else
            self.targetMapping = targetMapBlock(nil);
        [self.objectManager.router routeClass:postedObjectClass toResourcePath:baseURL];
        [self.objectManager.mappingProvider setSerializationMapping:serializationMapping forClass:postedObjectClass];
        [self.objectManager.mappingProvider setObjectMapping:self.targetMapping forResourcePathPattern:baseURL];
        
    }
    return self;
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    //override to handle posted object
    if(nil!=objects&&nil!=self.resultHandlingBlock)
    {
        _isOK = self.resultHandlingBlock(_zspostedObject, objects);
    }
    
    if(nil!=objects)
    {
        self.status = [NSNumber numberWithInt:1];
        self.result = objects;
        if (nil!=self.notificationMessageBlock) {
            self.message = self.notificationMessageBlock(objects);
        }
        else
        {
            NSUInteger count = [objects count];
            self.message = [NSString stringWithFormat:kZSRestDataSynchNotificationRecordTemplate,self.controllerName, count];
        }
        if(self.isASynch)
        {
            //notify synch finished
            [self notify:super.notificationName status:self.status message:self.message object:objects];
        }
        
        //be careful here. The object store is forced to save...
        if (self.objectStore!=nil) {
            [self saveRKCache];
        }
    }

}




-(void)loadPost:(id)postedObject
{
    [super loadPost:postedObject];
}
@end
