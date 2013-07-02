

#import "ShippingListSynchController.h"
#import "MyRestkit.h"
#import "ShippingList.h"

@implementation ShippingListSynchController
@synthesize shippingLists=_shippingLists;
NSInteger _total;
-(id)init
{
    if(self = [super init:kEntityShippingList notificationName:nil])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kKeyPathShippingList];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseShippingList withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [ShippingList fetchRequest];
        }];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    
}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    _total = 0;
    if(nil!=objects)
    {
        _total = [objects count];
        _shippingLists = objects;
        [[SDDataEngine sharedEngine] saveRKCache];
        
    }
}


-(NSInteger)load
{
    _total = -1;
    [self reset];
    NSString* defaultWarehouseID = [SDUserPreference sharedUserPreference].DefaultWarehouseID;
    NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamWarehouseId,defaultWarehouseID, nil];
    NSString *resourcePath = [kUrlBaseShippingList appendQueryParams:dictionary];
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:resourcePath];
    
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    [loader setCacheTimeoutInterval:0.1];
    [loader sendSynchronously];
    return _total;
}



-(RKManagedObjectMapping *) entityMapping
{
    RKManagedObjectStore* objectStore = [[SDDataEngine sharedEngine] rkManagedObjectStore];
    
    self.objectManager.objectStore = objectStore;
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[ShippingList class] inManagedObjectStore:objectStore];
    
    //add all the mapping here
    [mapping mapAttributes:kKeyPathShippingBPartID,kKeyPathShippingDemandID,kKeyPathShippingDocTypeID,kKeyPathShippingFRBinCodeID,kKeyPathShippingItemID, kKeyPathShippingLDMNDStatID,kKeyPathShippingOrigDocID,kKeyPathShippingPriority,kKeyPathShippingQty,kKeyPathShippingSerialNo,kKeyPathShippingToCompany,kKeyPathShippingToWarehouseID,kKeyPathShippingIPADID,kKeyPathShippingFRInvTypeID,kKeyPathShippingPIDOCID,kKeyPathShippingIsVendor ,nil];
    [mapping mapKeyPath:kKeyPathShippingListServerID toAttribute:kAttributeShippingListServerID];
    [mapping mapKeyPath:kKeyPathShippingListDueDate toAttribute:kAttributeShippingListDueDate];
    
    mapping.primaryKeyAttribute = kAttributeShippingListServerID;
    return mapping;
}



@end
