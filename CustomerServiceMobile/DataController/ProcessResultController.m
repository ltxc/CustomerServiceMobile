//
//  ProcessResultController.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/14/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ProcessResultController.h"
#import "MyRestkit.h"
#import "ProcessResult.h"

@implementation ProcessResultController
ProcessResult* _processResult;

-(id)init
{
    if(self = [super init:kEntityProcessResult  notificationName:nil])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:@""];

    }
    return self;
}
-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError: %@",[error localizedDescription]);
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
}



-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    [super request:request didLoadResponse:response];
    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    
    if(object!=nil&&[object isKindOfClass:[ProcessResult class]])
    {
        _processResult = (ProcessResult*)object;
    }
}
-(ProcessResult*)query:(NSString*)ipad_id type:(NSString*)type
{
    _processResult = nil;
    [self reset];
    
    NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamIPADID,ipad_id,kQueryParamType,type, nil];
    NSString *resourcePath = [kUrlBaseProcessResult appendQueryParams:dictionary];
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:resourcePath];
    
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    [loader setCacheTimeoutInterval:60];
    [loader sendSynchronously];
    
    
    return _processResult;

}



-(RKObjectMapping *) entityMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[ProcessResult class]];
    [mapping mapAttributes:kKeyPathProcessResultDate,kKeyPathProcessResultMessage,kKeyPathProcessResultStatus,kKeyPathProcessResultTransactionID,kKeyPathProcessResultType,nil];
    
    return mapping;
}
@end
