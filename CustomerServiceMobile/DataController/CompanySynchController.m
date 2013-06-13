//
//  CompanySynchController.m
//  CustomerServiceMobile
//
//  Created by LTXC on 11/29/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "CompanySynchController.h"
#import "Company.h"
#import "MyRestkit.h"

@implementation CompanySynchController
@synthesize companys=_companys;

-(id)init
{
    if(self = [super init:kEntityCompany])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:kKeyPathCompany];
        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseCompany withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            return [Company fetchRequest];
        }];
    }
    return self;
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    //notify synch finished
    [[SDRestKitEngine sharedEngine] notify:kNotificationNameCompany status:self.status message:self.message object:nil];
}



-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    if(nil!=objects)
    {
        _companys = objects;
        self.message = [NSString stringWithFormat:kMessageSynchRecordTemplate, [objects count]];
        //notify synch finished
        [[SDRestKitEngine sharedEngine] notify:kNotificationNameCompany status:self.status message:self.message object:objects];
        [[SDDataEngine sharedEngine] saveRKCache];
        
    }
}

-(void)load
{
    [self reset];
    NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
    NSString *resourcePath = [kUrlBaseCompany appendQueryParams:dictionary];
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
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[Company class] inManagedObjectStore:objectStore];
    [mapping mapKeyPath:kKeyPathCompanyCompanyID toAttribute:kKeyPathCompanyCompanyID];
    //[mapping mapKeyPath:kKeyPathLastChangeDate toAttribute:kKeyPathLastChangeDate];
    mapping.primaryKeyAttribute = kKeyPathCompanyCompanyID;
    return mapping;
}
@end
