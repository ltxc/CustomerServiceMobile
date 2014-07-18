

#import <UIKit/UIKit.h>
#import "InventoryHeader.h"
@protocol ProductViewDelegate <NSObject>
@required
-(InventoryHeader*)inventoryHeader;
-(void)addLineItem: (InventoryLineItem*) lineItem status:(BOOL)status isnew:(BOOL)isnew;
-(void)editLineItem:(InventoryLineItem*) lineItem status:(BOOL)status;
@end

@interface ProductViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic)InventoryLineItem* lineItem;

@property (weak, nonatomic) IBOutlet UITextField *txtProduct;
@property (weak, nonatomic) IBOutlet UITextField *txtSerialNo;
@property (weak, nonatomic) IBOutlet UITextField *txtQty;
@property (weak, nonatomic) IBOutlet UIPickerView *uiPickerViewInvType;
@property (weak, nonatomic) IBOutlet UITextField *txtReason;
@property (weak, nonatomic) IBOutlet UITextField *txtBin;
//@property (weak, nonatomic) IBOutlet UITextView *txtCause;
@property (weak, nonatomic) IBOutlet UILabel *lblInvType;
@property (weak, nonatomic) IBOutlet UIButton *btnHidePicker;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityBinPartQuery;

@property (weak,nonatomic) id<ProductViewDelegate> delegate;
@property (nonatomic) BOOL isMISC;
@property (nonatomic) BOOL isNew;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnBin:(id)sender;
- (IBAction)btnReason:(id)sender;
- (IBAction)btnHidePicker:(id)sender;


@end
