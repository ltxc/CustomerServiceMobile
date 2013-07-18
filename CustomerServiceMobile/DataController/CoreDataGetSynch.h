//
//  CoreDataSynch.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/26/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "CoreDataSynch.h"

/**
 * CoreDataSynch is used to synch by calling a simple get http call.
 * 
 */
@interface CoreDataGetSynch : CoreDataSynch

-(id)init:(NSString*)controllerName objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName mapBlock:(DataSynchEntityMappingBlock)mapBlock fetchBlock:(RKObjectMappingProviderFetchRequestBlock)fetchRequestBlock;
-(void)load:(DataSynchResourcePathBlock)resourcePathBlock;

@end
