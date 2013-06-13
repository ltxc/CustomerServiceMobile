#import <UIKit/UIKit.h>
#import "RPInformation.h"
@interface RPInformationViewController : UIViewController
@property (strong, nonatomic) RPInformation* rpInformation;

@property (weak, nonatomic) IBOutlet UILabel *lblDestWarehouseID;
@property (weak, nonatomic) IBOutlet UILabel *lblPriority;
@property (weak, nonatomic) IBOutlet UILabel *lblContract;
@property (weak, nonatomic) IBOutlet UILabel *lblWarranty;
@property (weak, nonatomic) IBOutlet UILabel *lblPO;
@property (weak, nonatomic) IBOutlet UILabel *lblProblemCode;
- (IBAction)btnOK:(id)sender;

@end
