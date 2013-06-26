//
//  Activity.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity : NSManagedObject

@property (nonatomic, retain) NSString * activity_id;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * bpart_gcl_id;

@end
