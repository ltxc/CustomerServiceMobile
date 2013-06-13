//
//  UserProfile.h
//  CustomerServiceMobile
//
//  Created by LTXC on 2/4/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserProfile : NSManagedObject

@property (nonatomic, retain) NSString * aaacount;
@property (nonatomic, retain) NSNumber * isAuthorized;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;

@end
