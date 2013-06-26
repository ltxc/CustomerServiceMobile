//
//  ActionCode.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ActionCode : NSManagedObject

@property (nonatomic, retain) NSString * code_id;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * activity_id;

@end
