//
//  SDDataEngine.m
//  CustomerServiceMobile


#import "SDDataEngine.h"
#import "SharedConstants.h"
#import "SDRestKitEngine.h"
#import "SDUserPreference.h"

@implementation SDDataEngine

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize rkManagedObjectStore=_rkManagedObjectStore;

+(SDDataEngine *)sharedEngine
{
    static SDDataEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    sharedEngine = [[SDDataEngine alloc] init];
});
    return sharedEngine;
}



+(void)alert:(NSString*)alertMessage title:(NSString*)title template:(NSString*)messageTemplate delegate:(id)object
{
    if(nil==title)
        title = @"Validation Failure...";
    NSString* m;
    if(nil!=messageTemplate)
    {
        m = [NSString stringWithFormat:messageTemplate,alertMessage];
    }
    else
    {
        m = alertMessage;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:m delegate:object cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


+(NSString*)ipadid:(NSString*)transactiontype primaryKey:(NSString*)pk addRandomNumber:(BOOL)isAddRandomNumber
{
    if(transactiontype==nil)
    {
        transactiontype = @"Unknown";
    }
    
    if(pk==nil)
    {
        pk = @"";
    }
    NSString* deviceName = [[UIDevice currentDevice] name];
    NSString* separator=@"";
    NSString* snum = @"";
    if(isAddRandomNumber)
    {
        int randomIndex = arc4random()%1000;
        snum = [NSString stringWithFormat:@"%d",randomIndex];
        separator = @".";
    }
    
    NSString* ipadid = [NSString stringWithFormat:@"%@%@%@%@%@",deviceName,transactiontype,pk,separator,snum];
    
    return ipadid;
}

//+(int)getPK:(NSManagedObject *)managedObject
//{
//    return [[[[[[managedObject objectID] URIRepresentation] absoluteString] lastPathComponent] substringFromIndex:1] intValue];
//}


//This method must be called after save method called on this managed object. Otherwise, the temporary id will be returned.
-(NSString*)getPKString:(NSManagedObject *)managedObject
{
    //may delay a really short time to allow save finish if precede comand is save
//    if ([[managedObject objectID] isTemporaryID]) {
//        //delay some time
//        //[NSThread sleepForTimeInterval:0.5];
//        NSLog(@"%@", @"Delay 1 second before getting the Primary Key ID");
//    }    
    
    NSString* pkString =  [[[[[managedObject objectID] URIRepresentation] absoluteString] lastPathComponent] substringFromIndex:1];
//    NSLog(@"Primary Key: %@",pkString);
    return pkString;
}

-(void)clearDatabase
{
    NSError * error;
    // retrieve the store URL
    //as long as self.persistentStoreCoordinator called once, _persistentStoreCoordinator can be used.
    NSURL * storeURL = [[self.managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[self.persistentStoreCoordinator persistentStores] lastObject]];
    // lock the current context
    [self.managedObjectContext lock];
    [self.managedObjectContext reset];//to drop pending changes
    //delete the store from the current managedObjectContext
    if ([[self.managedObjectContext persistentStoreCoordinator] removePersistentStore:[[_persistentStoreCoordinator persistentStores] lastObject] error:&error])
    {
        NSLog(@"%@",@"Persistent Store has been removed...");
        // remove the file containing the data
        if(![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error])
        {
            //add the persistent store back and alert
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
                NSLog(@"Failed to add persistent store back. Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            else
            {
                //alert user the clearing database action failed. Undo the remove action.
                [[SDRestKitEngine sharedEngine] alert:kMessageClearDatabaseUndo title:@"Clear Database Failed..."];
            }
        }
        NSLog(@"Sqlight file %@ has been removed",[storeURL absoluteString]);
        //recreate the store like in the  appDelegate method
        if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            //error to recreate the database
            NSLog(@"Failed to recreate the core data store after deleting, Unresolved error:  %@, %@", error, [error userInfo]);
            abort();            
        }
            
    }
    else
    {
        //error to recreate the database
        NSLog(@"Failed to remove the persistent store, Unresolved error:  %@, %@", error, [error userInfo]);
        abort();
    }
    [self.managedObjectContext unlock];
    //restore some inititial state
    _managedObjectContext = nil;
    [SDUserPreference sharedUserPreference].IsInited = NO;
    
}


- (void) truncateTable: (NSString *) entityName  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
    
    for (NSManagedObject *managedObject in items) {
        [_managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityName);
    }
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityName,error);
    }
}


-(RKManagedObjectStore* )rkManagedObjectStore
{
    if(_rkManagedObjectStore==nil)
    {
        _rkManagedObjectStore = [RKManagedObjectStore objectStoreWithStoreFilename:kSharedStoreFileName];
    }
    
    return _rkManagedObjectStore;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CustomerServiceMobile" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CustomerServiceMobile.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

-(void)save
{
    //save core data
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [SDDataEngine sharedEngine].managedObjectContext; //self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
    }

}

-(void)saveRKCache
{
    NSError* error = nil;
    [[self rkManagedObjectStore].managedObjectContextForCurrentThread save:&error];
    if(error)
    {
        NSLog(@"RK Cache Save failed: %@", error);
    }
}

-(void)save:(NSManagedObject*) managedObject
{
    //save core data
    NSError *error = nil;
    if(nil!=managedObject)
    {
        NSManagedObjectContext *managedObjectContext = [managedObject managedObjectContext];
        if (nil!=managedObjectContext) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                 // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                //abort();
            }
        }

    }
    
        
}
-(void)delete:(NSManagedObject*)managedObject
{
    if(nil!=managedObject)
    {
        NSManagedObjectContext *managedObjectContext = [managedObject managedObjectContext];
        if(nil!=managedObjectContext)
        {
            [[managedObject managedObjectContext] deleteObject:managedObject];
            
        }
    }

}


-(void)deleteAndSave:(NSManagedObject*) managedObject
{
    if(nil!=managedObject)
    {
        [self delete:managedObject];
        [self save:managedObject];
    }
}


-(NSArray*)data:(NSString*)entityName predicateTemplate:(NSString*)template predicateValue:(NSString*)value descriptors:(NSArray*) descriptors
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:template,value];    
      
   
    return [self data:entityName predicate:predicate descriptors:descriptors];
}


-(NSArray*)data:(NSString*)entityName predicate:(NSPredicate*) predicate descriptors:(NSArray*) descriptors
{
    NSArray *result = nil;
    NSManagedObjectContext *managedObjectContext = [[SDDataEngine sharedEngine] managedObjectContext];
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if(nil!=predicate)
    {
        [fetchRequest setPredicate:predicate];
    }
    if(nil!=descriptors)
    {
        [fetchRequest setSortDescriptors:descriptors];
    }
    
    
    NSError* error = nil;
    result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(nil!=error)
    {
        NSString* predicateString = @"";
        if(nil!=predicate)
        {
            predicateString = predicate.predicateFormat;
        }
        NSLog(@"Fetch %@ entity table failed with predicate %@", entityName, predicateString);
    }
    
    
    return result;

}


-(NSArray*)distinctValues:(NSString*)entityName attributeName:(NSString*)attributeName predicate:(NSPredicate*)predicate
{
    NSArray* result = nil;
    NSManagedObjectContext *managedObjectContext = [[SDDataEngine sharedEngine] managedObjectContext];
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:attributeName]];
    fetchRequest.returnsDistinctResults = YES;
    if(predicate!=nil)
        [fetchRequest setPredicate:predicate];
    NSSortDescriptor* sortDescription = [NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescription]];
    NSError* error = nil;
    result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(nil!=error)
    {
        NSLog(@"Fetch distinct value of %@ on %@ entity table.", attributeName, entityName);
    }

    return result;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
