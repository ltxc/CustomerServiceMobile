

#import <UIKit/UIKit.h>


@interface QueriesViewController : UITableViewController<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
- (IBAction)btnRefresh:(id)sender;
//@property (strong,nonatomic) NSArray* queries;
@end
