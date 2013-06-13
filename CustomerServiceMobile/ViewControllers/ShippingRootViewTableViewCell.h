

#import <UIKit/UIKit.h>

@interface ShippingRootViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblID;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblTo;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessDate;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessMessage;

@end
