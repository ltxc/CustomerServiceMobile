

#import <UIKit/UIKit.h>

@interface ShippingRootViewController : UIViewController<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewButtons;
- (IBAction)synchShippingList:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_synch;
- (IBAction)btnRemoveHistoryData:(id)sender;


@end
