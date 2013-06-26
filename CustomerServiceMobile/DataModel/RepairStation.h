//
//  RepairStation.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RepairStation : NSManagedObject

@property (nonatomic, retain) NSString * station_id;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * warehouse_id;

@end
