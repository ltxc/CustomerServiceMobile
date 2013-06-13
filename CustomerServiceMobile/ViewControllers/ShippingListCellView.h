
#import <UIKit/UIKit.h>

@interface ShippingListCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblOriginalDocID;
@property (weak, nonatomic) IBOutlet UILabel *lblDestination;
@property (weak, nonatomic) IBOutlet UILabel *lblPartNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblBin;
@property (weak, nonatomic) IBOutlet UILabel *lblPriority;
@property (weak, nonatomic) IBOutlet UILabel *lblDueDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDemandID;
@property (weak, nonatomic) IBOutlet UILabel *lblItemID;
@property (weak, nonatomic) IBOutlet UIImageView *imgPicker;
@property (weak, nonatomic) IBOutlet UILabel *lblSerialNo;


@end
