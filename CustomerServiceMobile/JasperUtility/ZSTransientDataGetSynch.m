//
//  TransientDataGetSynch.m
//  SFCMobile
//
//  Created by Jinsong Lu on 8/7/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSTransientDataGetSynch.h"

@implementation ZSTransientDataGetSynch


-(id)init:(NSString *)controllerName appurl:(NSString *)appurl appname:(NSString *)appname baseURL:(NSString *)baseURL rootKeyPath:(NSString *)rootKeyPath notificationName:(NSString *)notificationName mapBlock:(ZSRestDataSynchEntityMappingBlock)mapBlock resultHandlingBlock:(ZSDatSynchResultHandlingBlock)resultHandlingBlock
{
    if(self = [super init:controllerName appurl:appurl appname:appname objectStore:nil baseURL:baseURL rootKeyPath:rootKeyPath notificationName:notificationName mapBlock:mapBlock resultHandlingBlock:resultHandlingBlock])
{
    
    //register the mapping provider
    RKObjectMapping* mapping = [self entityMapping:nil];
    [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:rootKeyPath];
   
}
    return self;

}

-(void)load:(ZSDataSynchResourcePathBlock)resourcePathBlock
{
    [super loadGet:resourcePathBlock];
}

@end
