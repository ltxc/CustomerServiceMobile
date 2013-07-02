

#import "CycleCountController.h"
#import "MyRestkit.h"
#import "CycleCountProxy.h"
#import "CycleCountCount.h"

@implementation CycleCountController
@synthesize isBinCount=_isBinCount;
BOOL _isOK;
CycleCountMaster* _cycleCountMaster;
CycleCountProxy* _cycleCountProxy;

-(id)init
{
    if(self = [super init:@"CycleCount" notificationName:nil])
    {
        [self.objectManager.router routeClass:[CycleCountProxy class] toResourcePath:kUrlBaseCycleCount forMethod:RKRequestMethodPOST];
        
        RKObjectMapping* mapping = [self cycleCountMapping];

        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:@""];
        RKObjectMapping* serializationMapping = [mapping inverseMapping];
        
        [self.objectManager.mappingProvider setSerializationMapping:serializationMapping forClass:[CycleCountProxy class]];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];

}

-(void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader
{
    NSLog(@"Unexpected response %@", [[objectLoader response] description]);
}


-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    [super objectLoader:objectLoader didLoadObject:object];
    if(nil!=object)
    {
        CycleCountProxy* result = (CycleCountProxy*)object;
        if(nil!=result)
        {
            NSLog(@"status:%@; date:%@; message:%@",result.process_status,[result.process_date description],result.process_message);
            _cycleCountMaster.process_message = result.process_message;
            _cycleCountMaster.process_status = result.process_status;
            _cycleCountMaster.process_date = result.process_date;
            if([kProcessStatusCOMPLETED isEqualToString:result.process_status])
            {
                _isOK = TRUE;
            }
            [[SDDataEngine sharedEngine] save:_cycleCountMaster];
        }
    }
    
    
}


-(BOOL)post:(CycleCountMaster*)cycleCountMaster{
    
    _isOK = FALSE;
    _cycleCountMaster = cycleCountMaster;
    CycleCountProxy* proxy = [[CycleCountProxy alloc] initWithCycleCountMaster:cycleCountMaster];
    //set rest of value
    proxy.who = [SDUserPreference sharedUserPreference].LastLogin;
    proxy.warehouse_id = [SDUserPreference sharedUserPreference].DefaultWarehouseID;
    proxy.isclear = @"Y";
    
    RKObjectLoader *loader = [self.objectManager loaderForObject:proxy
                                                          method:RKRequestMethodPOST];
    loader.serializationMIMEType = RKMIMETypeJSON;
    
    loader.delegate = self;
    loader.method = RKRequestMethodPOST;

    
    [loader setCacheTimeoutInterval:0.1];
    [loader sendSynchronously];
    
    return _isOK;

}



-(RKObjectMapping *) cycleCountMapping
{
    
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[CycleCountProxy class]];
    [mapping mapAttributes:kKeyPathProcessResultStatus,kKeyPathProcessResultMessage,kKeyPathProcessResultDate,nil];
    
    [mapping mapKeyPath:kKeyPathCycleCountWho toAttribute:kAttributeCycleCountWho];
    [mapping mapKeyPath:kKeyPathCycleCountWarehouseID toAttribute:kAttributeCycleCountWarehouseID];
    [mapping mapKeyPath:kKeyPathCycleCountCycleType toAttribute:kAttributeCycleCountCycleType];
    [mapping mapKeyPath:kKeyPathCycleCountBinCodeID toAttribute:kAttributeCycleCountBinCodeID];
    [mapping mapKeyPath:kKeyPathCycleCountBpartID toAttribute:kAttributeCycleCountBpartID];
    [mapping mapKeyPath:kKeyPathCycleCountIsClear toAttribute:kAttributeCycleCountIsClear];
    
    //cycle count count
    RKObjectMapping* countMapping = [RKObjectMapping mappingForClass:[CycleCountCount class]];
    [countMapping mapKeyPath:kKeyPathCycleCountTarget toAttribute:kAttributeCycleCountTarget];
    [countMapping mapKeyPath:kKeyPathCycleCountQty toAttribute:kAttributeCycleCountQty];
    [countMapping mapKeyPath:kKeyPathCycleCountComment toAttribute:kAttributeCycleCountComment];
    [mapping mapRelationship:kKeyPathCycleCounts withMapping:countMapping];
    

    
    return mapping;

}

@end
