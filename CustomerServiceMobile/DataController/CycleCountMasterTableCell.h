
#import <UIKit/UIKit.h>

@interface CycleCountMasterTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCycleCountType;
@property (weak, nonatomic) IBOutlet UILabel *lblBinCode;
@property (weak, nonatomic) IBOutlet UILabel *lblBPart;
@property (weak, nonatomic) IBOutlet UILabel *lblAssignedDate;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessMessage;

@end
