//
//  SDDataEngine.m
//  CustomerServiceMobile


#import "ZSSDDataEngine.h"



static NSString* kMessageClearDatabaseUndo =@"Failed to clear the database, restore to the original state...";
static NSString* kTitleClearDatabase = @"Clear Database Failed...";


@implementation ZSSDDataEngine

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize rkManagedObjectStore=_rkManagedObjectStore;

static NSString* _persistenStoreFileName;
static NSString* _persistenStoreName;

+(ZSSDDataEngine *)sharedEngine
{
    static ZSSDDataEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    sharedEngine = [[ZSSDDataEngine alloc] init];
});
    return sharedEngine;
}

+(void)setPersistentStoreFileName:(NSString *)persistentStoreFileName
{
    _persistenStoreFileName = persistentStoreFileName;
}

+(void)setPersistentStoreName:(NSString *)persistentStoreName
{
    _persistenStoreName = persistentStoreName;
}

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

    // lock the current context
    [self.managedObjectContext lock];
    [self.managedObjectContext reset];//to drop pending changes
    NSURL * storeURL = [[self.managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[self.persistentStoreCoordinator persistentStores] lastObject]];
    [self resetDatabase:storeURL];
    //restore some inititial state
    [self.managedObjectContext unlock];
    _managedObjectContext = nil;
  
}

-(void)resetDatabase:(NSURL*)storeURL
{
    NSError * error;


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
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTitleClearDatabase message:kMessageClearDatabaseUndo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        NSLog(@"Sqlight file %@ has been removed",[storeURL absoluteString]);
        //recreate the store like in the  appDelegate method
        if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            //error to recreate the database
            NSLog(@"Failed to recreate the core data store, Unresolved error:  %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
    else
    {
        //error to recreate the database
        NSLog(@"Failed to remove the persistent store, Unresolved error:  %@, %@", error, [error userInfo]);
        abort();
    }

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




#pragma mark - Core Data stack
-(RKManagedObjectStore* )rkManagedObjectStore
{
    if(_rkManagedObjectStore==nil)
    {
        _rkManagedObjectStore = [RKManagedObjectStore objectStoreWithStoreFilename:_persistenStoreFileName];
    }
    
    return _rkManagedObjectStore;
}

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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_persistenStoreName withExtension:@"momd"];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_persistenStoreFileName];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        //persistent store may be crashed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning..." message:@"Failed to load the local database. It may be damaged. Click Yes to create a new local database,which will cause data loss. Click No to quit and start up again. If problem persists, please contact support... " delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert show];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSError *error = nil;
    if (buttonIndex == 0) {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_persistenStoreFileName];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:storeURL.path]) {
            [fileManager removeItemAtPath:storeURL.path error:&error];
        }
        exit(0);
    }
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -- Help Methods
-(void)save
{
    //save core data
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [ZSSDDataEngine sharedEngine].managedObjectContext; //self.managedObjectContext;
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
    NSManagedObjectContext *managedObjectContext = [[ZSSDDataEngine sharedEngine] managedObjectContext];
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

-(NSInteger)dataCount:(NSString*)entityName predicate:(NSPredicate*)predicate
{

    NSManagedObjectContext *managedObjectContext = [[ZSSDDataEngine sharedEngine] managedObjectContext];
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if(nil!=predicate)
    {
        [fetchRequest setPredicate:predicate];
    }

    NSError* error = nil;
    NSInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    if(nil!=error)
    {
        NSString* predicateString = @"";
        if(nil!=predicate)
        {
            predicateString = predicate.predicateFormat;
        }
        NSLog(@"Count %@ entity table failed with predicate %@", entityName, predicateString);
    }
    
    return count;
}


-(NSArray*)distinctValues:(NSString*)entityName attributeName:(NSString*)attributeName predicate:(NSPredicate*)predicate
{
    NSArray* result = nil;
    NSManagedObjectContext *managedObjectContext = [[ZSSDDataEngine sharedEngine] managedObjectContext];
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

@end
