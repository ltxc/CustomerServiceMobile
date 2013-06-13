//
//  UserProfileController.h
//  CustomerServiceMobile
//


#import <Foundation/Foundation.h>
#import "DataSynchController.h"
#import <RestKit/RestKit.h>
#import "UserProfile.h"
@interface UserProfileController : DataSynchController<RKObjectLoaderDelegate>
@property (strong, atomic) UserProfile* userProfile;
-(id)init;
//-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error;
//-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response;
//-(RKManagedObjectMapping *) entityMapping;
-(UserProfile *)fetchUserProfile:(NSString*) username;
-(UserProfile *)login:(UserProfile*) storedUserProfile;
@end
