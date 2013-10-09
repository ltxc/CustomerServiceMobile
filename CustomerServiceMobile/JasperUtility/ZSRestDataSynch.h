//
//  CoreDataSynch.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/16/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSRestDataSynchBase.h"

@interface ZSRestDataSynch : ZSRestDataSynchBase<RKObjectLoaderDelegate>
@property (weak, nonatomic) id result;
//when 
@property (nonatomic)BOOL isASynch;
@property (strong,nonatomic) NSString* entityName;
@property (strong, nonatomic) NSString* rootKeyPath;
@property (strong, nonatomic) NSString* baseURL;
@property (strong,nonatomic) RKManagedObjectStore* objectStore;
@property (strong,nonatomic) ZSDatSynchResultHandlingBlock resultHandlingBlock;
@property (strong,nonatomic) ZSRestDataSynchEntityMappingBlock mapBlock;
@property (strong,nonatomic) ZSRestDataSynchEntityMappingBlock targetMapBlock;
@property (strong,nonatomic) ZSDataSynchNotificationMessageBlock notificationMessageBlock;

//for the post method
@property (strong,nonatomic) RKObjectMapping* sourceMapping;
@property (strong,nonatomic) RKObjectMapping* targetMapping;

//baseURL is the relative path to the base url set at the RKObjectManager level.
-(id)init:(NSString*)controllerName appurl:(NSString*)appurl appname:(NSString*)appname objectStore:(RKManagedObjectStore*) objectStore baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName mapBlock:(ZSRestDataSynchEntityMappingBlock)mapBlock resultHandlingBlock:(ZSDatSynchResultHandlingBlock)resultHandlingBlock;
//json=>object-c
-(RKObjectMapping *) entityMapping:(RKManagedObjectStore*)objectStore;
-(void)loadGet:(ZSDataSynchResourcePathBlock)resourcePathBlock;
-(void)loadPost:(id)postedObject;
@end
