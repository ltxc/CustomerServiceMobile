
#import "CycleCountViewController.h"
#import "MyRestkit.h"
#import "CycleCountCount.h"
#import "CycleCountController.h"

@interface CycleCountViewController ()
-(void) threadStartAnimating:(UIActivityIndicatorView*)indicator;
- (void)resetFields;
@end

@implementation CycleCountViewController
@synthesize cycleCountMaster=_cycleCountMaster;
@synthesize cycleCountTableView=_cycleCountTableView;
@synthesize calculator=_calculator;
BOOL _isBinCount = YES;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //populate the cycle count master data
    self.lblBinCode.text = self.cycleCountMaster.bin_code_id;
    if(![kCycleCountTypeBin isEqualToString:self.cycleCountMaster.cycle_type])
    {
        //part count
        self.lblPartNumber.text = self.cycleCountMaster.bpart_id;
        self.lblCycleCountMasterQty.text = self.cycleCountMaster.qty;
        _isBinCount = NO;
    }
    else
        _isBinCount = YES;
    
    self.lblProcessStatus.text = self.cycleCountMaster.process_status;
    self.lblProcessMessage.text = self.cycleCountMaster.process_message;
    self.lblTotalCounts.text = [self getTotalCounts];
    self.cycleCountTableView.cycleCountMaster = self.cycleCountMaster;
    self.cycleCountTableView.deleteDelegate = self;
    self.cycleCountTableView.dataSource = self.cycleCountTableView;
    self.cycleCountTableView.delegate = self.cycleCountTableView;

}

-(void)viewWillAppear:(BOOL)animated
{
    if(!_isBinCount)
    {
        if ([self.cycleCountMaster.isserialized isEqualToNumber:[NSNumber numberWithInt:1]]){
                //part is serialized
            self.lblIsSerialized.text = @"serialized";
            self.txtFieldQty.text = @"1";
            self.txtFieldQty.enabled = NO;
            self.txtFieldTarget.enabled = YES;
            self.btnQty.hidden = YES;
            [self.txtFieldTarget becomeFirstResponder];
        }
        else
        {
            self.lblIsSerialized.text = @"non serialized";
            self.txtFieldQty.text = @"";
            self.txtFieldQty.enabled = YES;
            self.txtFieldTarget.enabled = NO;
            self.btnQty.hidden = NO;
            [self.txtFieldQty becomeFirstResponder];
        }
    }
    else
        self.txtFieldTarget.enabled = YES;
   
}

-(CalculatorViewController *)calculator
{
    if(nil==_calculator)
    {
        _calculator=[[CalculatorViewController alloc] initWithNibName:nil bundle:nil];
        _calculator.delegate = self;
    }
    
    return _calculator;
}



-(void)setResult:(NSString *)result status:(BOOL)status
{
    if (status&&![result isEqualToString:@""]) {
        self.txtFieldQty.text = result;
    }
    //dismiss the popover
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*) getTotalCounts
{
    NSUInteger total =  [self.cycleCountMaster.counts count];
    return [NSString stringWithFormat:@"%d", total];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSaveAndNext:(id)sender {
    //collect the data
    NSString* target = [self.txtFieldTarget.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];


    NSNumber* qty = [[[NSNumberFormatter alloc]init] numberFromString:self.txtFieldQty.text];
    NSString* comment = self.txtFieldComment.text;
    if (qty==nil)
    {
        [SDDataEngine alert:kMessageQtyNotNumber title:nil template:nil delegate:self];
        
        return;
    }
    
    if(_isBinCount)
    {
        //bin count
        
        if ([target isEqualToString:@""]) {
            [SDDataEngine alert:kMessageCycleCountPN title:nil template:kMessageValidationRequiredTemplate delegate:self];
            return;
        }
        
    }
    else{
        //part count
        
        //check if serial no is provided
        if(![target isEqualToString:@""])
        {
            int intQty = [qty intValue];
            if(intQty>1)
            {
                
                [SDDataEngine alert:kMessageReceivingSerialNoRule title:nil template:nil delegate:self];
                qty = [NSNumber numberWithInt:1];
            }
        }
           
    }
    
    //now add it to the cycle count master entity
    //use target to avoid the duplication. Target = if part, serial number, otherwise, 
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.cycleCountMaster.counts];
    BOOL isMatch = NO;
    for(CycleCountCount *count in tempSet)
    {
        
        if(count)
        {
            if ([target isEqualToString:count.target]) {
                isMatch = YES;
                //just update the qty
                count.qty = [qty stringValue];
                count.comment = comment;
                break;
            }
        }
    }
    if(!isMatch)
    {
        //create a new one
        NSManagedObjectContext* managedObjectContext = [self.cycleCountMaster managedObjectContext];
        CycleCountCount* count = [NSEntityDescription insertNewObjectForEntityForName:kEntityCycleCountCount inManagedObjectContext:managedObjectContext];
        count.qty = [qty stringValue];
        count.comment = comment;
        if(![target isEqualToString:@""])
        {
            count.target = target;
        }
        else
        {
            count.target = nil;
        }
        
        count.master = self.cycleCountMaster;
        [tempSet addObject:count];
    }
    
    //put it back and save it
    self.cycleCountMaster.counts = tempSet;
    [[SDDataEngine sharedEngine] save:self.cycleCountMaster];
    //reset fields
    [self resetFields];
    self.lblTotalCounts.text = [self getTotalCounts];
    [[SDDataEngine sharedEngine] save:self.cycleCountMaster];
    [[self cycleCountTableView] reloadData];
    
    //gain focus
    [self.txtFieldTarget becomeFirstResponder];

}

- (void)resetFields
{
    self.txtFieldQty.text=@"1";
    [self.txtFieldQty resignFirstResponder];
    self.txtFieldTarget.text=@"";
    [self.txtFieldTarget resignFirstResponder];
    self.txtFieldComment.text = @"";
    [self.txtFieldComment resignFirstResponder];
}

- (IBAction)btnCalculator:(id)sender {
    self.calculator.modalPresentationStyle = UIModalPresentationFormSheet;
    self.definesPresentationContext=YES;
//    [self presentModalViewController:self.calculator animated:YES];
    [self presentViewController:[self calculator] animated:YES completion:nil];
}

- (IBAction)btnSubmit:(id)sender {
    
    CycleCountController* controller = [SDRestKitEngine sharedCycleCountController];
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:self.activity_submit];
    sleep(3);
    BOOL isOK = [controller post:_cycleCountMaster];
    [self.activity_submit stopAnimating];
    if(!isOK)
    {
        
        if([controller.status isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            //alert
            [SDDataEngine alert:controller.message title:kAlertTitleSystemError template:nil delegate:nil];
        }
        else
        {
            //alert
            [SDDataEngine alert:kMessageDataControllerCallFailed title:kAlertTitleTransactionError template:nil delegate:nil];
        }
    }

    
    //save the InventoryHeader first
    [[SDDataEngine sharedEngine] save:_cycleCountMaster];
    
    //go back
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) threadStartAnimating:(UIActivityIndicatorView*)indicator
{
    [indicator startAnimating];
}


#pragma delegate CycleCountItemDeleteDelegate
-(void)deleteItem:(NSInteger)rowIndex
{
    if(nil!=self.cycleCountMaster&&rowIndex<[self.cycleCountMaster.counts count])
    {
        
        NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.cycleCountMaster.counts];
        //[tempSet delete:[tempSet objectAtIndex:rowIndex]];
        [tempSet removeObject:[tempSet objectAtIndex:rowIndex]];
        self.cycleCountMaster.counts = tempSet;
        
    }
    self.lblTotalCounts.text = [self getTotalCounts];
    [[SDDataEngine sharedEngine] save:self.cycleCountMaster];
    [[self cycleCountTableView] reloadData];
    
}

#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.txtFieldTarget)
    {
        [self.txtFieldQty becomeFirstResponder];
        NSString* target = [self.txtFieldTarget.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(!_isBinCount&&![target isEqualToString:@""])
        {
            self.txtFieldQty.text = @"1";
        }
    }
    else if (textField==self.txtFieldQty)
    {
        [self.txtFieldQty resignFirstResponder];
        
    }
    return YES;
}

@end
