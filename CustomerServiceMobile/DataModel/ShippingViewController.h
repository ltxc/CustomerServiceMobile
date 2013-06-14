//Shipping view controller includes the ShippingListTableView.This view display the pick and shipping transaction. Header and line item.

#import <UIKit/UIKit.h>
#import "ShippingListTableView.h"
#import "ShippingHeader.h"
#import "ShippingListTableView.h"
#import "ShippingSelectedListTableView.h"
#import "ShippingScanViewController.h"



@interface ShippingViewController : UITableViewController<ShippingLineItemDeleteDelegate,ShippingScanViewDelegate, ShippingAvailableDelegate, UITextFieldDelegate>

@property (strong,nonatomic) ShippingHeader* shippingHeader;
@property (nonatomic) enum ShippingTypeEnum type;
@property (nonatomic) BOOL isNew;
@property (nonatomic, strong) NSFetchedResultsController *fetchedAvailableResultsController;
@property (strong, nonatomic) ShippingList* selectedShippingList;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentInvType;
- (IBAction)segInvTypeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblFromWarehouseID;
@property (weak, nonatomic) IBOutlet UITextField *lblToWarehouseID;
@property (weak, nonatomic) IBOutlet UIButton *btnToWarehouse;
- (IBAction)btnToWarehouse:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnToCompany;
@property (weak, nonatomic) IBOutlet UITextField *lblToCompanyID;
- (IBAction)btnToCompany:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessStatus;
@property (weak, nonatomic) IBOutlet UITextView *lblProcessMessage;
- (IBAction)btnSubmitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnProcessResult;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_processresult;

//ship extra fields
@property (weak, nonatomic) IBOutlet UITextField *lblCarrierID;
- (IBAction)btnCarrierID:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtCarrierRefNo;
@property (weak, nonatomic) IBOutlet UITextField *txtNoOfPackages;
@property (weak, nonatomic) IBOutlet UITextField *txtWeight;
@property (weak, nonatomic) IBOutlet UITextView *txtShippingInstruction;

@property (weak, nonatomic) IBOutlet ShippingSelectedListTableView *selectedTableView;
@property (weak, nonatomic) IBOutlet ShippingListTableView *availableTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_submit;
- (IBAction)btnShipmentInstructions:(id)sender;
- (IBAction)switchIsPrinting:(id)sender;
- (IBAction)btnProcessResult:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchIsPrinting;

@end
