//
//  SynchTableViewController.h
//  CustomerServiceMobile
//


#import <UIKit/UIKit.h>


@interface SynchTableViewController : UITableViewController

@property NSDateFormatter *dateFormatter;

@property (weak, nonatomic) IBOutlet UIButton *btnSynchBinPart;
@property (weak, nonatomic) IBOutlet UIButton *btnSynchCompany;
@property (weak, nonatomic) IBOutlet UIButton *btnSynchCarrier;
@property (weak, nonatomic) IBOutlet UIButton *btnSynchWarehouse;


@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate_SynchApplicationData;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus_SynchApplicationData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_synchApplicationData;



@property IBOutlet UILabel * lblLastUpdated_SynchCompany;
@property IBOutlet UILabel * lblStatus_SynchCompany;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_SynchCompany;


@property IBOutlet UILabel * lblLastUpdated_SynchCarrier;
@property IBOutlet UILabel * lblStatus_SynchCarrier;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_SynchCarrier;


@property IBOutlet UILabel * lblLastUpdated_SynchWarehosue;
@property IBOutlet UILabel * lblStatus_SynchWarehouse;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_SynchWarehouse;


@property IBOutlet UILabel * lblLastUpdated_SynchBin;
@property IBOutlet UILabel * lblStatus_SynchBin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_SynchBin;

@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdated_SynchReason;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus_SynchReason;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_SynchReason;

@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdated_SynchReports;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus_SynchReports;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_SynchReports;

@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdated_SynchShipmentInstructions;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus_SynchShipmentInstructions;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_SynchShipmentInstructions;


-(IBAction) synchAll:(id)sender;
- (IBAction)resetAll:(id)sender;
- (IBAction)synchApplicationData:(id)sender;
-(IBAction) synchCompany:(id)sender;
-(IBAction) synchCarrier:(id)sender;
-(IBAction) synchWarehouse:(id)sender;
-(IBAction) synchBin:(id)sender;
- (IBAction)synchReason:(id)sender;
- (IBAction)synchReports:(id)sender;
- (IBAction)synchShipmentInstructions:(id)sender;


- (IBAction)clearLocalDatabase:(id)sender;

- (void) setDataFromUserDefault:(NSDateFormatter*) formatter;
@end
