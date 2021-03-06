//
//  CoreDataPostSynch.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/3/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataSynch.h"
/**
 * CoreDataSynch is used to synch by calling a post http call.
 * Can be used to send a transaction input in core data format and get back
 *     the post result, an processresult object. All the inventory transaction and shipping transaction  belongs to this pattern. 
 * The input object can not be core data. Use a proxy class to wrap around it. If core data object is used as input parameter, the return object should be the same core data class.
 */
@interface CoreDataPostSynch : CoreDataSynch
@property (strong,nonatomic) DatSynchResultHandlingBlock resultHandlingBlock;
@property (strong, nonatomic) Class postedObjectClass;
@property (nonatomic)BOOL isOK;

-(id)init:(NSString*)controllerName objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName postedObjectClass:(Class)postedObjectClass mapBlock:(DataSynchEntityMappingBlock)mapBlock resultHandlingBlock:(DatSynchResultHandlingBlock)resultHandlingBlock;
-(BOOL)load:(id)postedObject;
@end
