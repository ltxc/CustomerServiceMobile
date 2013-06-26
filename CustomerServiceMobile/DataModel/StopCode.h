//
//  StopCode.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StopCode : NSManagedObject

@property (nonatomic, retain) NSString * stop_code_id;
@property (nonatomic, retain) NSString * descr;

@end
