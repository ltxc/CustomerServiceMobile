
#import "ApplicationDataSynchController.h"
#import "ApplicationData.h"
#import "MyRestkit.h"

@implementation ApplicationDataSynchController
@synthesize appicationdata=_appicationdata;

-(id)init
{
    if(self = [super init:kEntityApplicationData  notificationName:nil])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kKeyPathApplicationData];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseApplicationData withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [ApplicationData fetchRequest];
        }];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    //notify synch finished
    [[SDRestKitEngine sharedEngine] notify:kNotificationNameApplicationData status:self.status message:self.message object:nil];
}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    if(nil!=objects)
    {
        _appicationdata = objects;
        self.message = [NSString stringWithFormat:kMessageSynchRecordTemplate, [objects count]];
        //notify synch finished
        [[SDRestKitEngine sharedEngine] notify:kNotificationNameApplicationData status:self.status message:self.message object:objects];
        [[SDDataEngine sharedEngine] saveRKCache];
        
    }
}

-(void)load
{
    [self reset];
    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:kUrlBaseApplicationData];
    
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    [loader setCacheTimeoutInterval:0.1];
    [loader send];
}



-(RKManagedObjectMapping *) entityMapping
{
    RKManagedObjectStore* objectStore = [[SDDataEngine sharedEngine] rkManagedObjectStore];
    
    self.objectManager.objectStore = objectStore;
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[ApplicationData class] inManagedObjectStore:objectStore];
    [mapping mapAttributes:kKeyPathKey,kKeyPathApplicationDataName,kKeyPathApplicationDataValue,kKeyPathApplicationDataLandscape,kKeyPathApplicationDataCategory,kKeyPathApplicationDataSubCategory,kKeyPathApplicationDataAttachment,kKeyPathApplicationDataAttribute1,kKeyPathApplicationDataAttribute10,kKeyPathApplicationDataAttribute2,kKeyPathApplicationDataAttribute3,kKeyPathApplicationDataAttribute4,kKeyPathApplicationDataAttribute5,kKeyPathApplicationDataAttribute6,kKeyPathApplicationDataAttribute7,kKeyPathApplicationDataAttribute8,kKeyPathApplicationDataAttribute9, nil];
    [mapping mapKeyPath:kKeyPathServerID toAttribute:kAttributeServerID];
    [mapping mapKeyPath:kKeyPathApplicationDataDescription toAttribute:kAttributeApplicationDataescription];
    
    mapping.primaryKeyAttribute = kKeyPathKey;
    return mapping;
}


@end
