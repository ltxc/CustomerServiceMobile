//
//  InventoryLineItem.h
//  CustomerServiceMobile
//
//  Created by LTXC on 2/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InventoryHeader;

@interface InventoryLineItem : NSManagedObject

@property (nonatomic, retain) NSString * bin_code_id;
@property (nonatomic, retain) NSString * bpart_id;
@property (nonatomic, retain) NSString * cause;
@property (nonatomic, retain) NSString * inv_type_id;
@property (nonatomic, retain) NSString * lineitemnumber;
@property (nonatomic, retain) NSString * man_adj_reason_id;
@property (nonatomic, retain) NSString * qty;
@property (nonatomic, retain) NSString * serial_no;
@property (nonatomic, retain) InventoryHeader *header;

@end
