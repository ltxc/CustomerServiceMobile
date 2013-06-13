

#import <UIKit/UIKit.h>
#import "ShippingHeader.h"
@protocol ShippingLineItemDeleteDelegate <NSObject>
@required
-(ShippingHeader*)shippingHeader;
-(void)deleteLineItem:(NSInteger) rowIndex;
@end

@interface ShippingSelectedListTableView : UITableView <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSString* transaction_type;
@property (weak,nonatomic) id<ShippingLineItemDeleteDelegate> deleteDelegate;
@end
