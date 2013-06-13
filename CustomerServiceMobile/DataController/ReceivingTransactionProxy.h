

#import <Foundation/Foundation.h>
#import "InventoryHeader.h"
#import "CarrierProxy.h"
#import "WarehouseProxy.h"
#import "CompanyProxy.h"
@interface ReceivingTransactionProxy : NSObject
-(ReceivingTransactionProxy*)initWithInventoryHeader:(InventoryHeader*)inventoryHeader;
@property (nonatomic, readonly) CarrierProxy * carrier;
@property (nonatomic, readonly) NSString * carrier_refno;
@property (nonatomic, readonly) CompanyProxy * company;
@property (nonatomic, readonly) NSString * created_by;
@property (nonatomic, readonly) NSDate * created_date;
@property (nonatomic, readonly) WarehouseProxy * fr_warehouse;
@property (nonatomic, readonly) NSString * ipad_id;
@property (nonatomic, readonly) NSString * no_of_packages;
@property (nonatomic, readonly) NSString * our_refno;
@property (nonatomic, readonly) NSString * pdf_attachment;
@property (nonatomic, retain) NSDate * process_date;
@property (nonatomic, retain) NSString * process_message;
@property (nonatomic, retain) NSString * process_status;
@property (nonatomic, readonly) NSString * ref_doc_type_id;
@property (nonatomic, readonly) NSString * sender_refno;
@property (nonatomic, readonly) NSString * ship_instructions;
@property (nonatomic, readonly) WarehouseProxy * to_warehouse;
@property (nonatomic, readonly) NSString * transaction_type;
@property (nonatomic, readonly) NSString * vender_refno;
@property (nonatomic, readonly) NSString * weight;
@property (nonatomic, readonly) NSOrderedSet *inventoryLineItems;
@end
