

#import <UIKit/UIKit.h>
#import "ShippingHeader.h"
#import "ShippingList.h"
#import "SharedConstants.h"
@protocol ShippingScanViewDelegate <NSObject>
@required
-(ShippingHeader*)shippingHeader;
-(void)addLineItem: (ShippingList*) lineItem status:(BOOL)status;
@end

@interface ShippingScanViewController : UIViewController<UITextFieldDelegate>

@property (weak,nonatomic) id<ShippingScanViewDelegate> delegate;
@property (strong, nonatomic) ShippingList* item;
//@property (nonatomic)BOOL isPick;
@property (nonatomic)enum ShippingTypeEnum type;
@property (weak, nonatomic) IBOutlet UILabel *lblFromBin;
@property (weak, nonatomic) IBOutlet UILabel *lblBPart_Id;
@property (weak, nonatomic) IBOutlet UILabel *lblSerialNo;
@property (weak, nonatomic) IBOutlet UILabel *lblQty;
@property (weak, nonatomic) IBOutlet UILabel *lblOnOffTitle;
//@property (weak, nonatomic) IBOutlet UISwitch *btnOnOff;
//- (IBAction)btnOnOffAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtBpart_Id;
@property (weak, nonatomic) IBOutlet UITextField *txtSerialNo;
@property (weak, nonatomic) IBOutlet UITextField *txtQty;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;


@end
