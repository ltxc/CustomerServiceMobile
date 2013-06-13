

#import "ShippingTransactionController.h"
#import "ShippingHeader.h"
#import "MyRestkit.h"
#import "ShippingTransactionProxy.h"
#import "ShippingLineItem.h"

@implementation ShippingTransactionController
@synthesize objectManager=_objectManager;
@synthesize controllerName=_controllerName;
@synthesize isPart = _isPart;

ShippingHeader* _shippingHeader;
BOOL _isOK;
-(id)init
{
    if(self = [super init:@"CycleCount"])
    {
        [self.objectManager.router routeClass:[ShippingTransactionProxy class] toResourcePath:kUrlBaseShippingTransaction forMethod:RKRequestMethodPOST];
        
        RKObjectMapping* mapping = [self shippingMapping];
        
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:@""];
        RKObjectMapping* serializationMapping = [mapping inverseMapping];
        
        [self.objectManager.mappingProvider setSerializationMapping:serializationMapping forClass:[ShippingTransactionProxy class]];
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
        ShippingHeader* result = (ShippingHeader*)object;
        if(nil!=result)
        {
            NSLog(@"status:%@; date:%@; message:%@",result.process_status,[result.process_date description],result.process_message);
            _shippingHeader.process_message = result.process_message;
            _shippingHeader.process_status = result.process_status;
            _shippingHeader.process_date = result.process_date;
            if([kProcessStatusCOMPLETED isEqualToString:result.process_status])
            {
                _isOK = TRUE;
            }
            [[SDDataEngine sharedEngine] save:_shippingHeader];
        }
    }
        
}


-(BOOL)post:(ShippingHeader*)shippingHeader{
    
    _isOK = FALSE;
    _shippingHeader = shippingHeader;
    ShippingTransactionProxy* proxy = [[ShippingTransactionProxy alloc] initWithShippingHeader:shippingHeader];

    
    RKObjectLoader *loader = [self.objectManager loaderForObject:proxy
                                                          method:RKRequestMethodPOST];
    loader.serializationMIMEType = RKMIMETypeJSON;
    
    loader.delegate = self;
    loader.method = RKRequestMethodPOST;
    
    
    [loader setCacheTimeoutInterval:0.1];
    [loader sendSynchronously];
    
    return _isOK;
    
}



-(RKObjectMapping *) shippingMapping
{
    
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[ShippingTransactionProxy class]];
    [mapping mapAttributes:kKeyPathProcessResultStatus,kKeyPathProcessResultMessage,kKeyPathProcessResultDate,kKeyPathProcessCreatedBy,kKeyPathShippingShippedBy,kKeyPathProcessCreatedDate,kKeyPathShippingCarrierID,kKeyPathShippingCarrierRefNo,kKeyPathShippingDocTypeID,kKeyPathShippingFrWarehouseID,kKeyPathShippingNoOfPackages,kKeyPathShippingWeight,kKeyPathShippingShippingInstructions,kKeyPathShippingToCompany,kKeyPathShippingToWarehouseID,kKeyPathShippingTransactionType,kKeyPathShippingIPADID,kKeyPathPrinter,kKeyPathIsPrinting,kKeyPathShippingIsVendor,nil];
    

    
    //line item
    RKObjectMapping* lineMapping = [RKObjectMapping mappingForClass:[ShippingLineItem class]];
    [lineMapping mapAttributes:kKeyPathShippingBPartID,kKeyPathShippingDocTypeID,kKeyPathShippingDemandID,kKeyPathShippingItemID,kKeyPathShippingSerialNo,kKeyPathShippingOrigDocID,kKeyPathShippingShippedQty,nil];
    
    [lineMapping mapKeyPath:kKeyPathShippingServerID toAttribute:kAttributeShippingServerID];
    
    [mapping mapRelationship:kAttributeShippingLineItems withMapping:lineMapping];
    return mapping;
    
}
@end
