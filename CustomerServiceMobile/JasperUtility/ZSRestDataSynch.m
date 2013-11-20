//
//  CoreDataSynch.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/16/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSRestDataSynch.h"

#import "ZSGUIHelper.h"


@implementation ZSRestDataSynch
@synthesize objectStore=_objectStore;
@synthesize baseURL=_baseURL;
@synthesize rootKeyPath=_rootKeyPath;
@synthesize notificationMessageBlock=_notificationMessageBlock;
@synthesize result=_result;
@synthesize isASynch=_isASynch;
@synthesize resultHandlingBlock=_resultHandlingBlock;
@synthesize sourceMapping=_sourceMapping;
@synthesize targetMapping=_targetMapping;

-(id)init:(NSString*)controllerName appurl:(NSString*)appurl appname:(NSString*)appname objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName mapBlock:(ZSRestDataSynchEntityMappingBlock)mapBlock  resultHandlingBlock:(ZSDatSynchResultHandlingBlock)resultHandlingBlock
{
    
    
    if(self = [super init:controllerName notificationName:notificationName appurl:appurl appname:appname])
    {
        _isASynch = YES;
        _objectStore = objectStore;
        _baseURL = baseURL;
        _rootKeyPath = rootKeyPath;
        _mapBlock = mapBlock;
        _resultHandlingBlock = resultHandlingBlock;
        
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
            self.message = [NSString stringWithFormat:kZSRestDataSynchNotificationRecordTemplate,self.controllerName, count];
        }
        
        //Commit everything in context to the database
        if (_objectStore!=nil) {
            [self saveRKCache];
        }

        
        if(_isASynch)
        {
            //notify synch finished
            [self notify:super.notificationName status:self.status message:self.message object:objects];
        }  
    
    }
}


-(void)loadGet:(ZSDataSynchResourcePathBlock)resourcePathBlock
{
    [self reset];
    @try {
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
     @catch (NSException *exception) {
         NSString* message = [NSString stringWithFormat:@"Server does not response corrrectly. %@", [exception reason] ];
         [ZSGUIHelper alert:message title:@"Error" template:nil delegate:nil];
     }
     @finally {
    
     }
}


-(void)loadPost:(id)postedObject
{
    [self reset];

    RKObjectLoader *loader = [self.objectManager loaderForObject:postedObject
                                                          method:RKRequestMethodPOST];
    loader.serializationMIMEType = RKMIMETypeJSON;
    
    loader.delegate = self;
    loader.method = RKRequestMethodPOST;
    loader.sourceObject = postedObject;
    loader.targetObject = nil;
    [loader setCacheTimeoutInterval:0.1];
    if(self.isASynch)
    {
        [loader send];
    }
    else{
        
        [loader sendSynchronously];
    }

}


-(RKObjectMapping *)entityMapping:(RKManagedObjectStore*)objectStore
{
    if (objectStore!=nil) {
        self.objectManager.objectStore = objectStore;
    }
    return _mapBlock(objectStore);
}


@end
