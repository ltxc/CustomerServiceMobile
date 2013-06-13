

#import <UIKit/UIKit.h>
#import "InventoryHeader.h"

@protocol ReceivingLineItemDeleteDelegate <NSObject>
@required
-(InventoryHeader*)inventoryHeader;
-(void)deleteLineItem:(NSInteger) rowIndex;
-(void)editLineItem:(InventoryLineItem *)lineItem;
@end


@interface ReceivingLineItemsTableView : UITableView <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) InventoryHeader* inventoryHeader;
@property (weak,nonatomic) id<ReceivingLineItemDeleteDelegate> deleteDelegate;

@end
