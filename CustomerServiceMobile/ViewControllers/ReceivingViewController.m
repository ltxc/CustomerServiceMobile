//
//  ReceivingViewController.m
//  CustomerServiceMobile
//
//  Created by LTXC on 12/4/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "ReceivingViewController.h"
#import "AutoCompleteDataHelper.h"
#import "SharedConstants.h"
#import "AutoCompleteController.h"
#import "SDUserPreference.h"
#import "SDRestKitEngine.h"
#import "SDDataEngine.h"
#import "Company.h"
#import "Warehouse.h"
#import "Carrier.h"
#import "InventoryLineItem.h"
#import "RPInformationViewController.h"

@interface ReceivingViewController ()
-(void) threadStartAnimating:(UIActivityIndicatorView*)indicator;
-(void) hideKeyBoard;
@property(nonatomic,strong) InventoryLineItem* editLineItem;
@end

@implementation ReceivingViewController
@synthesize inventoryHeader=_inventoryHeader;
@synthesize editLineItem=_editLineItem;
RPInformation* _rpInformation;
UIPopoverController* _myPopoverController;
BOOL _isDelete;
BOOL _isMISC;

+(NSString *)receivingTypeDescription:(NSString *)transactionType  title:(BOOL)isTitle
{
    NSString* description = kReceivingMiscellaneous;
    if([transactionType isEqualToString:kTransactionTypeDRC])
        description = kReceivingShipList;
    else if([transactionType isEqualToString:kTransactionTypeRRFV])
        description = kReceivingVendorRepair;
    else if([transactionType isEqualToString:kTransactionTypeRFR])
        description = kReceivingRepairOrder;
    if(isTitle)
        description = [NSString stringWithFormat:kReceivingDescriptionTemplate, description];
    return description;
}

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
    
    self.navigationItem.title = [ReceivingViewController receivingTypeDescription:self.transactionType title:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    _isDelete = NO;
    if(self.isNew)
    {
        //create one
        NSManagedObjectContext* managedObjectContext = [[SDDataEngine sharedEngine] managedObjectContext];
        InventoryHeader* newInventoryHeader = [NSEntityDescription insertNewObjectForEntityForName:kEntityInventoryHeader inManagedObjectContext:managedObjectContext];
        newInventoryHeader.transaction_type = self.transactionType;
        newInventoryHeader.created_by = [SDRestKitEngine sharedEngine].username;
        newInventoryHeader.created_date = [NSDate date];
        newInventoryHeader.process_date = [NSDate date];
        newInventoryHeader.process_status = kProcessStatusNew;
        newInventoryHeader.no_of_packages = @"0";
        newInventoryHeader.weight = [NSNumber numberWithInt:0];
        newInventoryHeader.printer=[SDUserPreference sharedUserPreference].Printer;
        _inventoryHeader = newInventoryHeader;
        _isDelete = YES;
        //set ipad_id
        [[SDDataEngine sharedEngine]save:_inventoryHeader];
        //    int pk = [SDDataEngine getPK:_inventoryHeader];
        //    NSString* deviceName = [[UIDevice currentDevice] name];
        //    _inventoryHeader.ipad_id = [NSString stringWithFormat:@"%@RV%d",deviceName,pk];

        //_inventoryHeader.ipad_id = [SDDataEngine ipadid:self.transactionType primaryKey:[[SDDataEngine sharedEngine] getPKString:_inventoryHeader]  addRandomNumber:YES];
        //[[SDDataEngine sharedEngine]save:_inventoryHeader];
    }
    else{
        if([self.inventoryHeader.process_status isEqualToString:kProcessStatusCOMPLETED])
        {
            self.btnSubmit.hidden = YES;
            self.btnAdd.hidden = YES;
        }
        //populate the gui
        self.lblToWarehouse.text = _inventoryHeader.to_warehouse_id;
        self.lblCarrier.text = _inventoryHeader.carrier_id;
        self.lblCarrierRefNo.text = _inventoryHeader.carrier_refno;
        self.lblFromCompany.text = _inventoryHeader.company_id;
        self.lblVendorRefNo.text = _inventoryHeader.vender_refno;

        if (![self.transactionType isEqualToString:kTransactionTypeMRC])
        {
            self.txtOurRefNo.text = _inventoryHeader.our_refno;
        }
        
        self.lblProcessStatus.text = _inventoryHeader.process_status;
        self.lblProcessMessage.text = _inventoryHeader.process_message;
        
    }
    
    if ([self.transactionType isEqualToString:kTransactionTypeMRC])
    {

        _isMISC = YES;
    }
    else
        _isMISC = NO;
    
    self.txtDocumentType.text = [ReceivingViewController receivingTypeDescription:self.transactionType title:NO];
    self.editLineItem = nil;
    
    self.lineItemsTableView.inventoryHeader = self.inventoryHeader;
    self.lineItemsTableView.delegate = self.lineItemsTableView;
    self.lineItemsTableView.dataSource = self.lineItemsTableView;
    
    self.lblToWarehouse.text = [[SDUserPreference sharedUserPreference]DefaultWarehouseID];
    self.lineItemsTableView.deleteDelegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_isDelete||[self.inventoryHeader.inventoryLineItems count]<=0)
    {
        [[SDDataEngine sharedEngine]delete:_inventoryHeader];
    }
    else
    {
        [self saveInput];
    }
}

-(void)threadStartAnimating:(UIActivityIndicatorView *)indicator
{
    [indicator startAnimating];
}

-(ProcessResult*)postInventoryTransaction:(InventoryHeader*) inventoryTransaction
{
    ProcessResult* processResult = nil;
    
    return processResult;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRPInformatioinSegue"]) {
        RPInformationViewController* rpInformationViewController = (RPInformationViewController*)[segue destinationViewController];
        rpInformationViewController.rpInformation = _rpInformation;
    }
    else
    {
        
        ProductViewController* productController = (ProductViewController*)[segue destinationViewController];
        productController.delegate = self;
        
        productController.isMISC = _isMISC;
        if(nil!=_editLineItem)
        {
            productController.isNew = NO;
            productController.lineItem = _editLineItem;
        }
        else
            productController.isNew = YES;
        
        
        _myPopoverController = [(UIStoryboardPopoverSegue*)segue popoverController];
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowRPInformatioinSegue"])
    {
        if(_rpInformation==nil)
            return NO;
    }
    return YES;
}




#pragma mark - Event Handling

- (IBAction)btnToWarehouse:(id)sender {

    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityWarehouse
        withDisplayBlock:^(id object){
            Warehouse* warehouse = (Warehouse*)object;
            NSString* display = [NSString stringWithFormat:@"%@", [warehouse warehouse_id]];

            return display;
        }
        withBlock:    ^(BOOL status,id result){
            if(status==YES)
              self.lblToWarehouse.text = [(Warehouse*)result warehouse_id];
            else
              self.lblToWarehouse.text = @"";
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    ];
    [helper addSortDescript:kSortAttributeWarehouse ascending:YES];
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    AutoCompleteController* pickViewController = [[AutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    pickViewController.defaultValue = [[SDUserPreference sharedUserPreference]DefaultWarehouseID];
    pickViewController.autoCompleteTitle = @"Please select a warehouse";
    [self presentViewController:pickViewController animated:YES completion:nil];
    
}

- (IBAction)btnFromCompany:(id)sender {
    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityCompany
        withDisplayBlock:^(id object){
            Company* company = (Company*)object;
            NSString* display = [NSString stringWithFormat:@"%@", [company company_id]];
            return display;
        }
        withBlock:    ^(BOOL status, id result){
            if(status==YES)
               self.lblFromCompany.text = [(Company*)result company_id];
            else
               self.lblFromCompany.text = @"";
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    ];
    [helper addSortDescript:kSortAttributeCompany ascending:YES];
 // self.modalPresentationStyle = UIModalPresentationFormSheet;
    AutoCompleteController* pickViewController = [[AutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    pickViewController.autoCompleteTitle = @"Please select a company";
    [self presentViewController:pickViewController animated:YES completion:nil];

}

- (IBAction)btnCarrier:(id)sender {
    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityCarrier
        withDisplayBlock:^(id object){
            Carrier* carrier = (Carrier*)object;
            NSString* display = [NSString stringWithFormat:@"%@", [carrier carrier_id]];
            return display;
        }                                                                      withBlock:    ^(BOOL status, id result)
                                      {
                                          if(status==YES)
                                              self.lblCarrier.text = [(Carrier*)result carrier_id];
                                          else
                                              self.lblCarrier.text = @"";
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      }
                                      ];
    [helper addSortDescript:kSortAttributeCarrier ascending:YES];
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    AutoCompleteController* pickViewController = [[AutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    pickViewController.autoCompleteTitle = @"Please select a carrier";
    [self presentViewController:pickViewController animated:YES completion:nil];
    
}

- (IBAction)btnAdd:(id)sender {
    _editLineItem=nil;
    if(_isMISC)
        [self performSegueWithIdentifier:@"ShowProductMRCSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"ShowProductSegue" sender:self];

    
}

-(void) hideKeyBoard
{
    [self.txtDocumentType resignFirstResponder];
    [self.txtOurRefNo resignFirstResponder];
    [self.lblCarrier resignFirstResponder];
    [self.lblCarrierRefNo resignFirstResponder];
    [self.lblFromCompany resignFirstResponder];
    [self.lblProcessMessage resignFirstResponder];
    [self.lblProcessStatus resignFirstResponder];
    [self.lblToWarehouse resignFirstResponder];
    [self.lblVendorRefNo resignFirstResponder];
}

- (IBAction)btnSubmit:(id)sender {
    
    [self saveInput];
    if(![self validateInput])
        return;
    //NSLog(@"Object id before saving: %@",[[_inventoryHeader objectID] description]);
    _isDelete = NO;
    //save the InventoryHeader first
      

    
    //post it to the server. later on, this will be handled in the background
    InventoryTransactionController* transactionController = nil;
    if([self.transactionType isEqualToString:kTransactionTypeMRC])
     transactionController = [SDRestKitEngine sharedMISCInventoryTransactionController];
    else
     transactionController = [SDRestKitEngine sharedInventoryTransactionController];
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:self.activity_submit];
    sleep(5);
    
   BOOL isOK = [transactionController post:_inventoryHeader];
    [self.activity_submit stopAnimating];
    if(!isOK)
    {
        
        if([transactionController.status isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            //alert
            [SDDataEngine alert:transactionController.message title:kAlertTitleSystemError template:nil delegate:nil];
        }
        else
        {
            //alert
            [SDDataEngine alert:kMessageDataControllerCallFailed title:kAlertTitleTransactionError template:nil delegate:nil];
        }
    }
    
    //save the InventoryHeader first
    [[SDDataEngine sharedEngine] save:_inventoryHeader];
    
    //go back
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)btnOurRefNo:(id)sender {
    NSString* request_id = [[SDUserPreference trim:self.txtOurRefNo.text] uppercaseString];
    [self.txtOurRefNo resignFirstResponder];
    if(request_id==nil)
        return;
    
    //query the repair information view
    //post it to the server. later on, this will be handled in the background
    RPInformationController* transactionController = [SDRestKitEngine sharedRPInformationController];
    
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:self.activity_rpinformation];
    sleep(1);
    RPInformation* rpInformation = [transactionController query:request_id];
    [self.activity_rpinformation stopAnimating];
    if(nil==rpInformation)
    {
        
        if([transactionController.status isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            //alert
            [SDDataEngine alert:transactionController.message title:kAlertTitleSystemError template:nil delegate:nil];
        }
        else
        {
            //alert
            [SDDataEngine alert:kMessageRPInformation title:kAlertTitleTransactionError template:nil delegate:nil];
        }
    }
    
    
    
}


#pragma mark - GUI Data Binding and Validation
-(BOOL)validateInput
{
    //validation code
    if([_inventoryHeader.inventoryLineItems count]<=0)
    {
        [SDDataEngine alert:kMessageReceivingNoLineItem title:nil template:nil delegate:self];
        return NO;
        
    }
    
    if(_inventoryHeader.to_warehouse_id==nil||[_inventoryHeader.to_warehouse_id isEqualToString:@""])
    {
        [SDDataEngine alert:@"To Warehouse" title:nil template:kMessageValidationRequiredTemplate  delegate:self];
        return NO;
    }
        
    if(_inventoryHeader.carrier_id==nil||[_inventoryHeader.carrier_id isEqualToString:@""])
    {
        [SDDataEngine alert:@"Carrier" title:nil template:kMessageValidationRequiredTemplate  delegate:self];
        return NO;
    }
        
    if(_inventoryHeader.carrier_refno==nil||[_inventoryHeader.carrier_refno isEqualToString:@""])
    {
        [SDDataEngine alert:@"Carrier Ref No." title:nil template:kMessageValidationRequiredTemplate  delegate:self];
        return NO;
    }
    
 
    if ([self.transactionType isEqualToString:kTransactionTypeMRC])
    {

        if(_inventoryHeader.company_id==nil||[_inventoryHeader.company_id isEqualToString:@""])
        {
            [SDDataEngine alert:@"From Company" title:nil template:kMessageValidationRequiredTemplate delegate:self];
        return NO;
        }
                
    }
    else
    {

        if(_inventoryHeader.our_refno==nil||[_inventoryHeader.our_refno isEqualToString:@""])
        {
            [SDDataEngine alert:@"Our Ref NO." title:nil template:kMessageValidationRequiredTemplate delegate:self];
        return NO;
        }
        
    }

    return YES;

}

-(void)saveInput
{

    NSString* toWarehouse = [SDUserPreference trim:self.lblToWarehouse.text];
     _inventoryHeader.to_warehouse_id = toWarehouse;
    
    NSString* carrier_id = [SDUserPreference trim:self.lblCarrier.text];
    _inventoryHeader.carrier_id = carrier_id;
    
    NSString* carrier_refno = [SDUserPreference trim:self.lblCarrierRefNo.text];
    _inventoryHeader.carrier_refno = carrier_refno;
    
    NSString* sender_refno = [SDUserPreference trim:self.lblVendorRefNo.text];
    _inventoryHeader.sender_refno = sender_refno;
    
    NSString* vendor_refno =  [SDUserPreference trim:self.lblVendorRefNo.text];
    _inventoryHeader.vender_refno = vendor_refno;
    
    if ([self.transactionType isEqualToString:kTransactionTypeMRC])
    {
        
        
        NSString* company = [SDUserPreference trim:self.lblFromCompany.text];
        _inventoryHeader.company_id = company;
        
    }
    else
    {
        NSString* ourRefNo = [[SDUserPreference trim:self.txtOurRefNo.text] uppercaseString];
        _inventoryHeader.our_refno = ourRefNo;
    }
    if(_inventoryHeader.ipad_id == nil)
    {
        _inventoryHeader.ipad_id = [SDDataEngine ipadid:self.transactionType primaryKey:[[SDDataEngine sharedEngine] getPKString:_inventoryHeader]  addRandomNumber:YES];
    }
    [[SDDataEngine sharedEngine] save:_inventoryHeader];  

}



#pragma ProductDelegate

-(void)addLineItem: (InventoryLineItem*) lineItem status:(BOOL)status  isnew:(BOOL)isnew
{
    if(nil!=lineItem)
    {
        if(status==YES)
        {
            [self addInventoryLineItem:lineItem];
        
        }
        else
        {
            if(isnew)
                [[SDDataEngine sharedEngine] delete:lineItem];
        }
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [_myPopoverController dismissPopoverAnimated:YES];
    _myPopoverController=nil;
    [[self lineItemsTableView] reloadData];
}

-(void) addInventoryLineItem:(InventoryLineItem*) lineItem
{
    if(nil!=lineItem&&nil!=self.inventoryHeader)
    {
        
        NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.inventoryHeader.inventoryLineItems];
        lineItem.lineitemnumber = [NSString  stringWithFormat:@"%d",[tempSet count]+1];
        [tempSet addObject:lineItem];
        
        self.inventoryHeader.inventoryLineItems = tempSet;
        [self.inventoryHeader didChangeValueForKey:@"inventoryLineItems"];
        _isDelete = NO;
    }
}
-(void)editLineItem:(InventoryLineItem *)lineItem status:(BOOL)status
{
    if(nil!=lineItem)
    {
        if(status==YES&&![_inventoryHeader.process_status isEqualToString:kProcessStatusCOMPLETED])
        {
            //save it
            [[SDDataEngine sharedEngine]save:_inventoryHeader];
        }
        
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [_myPopoverController dismissPopoverAnimated:YES];
    _myPopoverController=nil;
    [[self lineItemsTableView] reloadData];
}

#pragma DeleteLineItemDelegate

-(void) deleteLineItem:(NSInteger)rowIndex
{
    if(nil!=self.inventoryHeader&&![kProcessStatusCOMPLETED isEqualToString:self.inventoryHeader.process_status]&&rowIndex<[self.inventoryHeader.inventoryLineItems count])
    {
        
        NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.inventoryHeader.inventoryLineItems];
        //[tempSet delete:[tempSet objectAtIndex:rowIndex]];
        [tempSet removeObject:[tempSet objectAtIndex:rowIndex]];
        self.inventoryHeader.inventoryLineItems = tempSet;
        [self.inventoryHeader didChangeValueForKey:@"inventoryLineItems"];
    }
    [[self lineItemsTableView] reloadData];
}

-(void)editLineItem:(InventoryLineItem *)lineItem
{
    if(nil!=lineItem)
    {
        _editLineItem = lineItem;
        if(_isMISC)
            [self performSegueWithIdentifier:@"ShowProductMRCSegue" sender:self];
        else
            [self performSegueWithIdentifier:@"ShowProductSegue" sender:self];
    }
}

@end
