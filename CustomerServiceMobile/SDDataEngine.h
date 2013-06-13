//
//  SDDataEngine.h
//  CustomerServiceMobile
//


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "AutoCompleteDataHelper.h"
@class RKManagedObjectStore;

@interface SDDataEngine : NSObject
@property (strong,atomic) NSManagedObject* managedObject;
@property (readonly, strong, atomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, atomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, atomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, atomic) RKManagedObjectStore* rkManagedObjectStore;


+(SDDataEngine *)sharedEngine;

+(void)alert:(NSString*)alertMessage title:(NSString*)title template:(NSString*)messageTemplate delegate:(id)object;
+(NSString*)ipadid:(NSString*)transactiontype primaryKey:(NSString*)pk addRandomNumber:(BOOL)isAddRandomNumber;


-(void)clearDatabase;
- (void) truncateTable: (NSString *) entityName;
//use the Core Data persistent store instead of RK Managed one
-(NSString*)getPKString:(NSManagedObject *)managedObject;
-(void)save;
-(void)saveRKCache;
-(void)save:(NSManagedObject*) managedObject;
-(void)deleteAndSave:(NSManagedObject*)managedObject;
-(void)delete:(NSManagedObject*)managedObject;
-(NSArray*)data:(NSString*)entityName predicateTemplate:(NSString*)template predicateValue:(NSString*)value descriptors:(NSArray*) descriptors;
-(NSArray*)data:(NSString*)entityName predicate:(NSPredicate*) predicate descriptors:(NSArray*) descriptors;


-(NSArray*)distinctValues:(NSString*)entityName attributeName:(NSString*)attributeName predicate:(NSPredicate*)predicate;

@end
