//
//  InventoryTransactionController.m
//  CustomerServiceMobile


#import "InventoryTransactionController.h"
#import "MyRestkit.h"
#import "InventoryHeader.h"
#import "InventoryLineItem.h"
#import "CarrierProxy.h"
#import "CompanyProxy.h"
#import "WarehouseProxy.h"
#import "ReceivingTransactionProxy.h"

@implementation InventoryTransactionController

@synthesize objectManager=_objectManager;
@synthesize controllerName=_controllerName;
@synthesize isMISC=_isMISC;
//ProcessResult* _processResult;
InventoryHeader* _inventoryHeader;
BOOL _isOK;
-(id)init:(BOOL)isMISC
{
    _isMISC = isMISC;
    if(self = [super init:kEntityInventoryHeader notificationName:nil])
    {
        [self.objectManager.router routeClass:[ReceivingTransactionProxy class] toResourcePath:kUrlBaseInventory forMethod:RKRequestMethodPOST];

        RKObjectMapping* inventoryHeaderMapping = [self inventoryTransactionMapping:isMISC];
        //register the mapping provider
       // no need here as it map back itself
        //If you are not mapping an object back to itself, (creating or updating), you don't want to use postObject. As it always map back to itself.
        
        //RKObjectMapping* processResultMapping = [self processResultMapping];
        [self.objectManager.mappingProvider registerMapping:inventoryHeaderMapping withRootKeyPath:@""];
        RKObjectMapping* serializationMapping = [inventoryHeaderMapping inverseMapping];

        [self.objectManager.mappingProvider setSerializationMapping:serializationMapping forClass:[ReceivingTransactionProxy class]];
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
//-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
//{
//    [super objectLoader:objectLoader didLoadObjects:objects];
//    if(nil!=objects)
//    {
//        _processResult = [objects objectAtIndex:0];
//        if(nil!=_processResult)
//        {
//            _inventoryHeader.process_message = _processResult.process_message;
//            _inventoryHeader.process_status = _processResult.process_status;
//            _inventoryHeader.process_date = _processResult.process_date;
//            
//            [[SDDataEngine sharedEngine] save:_inventoryHeader];
//        }
//    }
//}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    [super objectLoader:objectLoader didLoadObject:object];
    if(nil!=object)
    {
        ReceivingTransactionProxy* result = (ReceivingTransactionProxy*)object;
        if(nil!=result)
        {
            NSLog(@"status:%@; date:%@; message:%@",result.process_status,[result.process_date description],result.process_message);
            _inventoryHeader.process_message = result.process_message;
            _inventoryHeader.process_status = result.process_status;
            _inventoryHeader.process_date = result.process_date;
            if([kProcessStatusCOMPLETED isEqualToString:result.process_status])
            {
                _isOK = TRUE;
            }
            [[SDDataEngine sharedEngine] save:_inventoryHeader];
        }
    }

}


-(BOOL)post:(InventoryHeader *)inventoryHeader
{
    _isOK = FALSE;
    _inventoryHeader = inventoryHeader;
    ReceivingTransactionProxy* proxy = [[ReceivingTransactionProxy alloc]initWithInventoryHeader:_inventoryHeader];

    RKObjectLoader *loader = [self.objectManager loaderForObject:proxy
 method:RKRequestMethodPOST];
    loader.serializationMIMEType = RKMIMETypeJSON;
    
    loader.delegate = self;
    loader.method = RKRequestMethodPOST;
    //loader.targetObject=proxy;
    
    [loader setCacheTimeoutInterval:0.1];
    [loader sendSynchronously];
    
    //may send alert if falied
    
    return _isOK;
}


-(RKObjectMapping *) inventoryTransactionMapping:(BOOL)isMISC{
    RKObjectMapping* headerMapping = [RKObjectMapping mappingForClass:[ReceivingTransactionProxy class]];
        //headerMapping.forceCollectionMapping=YES;
    if(isMISC)
    {
    //Miscellaneous Receiving header mapping
     [headerMapping mapAttributes:kKeyPathProcessResultStatus,kKeyPathProcessResultMessage,kKeyPathProcessResultDate,kKeyPathInventoryCarrierRefNo,kKeyPathInventoryCreated_Date,kKeyPathInventoryCreatedBy,kKeyPathInventorySenderRefNo,kKeyPathInventoryWeight,kKeyPathInventoryIPad_ID,kKeyPathInventoryNoOfPackages, nil];

    //carrier
    RKObjectMapping* carrierMapping = [RKObjectMapping mappingForClass:[CarrierProxy class]];
    [carrierMapping mapAttributes:kAttributeInventoryCarrier_ID, nil];
    [headerMapping mapRelationship:kKeyPathInventoryCarrier withMapping:carrierMapping];
    
    //company
    RKObjectMapping* companyMapping = [RKObjectMapping mappingForClass:[CompanyProxy class]];
    [companyMapping mapAttributes:kAttributeInventoryCompany_ID, nil];
    [headerMapping mapRelationship:kKeyPathInventoryCompany withMapping:companyMapping];

    }
    else
    {
        //non miscellaneous header mapping
             [headerMapping mapAttributes:kKeyPathProcessResultStatus,kKeyPathProcessResultMessage,kKeyPathProcessResultDate,kKeyPathInventoryCarrierRefNo,kKeyPathInventoryCreated_Date,kKeyPathInventoryCreatedBy,kKeyPathInventorySenderRefNo,kKeyPathInventoryWeight,kKeyPathInventoryIPad_ID,kKeyPathInventoryNoOfPackages,kKeyPathInventoryOurRefNo, nil];
        //carrier
        RKObjectMapping* carrierMapping = [RKObjectMapping mappingForClass:[CarrierProxy class]];
        [carrierMapping mapAttributes:kAttributeInventoryCarrier_ID, nil];
        [headerMapping mapRelationship:kKeyPathInventoryCarrier withMapping:carrierMapping];
    }
    
    //to_warehouse
    RKObjectMapping* toWarehouseMapping = [RKObjectMapping mappingForClass:[WarehouseProxy class]];
    [toWarehouseMapping mapKeyPath:kAttributeInventoryToWarehouseID toAttribute:kKeyPathInventoryToWarehouseWarehouseID];
    [headerMapping mapRelationship:kKeyPathInventoryToWarehouse withMapping:toWarehouseMapping];
    
    //fr_warehouse
//    RKObjectMapping* frWarehouseMapping = [RKObjectMapping mappingForClass:[WarehouseProxy class]];
//    [frWarehouseMapping mapKeyPath:kAttributeInventoryFrWarehouseID toAttribute:kKeyPathInventoryFrWarehouseWarehouseID];
//    [headerMapping mapRelationship:kKeyPathInventoryFrWarehouse withMapping:frWarehouseMapping];
    
    [headerMapping mapKeyPath:kKeyPathInventoryTransactionType toAttribute:kAttributeInventoryType];
    //line item mapping
    RKObjectMapping* lineItemMapping = [RKObjectMapping mappingForClass:[InventoryLineItem class]];
    [lineItemMapping mapAttributes:kKeyPathInventoryInventoryLineItemsBin_Code_ID,kKeyPathInventoryInventoryLineItemsBPart_ID, kKeyPathInventoryInventoryLineItemsLineQty,kKeyPathInventoryInventoryLineItemsLineQty,
     kKeyPathInvenoryInventoryLineItemsLineNumber,
     kKeyPathInventoryInventoryLineItemsInvTypeID,
     kKeyPathInventoryInventoryLineItemsSerialNo,
     nil];
    if (isMISC) {
        //miscellaneous
        [lineItemMapping mapKeyPath:kKeyPathInventoryInventoryLineItemsLineReasonCode toAttribute:kKeyPathInventoryInventoryLineItemsLineReasonCode];
        
    }
    else{
        [lineItemMapping mapKeyPath:kKeyPathInventoryInventoryLineItemsCause toAttribute:kKeyPathInventoryInventoryLineItemsCause];
        
    }

    [headerMapping mapRelationship:kKeyPathInventoryInventoryLineItems withMapping:lineItemMapping];

    return headerMapping;
}
@end
