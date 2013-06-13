//
//  InventoryHeader.h
//  CustomerServiceMobile
//
//  Created by LTXC on 2/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InventoryLineItem;

@interface InventoryHeader : NSManagedObject

@property (nonatomic, retain) NSString * carrier_id;
@property (nonatomic, retain) NSString * carrier_refno;
@property (nonatomic, retain) NSString * company_id;
@property (nonatomic, retain) NSString * created_by;
@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSString * fr_warehouse_id;
@property (nonatomic, retain) NSString * ipad_id;
@property (nonatomic, retain) NSString * no_of_packages;
@property (nonatomic, retain) NSString * our_refno;
@property (nonatomic, retain) NSString * pdf_attachment;
@property (nonatomic, retain) NSDate * process_date;
@property (nonatomic, retain) NSString * process_message;
@property (nonatomic, retain) NSString * process_status;
@property (nonatomic, retain) NSString * ref_doc_type_id;
@property (nonatomic, retain) NSString * sender_refno;
@property (nonatomic, retain) NSString * ship_instructions;
@property (nonatomic, retain) NSString * to_warehouse_id;
@property (nonatomic, retain) NSString * transaction_type;
@property (nonatomic, retain) NSString * vender_refno;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * printer;
@property (nonatomic, retain) NSOrderedSet *inventoryLineItems;
@end

@interface InventoryHeader (CoreDataGeneratedAccessors)

- (void)insertObject:(InventoryLineItem *)value inInventoryLineItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromInventoryLineItemsAtIndex:(NSUInteger)idx;
- (void)insertInventoryLineItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeInventoryLineItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInInventoryLineItemsAtIndex:(NSUInteger)idx withObject:(InventoryLineItem *)value;
- (void)replaceInventoryLineItemsAtIndexes:(NSIndexSet *)indexes withInventoryLineItems:(NSArray *)values;
- (void)addInventoryLineItemsObject:(InventoryLineItem *)value;
- (void)removeInventoryLineItemsObject:(InventoryLineItem *)value;
- (void)addInventoryLineItems:(NSOrderedSet *)values;
- (void)removeInventoryLineItems:(NSOrderedSet *)values;
@end
