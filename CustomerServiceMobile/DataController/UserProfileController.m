//
//  UserProfileController.m
//  CustomerServiceMobile
//


#import "UserProfileController.h"
#import "MyRestkit.h"


@implementation UserProfileController
@synthesize userProfile= _userProfile;



-(id)init
{
    if(self = [super init:kEntityUserProfile notificationName:nil])
    {
        //register the mapping provider
        RKManagedObjectMapping* mapping = [self entityMapping];
        [self.objectManager.mappingProvider registerMapping:mapping withRootKeyPath:@""];
//        [self.objectManager.mappingProvider setObjectMapping:mapping forResourcePathPattern:kUrlBaseUserAccount withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
//            return [UserProfile fetchRequest];
//        }];
//        [self.objectManager.mappingProvider mappingForKeyPath:@""];
    }
    return self;
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError: %@",[error localizedDescription]);
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [super objectLoader:objectLoader didFailWithError:error];
    //[[SDRestKitEngine sharedEngine] alert:@"Server Connection Failed. Please make sure that it is connected inside company network..." title:@"Connection Failure"];
}

-(void)request:(RKRequest *)request didReceiveResponse:(RKResponse *)response
{
    [super request:request didReceiveResponse:response];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    [super request:request didLoadResponse:response];

}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
 
    if(object!=nil&&[object isKindOfClass:[UserProfile class]])
    {
        UserProfile* loginUserProfile = (UserProfile*) object;
//        if(loginUserProfile.isAuthorized)
//        {
            //find one
            self.userProfile = loginUserProfile;
//        }
    }
}

-(UserProfile *)login:(UserProfile*) storedUserProfile
{
    
       self.userProfile = nil;
    
    //synchronize call only

    RKObjectLoader *loader = [self.objectManager loaderWithResourcePath:kUrlBaseUserAccount];
    loader.delegate = self;
    loader.method = RKRequestMethodGET;
    //[loader setCacheTimeoutInterval:0];    
    [loader sendSynchronously];
    
    
    if(self.userProfile!=nil)
    {
        if(self.userProfile.isAuthorized==0)
        {
           [[SDDataEngine sharedEngine] deleteAndSave:self.userProfile];
            return self.userProfile;
        }

        //authenticated with server
        if(storedUserProfile==nil)
        {
           storedUserProfile = [NSEntityDescription insertNewObjectForEntityForName:kEntityUserProfile inManagedObjectContext:[[SDDataEngine sharedEngine] managedObjectContext]];

        }
       
        storedUserProfile.username = self.userProfile.username;
        storedUserProfile.password = [SDRestKitEngine sharedEngine].password;
        storedUserProfile.lastUpdated = [NSDate date];
        storedUserProfile.aaacount = self.userProfile.aaacount;
        storedUserProfile.isAuthorized = self.userProfile.isAuthorized;
       
        [[SDDataEngine sharedEngine] deleteAndSave:self.userProfile];
        self.userProfile = storedUserProfile;
       
    }
    else
    {
        //verify against the stored userprofile
        if(storedUserProfile!=nil&&[storedUserProfile.password isEqualToString:[SDRestKitEngine sharedEngine].password])
        {
            self.userProfile = storedUserProfile;
            storedUserProfile.lastUpdated = [NSDate date];
        }
    }
    if(self.userProfile!=nil)
    {
       
       [[SDDataEngine sharedEngine] save];
    }
    return self.userProfile;
}

-(UserProfile *)fetchUserProfile:(NSString*) username
{
    UserProfile* up = nil;
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[SDDataEngine sharedEngine] managedObjectContext];
  
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityUserProfile];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@",username];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;

    results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (nil!=results&&[results count]>0)
    {
        up = (UserProfile*)[results objectAtIndex:0];
        NSLog(@"Total %d found. First One:%@",[results count],up);
    }   
   
    return up;
}

-(RKManagedObjectMapping *) entityMapping
{
    RKManagedObjectStore* objectStore = [[SDDataEngine sharedEngine] rkManagedObjectStore];
     
    self.objectManager.objectStore = objectStore;
    RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[UserProfile class] inManagedObjectStore:objectStore];
    [mapping mapKeyPath:kKeyPathUserProfileUserName toAttribute:kAttributeUserProfileUserName];
    [mapping mapKeyPath:kKeyPathUserProfileAAAcount toAttribute:kAttributeUserProfileAAAcount];
    [mapping mapKeyPath:kKeyPathUserProfileIsAuthorized toAttribute:kAttributeUserProfileIsAuthorized];
    mapping.primaryKeyAttribute = @"userid";
    return mapping;
}

@end
