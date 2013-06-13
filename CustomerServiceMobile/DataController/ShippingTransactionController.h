

#import "DataSynchController.h"
#import "ShippingHeader.h"
@interface ShippingTransactionController : DataSynchController
@property (nonatomic) BOOL isPart;
-(BOOL)post:(ShippingHeader*)shippingHeader;
-(RKObjectMapping *) shippingMapping;
@end
