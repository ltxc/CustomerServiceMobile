//
//  Warehouse.h
//  CustomerServiceMobile
//
//  Created by LTXC on 2/4/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Warehouse : NSManagedObject

@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * warehouse_id;

@end
