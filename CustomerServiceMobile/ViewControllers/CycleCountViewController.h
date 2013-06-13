

#import <UIKit/UIKit.h>
#import "CycleCountMaster.h"
#import "CycleCountItemsTableView.h"
#import "CalculatorViewController.h"
@interface CycleCountViewController : UITableViewController <CycleCountItemDeleteDelegate,UITextFieldDelegate,CalculatorDelegate>
@property (strong, nonatomic,readonly)CalculatorViewController* calculator;
- (IBAction)btnCalculator:(id)sender;

@property (strong, nonatomic) CycleCountMaster* cycleCountMaster;
@property (weak, nonatomic) IBOutlet UILabel *lblBinCode;
@property (weak, nonatomic) IBOutlet UILabel *lblPartNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldTarget;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldQty;
@property (weak, nonatomic) IBOutlet UITextView *txtFieldComment;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCounts;
@property (weak, nonatomic) IBOutlet UILabel *lblCycleCountMasterQty;

@property (weak, nonatomic) IBOutlet UITextView *lblProcessMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveAndNext;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet CycleCountItemsTableView *cycleCountTableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_submit;

- (IBAction)btnSaveAndNext:(id)sender;

- (IBAction)btnSubmit:(id)sender;

@end
