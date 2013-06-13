

#import <UIKit/UIKit.h>
#import "ShippingHeader.h"
#import "ShippingList.h"

@protocol ShippingAvailableDelegate <NSObject>
@required
-(void)setSelectedShippingList:(ShippingList*)selected;
-(NSFetchedResultsController *)fetchedAvailableResultsController;
@end


@interface ShippingListTableView : UITableView <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
@property (weak,nonatomic) id<ShippingAvailableDelegate> availableDelegate;
@property (strong,nonatomic)NSString* transaction_type;
@end
