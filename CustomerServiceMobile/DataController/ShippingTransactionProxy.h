

#import <Foundation/Foundation.h>
#import "ShippingHeader.h"
@interface ShippingTransactionProxy : NSObject
-(ShippingTransactionProxy*)initWithShippingHeader:(ShippingHeader*)shippingHeader;
@property (nonatomic, readonly) NSString * carrier_id;
@property (nonatomic, readonly) NSString * carrier_refno;
@property (nonatomic, readonly) NSString * created_by;
@property (nonatomic, readonly) NSString * shipped_by;
@property (nonatomic, readonly) NSDate * created_date;
@property (nonatomic, readonly) NSString * fr_warehouse_id;
@property (nonatomic, readonly) NSString * ipad_id;
@property (nonatomic, readonly) NSString * printer;
@property (nonatomic, readonly) NSString * isprinting;
@property (nonatomic, readonly) NSString * no_of_packages;
@property (nonatomic, retain) NSDate * process_date;
@property (nonatomic, retain) NSString * process_message;
@property (nonatomic, retain) NSString * process_status;
//@property (nonatomic, readonly) NSString * ref_doc_type_id;
@property (nonatomic, readonly) NSString * ship_instructions;
@property (nonatomic, readonly) NSString * to_warehouse_id;
@property (nonatomic, readonly) NSString * to_company_id;
@property (nonatomic, readonly) NSString * transaction_type;
@property (nonatomic, readonly) NSString * vender_refno;
@property (nonatomic, readonly) NSString * weight;
@property (nonatomic, readonly) NSString * doc_type_id;
@property (nonatomic, readonly) NSString * is_vendor;
@property (nonatomic, readonly) NSOrderedSet *shippingLineItems;
@end
