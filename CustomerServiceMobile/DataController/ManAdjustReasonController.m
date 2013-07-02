//
//  ManAdjustReasonController.m
//  CustomerServiceMobile


#import "ManAdjustReasonController.h"
#import "ManAdjustReason.h"
#import "MyRestkit.h"
@implementation ManAdjustReasonController
@synthesize reasons=_reasons;
-(id)init
{
    if(self = [super init:kEntityManAdjustReason notificationName:nil])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kKeyPathManAdjustReason];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseManAdjustReason withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [ManAdjustReason fetchRequest];
        }];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    //notify synch finished
    [[SDRestKitEngine sharedEngine] notify:kNotificationNameManAdjustReason status:self.status message:self.message object:nil];
}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    if(nil!=objects)
    {
        _reasons = objects;
        self.message = [NSString stringWithFormat:kMessageSynchRecordTemplate, [objects count]];
        //notify synch finished
        [[SDRestKitEngine sharedEngine] notify:kNotificationNameManAdjustReason status:self.status message:self.message object:objects];
        [[SDDataEngine sharedEngine] saveRKCache];
        
    }
}

-(void)load
{
    [self reset];
    NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
    NSString *resourcePath = [kUrlBaseManAdjustReason appendQueryParams:dictionary];
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
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[ManAdjustReason class] inManagedObjectStore:objectStore];
    [mapping mapKeyPath:kKeyPathManAdjustReasonReasonCode toAttribute:kAttributeManAdjustReasonReasonCode];
    [mapping mapKeyPath:kKeyPathManAdjustReasonDescription toAttribute:kAttributeManAdjustReasonDescription];

    
    mapping.primaryKeyAttribute = kKeyPathManAdjustReasonReasonCode;
    return mapping;
}

@end
