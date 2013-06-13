//
//  ReceivingRootViewController.h
//  CustomerServiceMobile


#import <UIKit/UIKit.h>
#import "InventoryHeader.h"
@interface ReceivingRootViewController : UIViewController<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewButtons;
- (IBAction)btnRemoveHistoryData:(id)sender;


@end
