

#import "CycleCountMasterController.h"
#import "CycleCountMaster.h"
#import "MyRestkit.h"

@implementation CycleCountMasterController
@synthesize cycleCountMasters=_cycleCountMasters;

-(id)init
{
    if(self = [super init:kEntityCycleCountMaster])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kKeyPathCycleCountMaster];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseCycleCountMaster withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [CycleCountMaster fetchRequest];
        }];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    [[SDRestKitEngine sharedEngine]alert:[NSString stringWithFormat:kMessageCycleCountMasterFailed, [error localizedDescription]] title:@"Refresh failed..."];

}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    if(nil!=objects)
    {
        _cycleCountMasters = objects;
        [[SDDataEngine sharedEngine] saveRKCache];
        
    }
}


-(void)load
{
    [self reset];
    NSString* defaultWarehouseID = [SDUserPreference sharedUserPreference].DefaultWarehouseID;
    NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamWarehouseId,defaultWarehouseID, nil];
    NSString *resourcePath = [kUrlBaseCycleCountMaster appendQueryParams:dictionary];
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:resourcePath];
    
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    [loader setCacheTimeoutInterval:0.1];
    [loader sendSynchronously];
}



-(RKManagedObjectMapping *) entityMapping
{
    RKManagedObjectStore* objectStore = [[SDDataEngine sharedEngine] rkManagedObjectStore];
    
    self.objectManager.objectStore = objectStore;
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[CycleCountMaster class] inManagedObjectStore:objectStore];
    
    [mapping mapKeyPath:kKeyPathCycleCountMasterBinCodeID toAttribute:kAttributeCycleCountMasterBinCodeID];
    [mapping mapKeyPath:kKeyPathCycleCountMasterBpartID toAttribute:kAttributeCycleCountMasterBpartID];
    [mapping mapKeyPath:kKeyPathCycleCountMasterCycleType toAttribute:kAttributeCycleCountMasterCycleType];
    [mapping mapKeyPath:kKeyPathCycleCountMasterAssignedDate toAttribute:kAttributeCycleCountMasterAssignedDate];
    [mapping mapKeyPath:kKeyPathCycleCountMasterServerID toAttribute:kAttributeCycleCountMasterServerID];
    [mapping mapKeyPath:kKeyPathCycleCountMasterQty toAttribute:kAttributeCycleCountMasterQty];
        [mapping mapKeyPath:kKeyPathCycleCountMasterIsSerialized toAttribute:kAttributeCycleCountMasterIsSerialized];
    mapping.primaryKeyAttribute = kAttributeCycleCountMasterServerID;
    return mapping;
}
@end
