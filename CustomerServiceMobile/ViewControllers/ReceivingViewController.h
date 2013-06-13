

#import <UIKit/UIKit.h>

#import "InventoryHeader.h"
#import "ReceivingLineItemsTableView.h"
#import "ProductViewController.h"
#import "ProcessResult.h"
@interface ReceivingViewController : UITableViewController <ProductViewDelegate, ReceivingLineItemDeleteDelegate>
+(NSString*)receivingTypeDescription:(NSString*)transactionType title:(BOOL)isTitle;

@property (strong, nonatomic) InventoryHeader* inventoryHeader;
@property (strong,nonatomic) NSString* transactionType;
@property (nonatomic) BOOL isNew;


@property (weak, nonatomic) IBOutlet UITextField *lblToWarehouse;
@property (weak, nonatomic) IBOutlet UITextField *lblFromCompany;
@property (weak, nonatomic) IBOutlet UITextField *lblVendorRefNo;
@property (weak, nonatomic) IBOutlet UITextField *lblCarrier;
@property (weak, nonatomic) IBOutlet UITextField *lblCarrierRefNo;
@property (weak, nonatomic) IBOutlet ReceivingLineItemsTableView *lineItemsTableView;

//other than MISC
@property (weak, nonatomic) IBOutlet UITextField *txtDocumentType;
@property (weak, nonatomic) IBOutlet UITextField *txtOurRefNo;

@property (weak, nonatomic) IBOutlet UILabel *lblProcessStatus;
@property (weak, nonatomic) IBOutlet UITextView *lblProcessMessage;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_submit;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_rpinformation;

- (IBAction)btnToWarehouse:(id)sender;
- (IBAction)btnFromCompany:(id)sender;
- (IBAction)btnCarrier:(id)sender;
- (IBAction)btnAdd:(id)sender;
- (IBAction)btnSubmit:(id)sender;
- (IBAction)btnOurRefNo:(id)sender;


-(ProcessResult*)postInventoryTransaction:(InventoryHeader*) inventoryTransaction;
@end
