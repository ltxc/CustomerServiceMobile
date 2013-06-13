//
//  ShippingHeader.h
//  CustomerServiceMobile
//
//  Created by LTXC on 3/19/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShippingLineItem;

@interface ShippingHeader : NSManagedObject

@property (nonatomic, retain) NSString * carrier_id;
@property (nonatomic, retain) NSString * carrier_refno;
@property (nonatomic, retain) NSString * created_by;
@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSString * doc_type_id;
@property (nonatomic, retain) NSString * fr_warehouse_id;
@property (nonatomic, retain) NSString * ifield1;
@property (nonatomic, retain) NSString * ipad_id;
@property (nonatomic, retain) NSString * no_of_packages;
@property (nonatomic, retain) NSString * pi_doc_id;
@property (nonatomic, retain) NSString * printer;
@property (nonatomic, retain) NSDate * process_date;
@property (nonatomic, retain) NSString * process_message;
@property (nonatomic, retain) NSString * process_status;
@property (nonatomic, retain) NSString * sfield1;
@property (nonatomic, retain) NSString * ship_instructions;
@property (nonatomic, retain) NSString * shipped_by;
@property (nonatomic, retain) NSString * to_company_id;
@property (nonatomic, retain) NSString * to_warehouse_id;
@property (nonatomic, retain) NSString * transaction_type;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * isprinting;
@property (nonatomic, retain) NSString * is_vendor;
@property (nonatomic, retain) NSOrderedSet *shippingLineItems;
@end

@interface ShippingHeader (CoreDataGeneratedAccessors)

- (void)insertObject:(ShippingLineItem *)value inShippingLineItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromShippingLineItemsAtIndex:(NSUInteger)idx;
- (void)insertShippingLineItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeShippingLineItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInShippingLineItemsAtIndex:(NSUInteger)idx withObject:(ShippingLineItem *)value;
- (void)replaceShippingLineItemsAtIndexes:(NSIndexSet *)indexes withShippingLineItems:(NSArray *)values;
- (void)addShippingLineItemsObject:(ShippingLineItem *)value;
- (void)removeShippingLineItemsObject:(ShippingLineItem *)value;
- (void)addShippingLineItems:(NSOrderedSet *)values;
- (void)removeShippingLineItems:(NSOrderedSet *)values;
@end
