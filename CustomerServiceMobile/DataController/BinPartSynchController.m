//
//  BinPartSynchController.m
//  CustomerServiceMobile


#import "BinPartSynchController.h"
#import "BinPart.h"
#import "MyRestkit.h"
@implementation BinPartSynchController
@synthesize binparts=_binparts;
-(id)init
{
    if(self = [super init:kEntityBinPart notificationName:nil])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kKeyPathBinPart];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseBinPart withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [BinPart fetchRequest];
        }];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    //notify synch finished
    [[SDRestKitEngine sharedEngine] notify:kNotificationNameBinPart status:self.status message:self.message object:nil];
}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    if(nil!=objects)
    {
        _binparts = objects;
        self.message = [NSString stringWithFormat:kMessageSynchRecordTemplate, [objects count]];
        //notify synch finished
        [[SDRestKitEngine sharedEngine] notify:kNotificationNameBinPart status:self.status message:self.message object:objects];
        [[SDDataEngine sharedEngine] saveRKCache];
        
    }
}

-(void)objectLoader:(RKObjectLoader *)loader willMapData:(inout __autoreleasing id *)mappableData
{
//    Class class = loader.objectMapping.objectClass;
//    if(class==[BinPart class])
//    {
        NSArray* binPartArray = [*mappableData valueForKeyPath:kKeyPathBinPart];
    NSMutableArray* newBinPartArray = [[NSMutableArray alloc] initWithCapacity:[binPartArray count]];
    for(NSDictionary* binPart in binPartArray)
    {
        NSString* binCodeID = [binPart objectForKey:kKeyPathBinPartBinCodeID];
        NSString* bpartID = [binPart objectForKey:kKeyPathBinPartBpartID];
        NSString* keyID = [NSString stringWithFormat:@"%@:%@",binCodeID,bpartID];
        NSMutableDictionary* newBinPart = [NSMutableDictionary dictionaryWithDictionary:binPart];
        [newBinPart setValue:keyID forKey:kKeyPathKeyID];
        [newBinPartArray addObject:newBinPart];
    }
    [*mappableData removeObjectForKey:kKeyPathBinPart];
    [*mappableData setObject:newBinPartArray forKey:kKeyPathBinPart];
//    }
}

-(void)load
{
    [self reset];
    NSString* defaultWarehouseID = [SDUserPreference sharedUserPreference].DefaultWarehouseID;
    NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamWarehouseId,defaultWarehouseID,kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
    NSString *resourcePath = [kUrlBaseBinPart appendQueryParams:dictionary];
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
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[BinPart class] inManagedObjectStore:objectStore];

    [mapping mapKeyPath:kKeyPathBinPartBinCodeID toAttribute:kAttributeBinPartBinCodeID];
    [mapping mapKeyPath:kKeyPathBinPartBpartID toAttribute:kAttributeBinPartBpartID];
    [mapping mapKeyPath:kKeyPathBinPartInvTypeID toAttribute:kAttributeBinPartInvTypeID];
    [mapping mapKeyPath:kKeyPathBinPartLastRecDate toAttribute:kAttributeBinPartLastRecDate];
    [mapping mapKeyPath:kKeyPathServerID toAttribute:kAttributeServerID];
    [mapping mapKeyPath:kKeyPathKeyID toAttribute:kKeyPathKeyID];
    [mapping mapKeyPath:kKeyPathBinPartQty toAttribute:kAttributeBinPartQty];
    
    mapping.primaryKeyAttribute = kKeyPathKeyID;
    return mapping;
}@end
