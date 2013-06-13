

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *lblDefaultWarehouse;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblPrinter;
@property (weak, nonatomic) IBOutlet UILabel *lblApplicationServer;
@property (weak, nonatomic) IBOutlet UILabel *lblReportServer;
@property (weak, nonatomic) IBOutlet UILabel *lblLandscape;
@property (weak, nonatomic) IBOutlet UITableViewCell *layoutView;
@property (weak, nonatomic) IBOutlet UIButton *btnLandscape;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_SynchWarehouse;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_SynchApplicationData;


- (IBAction)btnWarehouseID:(id)sender;
- (IBAction)btnPrinter:(id)sender;
- (IBAction)btnLandscape:(id)sender;
- (IBAction)btnRefresh:(id)sender;

@end
