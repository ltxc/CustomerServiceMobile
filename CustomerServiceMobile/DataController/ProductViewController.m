//
//  ProductViewController.m
//  CustomerServiceMobile


#import "ProductViewController.h"
#import "InventoryLineItem.h"
#import "SDDataEngine.h"
#import "SharedConstants.h"
#import "AutoCompleteController.h"
#import "AutoCompleteDataHelper.h"
#import "BinPart.h"
#import "ManAdjustReason.h"
#import "ReceivingViewController.h"
#import "SDUserPreference.h"
#import "SDRestKitEngine.h"
#import "SDDataControllers.h"
#import "CoreDataGetSynch.h"

@interface ProductViewController ()
-(void)invTypeTapped;-(void)showPicker;
-(void)hidePick;
-(void)hideKeyBoard;
@end

@implementation ProductViewController
@synthesize isMISC=_isMISC;
@synthesize isNew=_isNew;
@synthesize lineItem=_lineItem;

NSArray* _invTypeArray;
BOOL _isPickerShow;
BOOL _isSynchBinPartQuery;

- (void)viewDidLoad
{
    BOOL isMiscTransaction = FALSE;
    
    if (self.delegate!=nil&&[self.delegate inventoryHeader]!=nil&&[kTransactionTypeMRC isEqualToString:[[self.delegate inventoryHeader] transaction_type]]) {
        isMiscTransaction = TRUE;
    }
    
    if (isMiscTransaction)
    {
        _invTypeArray = [NSArray arrayWithObjects:@"good",@"bad", nil];
    }
    else
    {
        _invTypeArray = [NSArray arrayWithObjects:@"default",@"good",@"bad", nil];
    }
    
    if(_isNew)
    {
        //create one
        NSManagedObjectContext* managedObjectContext = [[SDDataEngine sharedEngine] managedObjectContext];
        _lineItem = [NSEntityDescription insertNewObjectForEntityForName:kEntityInventoryLineItem inManagedObjectContext:managedObjectContext];
    }
    [super viewDidLoad];

    [self.uiPickerViewInvType selectedRowInComponent:0];
    if(_isNew)
    {
        if (isMiscTransaction) {
            _lineItem.inv_type_id = @"good";
        }
        else
        {
            _lineItem.inv_type_id = @"default";
        }
        self.txtQty.text = @"1";
    }
    else
    {
        //populate the fields

        self.txtSerialNo.text=_lineItem.serial_no;
        self.txtQty.text=_lineItem.qty;
        self.txtProduct.text = _lineItem.bpart_id;
        self.txtBin.text=_lineItem.bin_code_id;
        if(nil!=_lineItem.man_adj_reason_id)
            self.txtReason.text=_lineItem.man_adj_reason_id;
    }


    //set picker
    _isSynchBinPartQuery = NO;
    _isPickerShow = NO;
    self.btnHidePicker.hidden = YES;
    self.lblInvType.userInteractionEnabled=YES;
    UITapGestureRecognizer* pickTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(invTypeTapped)];
    [self.lblInvType addGestureRecognizer:pickTapRecognizer];
}



-(void)viewDidAppear:(BOOL)animated
{
    [self.txtProduct becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)btnSave:(id)sender {
    NSNumber* qty = [[[NSNumberFormatter alloc]init] numberFromString:self.txtQty.text];
    if (qty==nil)
    {    
        [SDDataEngine alert:kMessageQtyNotNumber title:nil template:kMessageValidationRequiredTemplate delegate:self];
      
        return;
    }
    //check if serial no is provided
    _lineItem.serial_no = self.txtSerialNo.text;
    if(![self.txtSerialNo.text isEqualToString:@""])
    {
        int intQty = [qty intValue];
        if(intQty>1)
        {
            
            [SDDataEngine alert:kMessageReceivingSerialNoRule title:nil template:nil delegate:self];
            qty = [NSNumber numberWithInt:1];
        }
    }
    _lineItem.qty = [qty stringValue];
    
    NSString* bpart_id = [SDUserPreference trim:self.txtProduct.text];
    if([bpart_id isEqualToString:@""])
    {
        [SDDataEngine alert:@"Product (bpart_id)" title:nil template:kMessageValidationRequiredTemplate delegate:self];
        return;
    }
    else
        _lineItem.bpart_id = bpart_id;



    NSString* bin_code_ide = [SDUserPreference trim:self.txtBin.text];
    if([bin_code_ide isEqualToString:@""])
    {
        [SDDataEngine alert:@"Bin" title:nil template:kMessageValidationRequiredTemplate delegate:self];
        return;
    }
    else
        _lineItem.bin_code_id = bin_code_ide;

    
    if(self.isMISC)
    {
        NSString* reasoncode = [SDUserPreference trim:self.txtReason.text];
        if([reasoncode isEqualToString:@""])
        {
            [SDDataEngine alert:@"Reason Code" title:nil template:kMessageValidationRequiredTemplate delegate:self];
            return;
        }
        else
            _lineItem.man_adj_reason_id = reasoncode;
        
    }


    if(_isNew)
        [self.delegate addLineItem:_lineItem status:YES isnew:_isNew];
    else
        [self.delegate editLineItem:_lineItem status:YES];
}

- (IBAction)btnCancel:(id)sender {
    [self.delegate addLineItem:_lineItem status:NO isnew:_isNew];
}

//synch version
//- (IBAction)btnBin:(id)sender {
//    [self hideKeyBoard];
//    NSString* bpart_id = self.txtProduct.text;
//
////query the bin part relationship based on the current warehouse, it is synch call
//    CoreDataGetSynch* coreDataGetSynch =[SDRestKitEngine sharedBinPartQueryController:[SDUserPreference sharedUserPreference].DefaultWarehouseID bpartid:bpart_id];
//    [coreDataGetSynch load:nil];
//    NSNumber* status = [coreDataGetSynch status];
//    NSString* info = [coreDataGetSynch message];
//    if ([status isEqualToNumber:[NSNumber numberWithInt:0]]) {
//        //alert with info
//        NSString* message = [NSString stringWithFormat:kMessageBinPartSearchQueryFailure,info];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bin Part Search Failed" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        
//    }
//
//    
//    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityBinPart                           withDisplayBlock:^(id object){
//            BinPart* binPart = (BinPart*)object;
//            NSString* display = [NSString stringWithFormat:kBinPartDisplayTemplate, [binPart  bin_code_id], [binPart qty], [binPart inv_type_id]];
//           return display;
//        }
//        withBlock:    ^(BOOL status, id result)
//                                      {
//                                          if(status==YES)
//                                              self.txtBin.text = [(BinPart*)result bin_code_id];
//                                          else
//                                              self.txtBin.text = @"";
//                                          [self dismissViewControllerAnimated:YES completion:nil];
//                                      }
//                                      ];
//    
//    //helper.template=@"bpart_id=%@";
//    //helper.value = bpart_id;
//    [helper setPredicateWithTemplate:@"(bpart_id=%@) OR (bpart_id='all')" value:bpart_id];
//    [helper addSortDescript:kSortAttributeBinPart ascending:YES];
//    
//    // self.modalPresentationStyle = UIModalPresentationFormSheet;
//    AutoCompleteController* autoCompleteController = [[AutoCompleteController alloc] init];
//    autoCompleteController.autoCompleteDelegate = helper;
//    autoCompleteController.autoCompleteTitle = @"Please select a bin";
//    [self presentViewController:autoCompleteController animated:YES completion:nil];
//
//    
//}


- (IBAction)btnBin:(id)sender {
    if (!_isSynchBinPartQuery) {
        _isSynchBinPartQuery = YES;
        [self.activityBinPartQuery startAnimating];
        [self hideKeyBoard];
        NSString* bpart_id = self.txtProduct.text;
        NSString* warehouse_id = [[SDUserPreference sharedUserPreference]DefaultWarehouseID];
        //query the bin part relationship based on the current warehouse, it is synch call
        CoreDataGetSynch* coreDataGetSynch =[SDRestKitEngine sharedBinPartQueryController];
        [coreDataGetSynch addNotificationObserver:self notificationName:kNotificationNameBinPartQuery selector:@selector(synchNotifiedBinPart:)];
        [coreDataGetSynch load:^NSString *(NSString *baseUrl, id postedObject) {
            NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamWarehouseId,warehouse_id,kQueryParamBPartId,bpart_id, nil];
            NSString* queryurl = [kUrlBaseBinPartQuery stringByAppendingQueryParameters:dictionary];
            return queryurl;
        }];
        
        
    }
    

    
    
}

-(void) synchNotifiedBinPart:(NSNotification *)notification
{
    NSString* bpart_id = self.txtProduct.text;
    
    
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameBinPartQuery];
    NSNumber* status = [[SDRestKitEngine sharedEngine] getNotificationStatus:notification];

    if ([status isEqualToNumber:[NSNumber numberWithInt:0]]) {
        //alert with info
        NSString* message = [NSString stringWithFormat:kMessageBinPartSearchQueryFailure,info];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bin Part Search Failed" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityBinPart                           withDisplayBlock:^(id object){
        BinPart* binPart = (BinPart*)object;
        NSString* display = [NSString stringWithFormat:kBinPartDisplayTemplate, [binPart  bin_code_id], [binPart qty], [binPart inv_type_id]];
        return display;
    }
                                                                              withBlock:    ^(BOOL status, id result)
                                      {
                                          if(status==YES)
                                              self.txtBin.text = [(BinPart*)result bin_code_id];
                                          else
                                              self.txtBin.text = @"";
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      }
                                      ];
    
    //helper.template=@"bpart_id=%@";
    //helper.value = bpart_id;
    [helper setPredicateWithTemplate:@"(bpart_id=%@) OR (bpart_id='all')" value:bpart_id];
    [helper addSortDescript:kSortAttributeBinPart ascending:YES];
    
    // self.modalPresentationStyle = UIModalPresentationFormSheet;
    AutoCompleteController* autoCompleteController = [[AutoCompleteController alloc] init];
    autoCompleteController.autoCompleteDelegate = helper;
    autoCompleteController.autoCompleteTitle = @"Please select a bin";
    [self presentViewController:autoCompleteController animated:YES completion:nil];
    
    _isSynchBinPartQuery = NO;
    [self.activityBinPartQuery stopAnimating];
     [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameBinPartQuery];
}

- (IBAction)btnReason:(id)sender {
    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityManAdjustReason withDisplayBlock:^(id object){
            ManAdjustReason* reason = (ManAdjustReason*)object;
            NSString* display = [NSString stringWithFormat:@"%@", [reason reasoncode]];


            return display;
        }
        withBlock:    ^(BOOL status, id result)
                                      {
                                          if(status==YES)
                                              self.txtReason.text = [(ManAdjustReason*)result reasoncode];
                                          else
                                              self.txtReason.text = @"";
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      }
                                      ];
    [helper addSortDescript:kSortAttributeManAdjustReason ascending:YES];
    // self.modalPresentationStyle = UIModalPresentationFormSheet;
    AutoCompleteController* autoCompleteController = [[AutoCompleteController alloc] init];
    autoCompleteController.autoCompleteDelegate = helper;
    autoCompleteController.autoCompleteTitle = @"Please select a reason code";
    [self presentViewController:autoCompleteController animated:YES completion:nil];
    
    
}

- (IBAction)btnHidePicker:(id)sender {
    [self hidePick];
}

#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.txtProduct)
    {
        [self.txtSerialNo becomeFirstResponder];
    }
    else if (textField==self.txtSerialNo)
    {
        [self.txtBin becomeFirstResponder];
    }
    return YES;
}

#pragma UIPickViewerDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_invTypeArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_invTypeArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* type = [_invTypeArray objectAtIndex:row];

    _lineItem.inv_type_id = type;
    self.lblInvType.text = type;

}

-(void)invTypeTapped
{
    [self showPicker];
}

-(void)showPicker
{
    [self hideKeyBoard];
    _isPickerShow = YES;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.uiPickerViewInvType.transform = CGAffineTransformMakeTranslation(0, -300);
    [UIView commitAnimations];
    self.btnHidePicker.hidden = NO;
    self.lblInvType.hidden = YES;
}

-(void)hidePick
{
    _isPickerShow = NO;
    [UIView beginAnimations:@"SlideInPicker" context:nil];
    [UIView setAnimationDuration:0.5];
    self.uiPickerViewInvType.transform = CGAffineTransformMakeTranslation(0, 300);
    [UIView commitAnimations];
    self.btnHidePicker.hidden = YES;
    self.lblInvType.hidden = NO;
}

-(void)hideKeyBoard
{
    [self.txtProduct resignFirstResponder];
    [self.txtSerialNo resignFirstResponder];
    [self.txtBin resignFirstResponder];
    [self.txtQty resignFirstResponder];
    [self.txtReason resignFirstResponder];
}
@end
