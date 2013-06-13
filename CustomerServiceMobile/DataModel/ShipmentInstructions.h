//
//  ShipmentInstructions.h
//  CustomerServiceMobile
//
//  Created by LTXC on 3/19/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShipmentInstructions : NSManagedObject

@property (nonatomic, retain) NSString * ap_description;
@property (nonatomic, retain) NSString * ap_table_key;
@property (nonatomic, retain) NSString * ap_table_name;
@property (nonatomic, retain) NSDate * lastupdated;
@property (nonatomic, retain) NSString * server_id;

@end
