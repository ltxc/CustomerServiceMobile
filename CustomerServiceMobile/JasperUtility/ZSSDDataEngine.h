//
//  SDDataEngine.h
//  CustomerServiceMobile
//


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "ZSAutoCompleteDataHelper.h"




@class RKManagedObjectStore;
@interface ZSSDDataEngine : NSObject
@property (strong,atomic) NSManagedObject* managedObject;
@property (strong, atomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, atomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, atomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, atomic) RKManagedObjectStore* rkManagedObjectStore;


+(ZSSDDataEngine *)sharedEngine;
+(void)setPersistentStoreName:(NSString*)persistentStoreName;
+(void)setPersistentStoreFileName:(NSString*)persistentStoreFileName;

//clear database method lock database access and drops pending changes
-(void)clearDatabase;
-(void)resetDatabase:(NSURL*)storeURL;

//use the Core Data persistent store instead of RK Managed one
-(NSString*)getPKString:(NSManagedObject *)managedObject;
-(void)save;
-(void)saveRKCache;
-(void)save:(NSManagedObject*) managedObject;
-(void)deleteAndSave:(NSManagedObject*)managedObject;
-(void)delete:(NSManagedObject*)managedObject;
- (void) truncateTable: (NSString *) entityName;
-(NSArray*)data:(NSString*)entityName predicateTemplate:(NSString*)template predicateValue:(NSString*)value descriptors:(NSArray*) descriptors;
-(NSArray*)data:(NSString*)entityName predicate:(NSPredicate*) predicate descriptors:(NSArray*) descriptors;
-(NSInteger)dataCount:(NSString*)entityName predicate:(NSPredicate*)predicate;
-(NSArray*)distinctValues:(NSString*)entityName attributeName:(NSString*)attributeName predicate:(NSPredicate*)predicate;

@end
