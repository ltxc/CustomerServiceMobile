
#import "RPInformationController.h"
#import "SharedConstants.h"
@implementation RPInformationController
RPInformation* _rpInformation;
-(id)init
{
    if(self = [super init:kEntityRPInformation notificationName:nil])
    {
        //register the mapping provider
        RKObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kRootPathRPInformation];
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
    
    if(object!=nil&&[object isKindOfClass:[RPInformation class]])
    {
        _rpInformation = (RPInformation*)object;
    }
}

-(RPInformation *)query:(NSString*)request_id
{
    _rpInformation=nil;
    [self reset];
    NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamRPInformationRequestID,request_id, nil];
    NSString *resourcePath = [kUrlBaseRPInformation appendQueryParams:dictionary];
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:resourcePath];
    
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    [loader setCacheTimeoutInterval:60];
    [loader sendSynchronously];
    
    
    return _rpInformation;
}


-(RKObjectMapping *) entityMapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[RPInformation class]];
    [mapping mapAttributes:kKeyPathRPInformationCconthID,kKeyPathRPInformationDestWarehouseID,kKeyPathRPInformationPcodeID,kKeyPathRPInformationPOID,kKeyPathRPInformationPriority,kKeyPathRPInformationRequestID,kKeyPathRPInformationWarrTypeID,nil];

    return mapping;
}


@end
