//
//  CoreDataSynch.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/26/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSRestDataSynch.h"

/**
 * CoreDataSynch is used to synch by calling a simple get http call.
 * 
 */
@interface ZSCoreDataGetSynch : ZSRestDataSynch

-(id)init:(NSString*)controllerName appurl:(NSString*)appurl appname:(NSString*)appname objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName mapBlock:(ZSRestDataSynchEntityMappingBlock)mapBlock fetchBlock:(RKObjectMappingProviderFetchRequestBlock)fetchRequestBlock;
-(void)load:(ZSDataSynchResourcePathBlock)resourcePathBlock;

@end
