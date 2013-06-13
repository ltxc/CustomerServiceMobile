

#import "ShipmentInstructionsSynchController.h"
#import "MyRestkit.h"
#import "ShipmentInstructions.h"

@implementation ShipmentInstructionsSynchController
@synthesize objects=_objects;


-(id)init
{
    if(self = [super init:kEntityShipmentInstructions])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kKeyPathShipmentInstructions];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseShipmentInstructions withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [ShipmentInstructions fetchRequest];
        }];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    //notify synch finished
    [[SDRestKitEngine sharedEngine] notify:kNotificationShipmentInstructions status:self.status message:self.message object:nil];
}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    if(nil!=objects)
    {
        _objects = objects;
        self.message = [NSString stringWithFormat:kMessageSynchRecordTemplate, [objects count]];
        //notify synch finished
        [[SDRestKitEngine sharedEngine] notify:kNotificationShipmentInstructions status:self.status message:self.message object:objects];
        [[SDDataEngine sharedEngine] saveRKCache];
        
    }
}

-(void)load
{
    [self reset];
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:kUrlBaseShipmentInstructions];
    
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    [loader setCacheTimeoutInterval:0.1];
    [loader send];
}



-(RKManagedObjectMapping *) entityMapping
{
    RKManagedObjectStore* objectStore = [[SDDataEngine sharedEngine] rkManagedObjectStore];
    
    self.objectManager.objectStore = objectStore;
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[ShipmentInstructions class] inManagedObjectStore:objectStore];
    [mapping mapAttributes:kKeyPathShipmentInstructionsDescription,kKeyPathShipmentInstructionsLastUpdated,kKeyPathShipmentInstructionsTableKey,kKeyPathShipmentInstructionsTableName, nil];
    [mapping mapKeyPath:kKeyPathServerID toAttribute:kAttributeServerID];
    
    mapping.primaryKeyAttribute = kAttributeServerID;
    return mapping;
}


@end
