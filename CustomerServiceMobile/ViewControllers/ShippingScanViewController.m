

#import "ShippingScanViewController.h"
#import "SDUserPreference.h"
#import "MyRestkit.h"

@interface ShippingScanViewController ()
-(BOOL)validate;
-(void)dismissKeyBoard;
@end

@implementation ShippingScanViewController
@synthesize type=_type;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.lblBPart_Id.text = self.item.bpart_id;
    self.lblFromBin.text = self.item.fr_bin_code_id;
    self.lblQty.text = self.item.qty;
    self.lblSerialNo.text = self.item.serial_no;
//    self.btnOnOff.enabled = YES;
//    self.btnOnOff.on = NO;
    
//    if(self.isPick)
//        self.lblOnOffTitle.text = @"Pick";
//    else
//        self.lblOnOffTitle.text = @"Ship";
    switch (_type) {
        case PICK:
            self.lblOnOffTitle.text = @"Pick";
            break;
        case PICKLIST:
            self.lblOnOffTitle.text = @"Pick List";
            break;
        case SHIP:
            self.lblOnOffTitle.text = @"Ship";
            break;
        case SHIPLIST:
            self.lblOnOffTitle.text = @"Ship List";
            break;
        default:
            break;
    }
    if([self.item.ldmnd_stat_id isEqualToString:kShippingTypeShipStatID])
    {
        self.txtBpart_Id.text = self.item.bpart_id;
        self.txtSerialNo.text = self.item.serial_no;
        self.txtQty.text = self.item.qty;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.txtBpart_Id becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)btnOnOffAction:(id)sender {
//    if(![self validate])
//        self.btnOnOff.on = NO;
//}
- (IBAction)btnCancel:(id)sender {
    [self.delegate addLineItem:self.item status:NO];
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSave:(id)sender {
    
    if(![self validate])
    {
        return;
    }
    else
    {
        [self.delegate addLineItem:self.item status:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    

    if(textField==self.txtBpart_Id)
    {
        [self.txtSerialNo becomeFirstResponder];
    }
    else if (textField==self.txtSerialNo)
    {
        NSString* serialno = self.txtSerialNo.text;
        if (nil!=serialno&&![serialno isEqualToString:@""]) {
            self.txtQty.text = @"1";
        }
        [self.txtQty becomeFirstResponder];
    }
    else if(textField==self.txtQty)
    {
        [self dismissKeyBoard];
    }
     
    
    return YES;
}


-(void)dismissKeyBoard
{

    [self.txtBpart_Id resignFirstResponder];
    [self.txtSerialNo resignFirstResponder];
    [self.txtQty resignFirstResponder];
}

// if not override, the model view keyboard does not dismissed.
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

-(BOOL)validate
{

    BOOL isValidated = YES;
    NSString* fieldname = @"";
    NSString* bpartID = [SDUserPreference trim:self.txtBpart_Id.text];
    NSString* serialno = [SDUserPreference trim:self.txtSerialNo.text];
    NSString* qty = [SDUserPreference trim:self.txtQty.text];
    if(![self.item.bpart_id isEqualToString:bpartID])
    {
        fieldname = @"Part Number";
        isValidated = NO;
    }
    if(self.item.serial_no!=nil&&![self.item.serial_no isEqualToString:@""])
    {
        if(![self.item.serial_no isEqualToString:serialno])
        {
            isValidated = NO;
            fieldname = @"Serial No";
        }
    }
    
    if(![self.item.qty isEqualToString:qty])
    {
        isValidated = NO;
        fieldname = @"Quantity";
    }
    
    if(!isValidated)
    {
        
        [SDDataEngine alert:fieldname title:@"Failed" template:kMessageShippingNotMatch delegate:nil];
        //self.btnOnOff.on = NO;
    }
    return isValidated;
}
@end
