

#import <UIKit/UIKit.h>
#import "CycleCountMaster.h"

@protocol CycleCountItemDeleteDelegate <NSObject>
@required
-(CycleCountMaster*)cycleCountMaster;
-(void)deleteItem:(NSInteger) rowIndex;
@end
@interface CycleCountItemsTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) CycleCountMaster* cycleCountMaster;
@property (weak, nonatomic) id<CycleCountItemDeleteDelegate> deleteDelegate;
@end
