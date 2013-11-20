//
//  UserProfileController.h
//  CustomerServiceMobile
//
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DataSynchBase.h"
#import <RestKit/RestKit.h>
#import "UserProfile.h"
@interface UserProfileController : DataSynchBase<RKObjectLoaderDelegate>
@property (strong, atomic) UserProfile* userProfile;

-(id)init;
//-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error;
//-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response;
//-(RKManagedObjectMapping *) entityMapping;
-(UserProfile *)fetchUserProfile:(NSString*) username;
-(UserProfile *)login:(UserProfile*) storedUserProfile;
@end
