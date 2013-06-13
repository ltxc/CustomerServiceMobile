

#import <UIKit/UIKit.h>

@interface CycleCountMasterTableViewController : UITableViewController<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnButtons;
- (IBAction)selectCycleType:(id)sender;
- (IBAction)btnRefresh:(id)sender;
- (void)refreshCycleCountMaster;
@end
