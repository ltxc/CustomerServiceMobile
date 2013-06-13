

#import "ShippingRootViewController.h"
#import "MyRestkit.h"
#import "ShippingHeader.h"
#import "ShippingViewController.h"
#import "ShippingRootViewTableViewCell.h"
#import "ShippingLineItem.h"

@interface ShippingRootViewController ()
@property (nonatomic,retain) ShippingHeader* selectedShippingTransaction;
@property (nonatomic) BOOL isNew;
@end

@implementation ShippingRootViewController
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize isNew=_isNew;
@synthesize selectedShippingTransaction=_selectedShippingTransaction;


//NSDateFormatter *_dateFormatter;

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
    self.viewButtons.clipsToBounds = NO;
    [SDUserPreference addShadow:self.tableView.layer];
    [SDUserPreference addShadow:self.viewButtons.layer];
    
    NSError* error;
    if(![[self fetchedResultsController] performFetch:&error ])
    {
        NSLog(@"Unexpected Error when fetch Receiving(Inventory) Transaction List.Unresolved Error %@ ; User Info:%@",error,[error userInfo]);
        exit(-1);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    //it reset the status to guarantee that the button click will result new pick/ship
    self.isNew=YES;
    self.selectedShippingTransaction=nil;
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController!=nil)
        return _fetchedResultsController;
    
    //create one
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityShippingHeader inManagedObjectContext:[SDDataEngine sharedEngine].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortProcessDate = [[NSSortDescriptor alloc]initWithKey:@"process_date" ascending:NO];
    
    NSSortDescriptor *sortCreatedDate = [[NSSortDescriptor alloc]initWithKey:@"created_date" ascending:NO];
    
    NSArray *sortedArray = @[sortProcessDate,sortCreatedDate];
    [fetchRequest setSortDescriptors:sortedArray];
    
    [fetchRequest setFetchBatchSize:[[SDUserPreference sharedUserPreference] MaxRows]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[SDDataEngine sharedEngine] managedObjectContext] sectionNameKeyPath:nil cacheName:@"RootReceiving"];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSString* identifier = [segue identifier];
    ShippingViewController* controller = (ShippingViewController*)[segue destinationViewController];
    controller.isNew=self.isNew;
    controller.shippingHeader = self.selectedShippingTransaction;
    if([identifier isEqualToString:@"ShowPickSegue"])
    {
        //allocated to picked
        controller.type = PICK;
    }
    else if([identifier isEqualToString:@"ShowPickListSegue"])
    {
        //allocated to picklistopen
        controller.type = PICKLIST;
    }
    else if([identifier isEqualToString:@"ShowAllocatedShipListSegue"])
    {
        //allocated to shiplistopen
        controller.type = ALLOCATEDSHIPLIST;
    }
    else if([identifier isEqualToString:@"ShowShipSegue"])
    {
        //picked to shipped
        controller.type = SHIP;
    }
    else if([identifier isEqualToString:@"ShowShipListSegue"])
    {
        //picked to shiplistopen
        controller.type = SHIPLIST;
    }
    
}

#pragma mark -  NSFetchResultControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView* tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
    }
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections] count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"shippingHeaderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ShippingHeader *t = (ShippingHeader*)[_fetchedResultsController objectAtIndexPath:indexPath];
    ShippingRootViewTableViewCell* listcell = (ShippingRootViewTableViewCell*)cell;
    listcell.lblID.text = [NSString stringWithFormat:@"%@",[[SDDataEngine sharedEngine]getPKString:t]];
    listcell.lblType.text = t.transaction_type;
   
    if(t.to_company_id!=nil&&![t.to_company_id isEqualToString:@""])
        listcell.lblTo.text = t.to_company_id;
    else
        listcell.lblTo.text = t.to_warehouse_id;

    listcell.lblTotal.text = [NSString stringWithFormat:@"%d",[t.shippingLineItems count]];
    listcell.lblStatus.text = t.process_status;
    listcell.lblProcessMessage.text = t.process_message;
    listcell.lblProcessDate.text = [[SDUserPreference sharedUserPreference].dateFormatter stringFromDate:t.process_date];
}



-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDetail:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

-(void)showDetail:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ShippingHeader* selected = (ShippingHeader*)[_fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedShippingTransaction = selected;
    self.isNew = NO;
    if([self.selectedShippingTransaction.transaction_type isEqualToString:FormatShippingTypeName[PICK]])
    {
        [self performSegueWithIdentifier:@"ShowPickSegue" sender:self];
    }
    else if([self.selectedShippingTransaction.transaction_type isEqualToString:FormatShippingTypeName[PICKLIST]])
    {
        [self performSegueWithIdentifier:@"ShowPickListSegue" sender:self];
    }
    else  if([self.selectedShippingTransaction.transaction_type isEqualToString:FormatShippingTypeName[ALLOCATEDSHIPLIST]])
    {
        [self performSegueWithIdentifier:@"ShowAllocatedShipListSegue" sender:self];
    }
    else if([self.selectedShippingTransaction.transaction_type isEqualToString:FormatShippingTypeName[SHIP]])
    {
        [self performSegueWithIdentifier:@"ShowShipSegue" sender:self];
    }
    else if([self.selectedShippingTransaction.transaction_type isEqualToString:FormatShippingTypeName[SHIPLIST]])
    {
        [self performSegueWithIdentifier:@"ShowShipListSegue" sender:self];
    }
    
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        ShippingHeader* shp = (ShippingHeader*)[_fetchedResultsController objectAtIndexPath:indexPath];
        //release all the items hold if the status is not complete
        if(![shp.process_status isEqualToString:kProcessStatusCOMPLETED])
        {
            for (ShippingLineItem* lineItem in shp.shippingLineItems) {
                //remove it from the shipping list by set the shipping_ipad_id to nil
                NSArray* shippinglists = [[SDDataEngine sharedEngine]data:kEntityShippingList predicateTemplate:kFetchTemplateServerID predicateValue:lineItem.server_id descriptors:nil];
                
                if ([shippinglists count]>0) {
                    ShippingList* shippingList = [shippinglists objectAtIndex:0];
                    if (nil!=shippingList) {
                        shippingList.shipping_ipad_id = nil;
                        [[SDDataEngine sharedEngine]save:shippingList];
                    }
                }

            }
            
        }
        [[SDDataEngine sharedEngine] delete:shp];
        //[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetail:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}


- (IBAction)synchShippingList:(id)sender {
    ShippingListSynchController* controller = [SDRestKitEngine sharedShippingListController];
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:self.activity_synch];
    sleep(5);
    NSUInteger total = [controller load];
    [self.activity_synch stopAnimating];
    if(total==-1)
    {
        //alert
        [SDDataEngine alert:kMessageDataSynchControllerCallFailed title:@"Failed" template:nil delegate:nil];
    }
    else
    {
    
        [SDDataEngine alert:[NSString stringWithFormat:@"%d",total] title:@"Synch Finished" template:kMessageDataSynchControllerCallOK delegate:nil];
    }
}

-(void) threadStartAnimating:(UIActivityIndicatorView*)indicator
{
    [indicator startAnimating];
}

- (IBAction)btnRemoveHistoryData:(id)sender {
    NSString* message = [NSString stringWithFormat:kMessageClearTableConfirmation, @"Shipping"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTitleClearTable message:message delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (buttonIndex == 0) {
        [[SDDataEngine sharedEngine] truncateTable:kEntityShippingList];
        [[SDDataEngine sharedEngine] truncateTable:kEntityShippingHeader];
        
    }
    
}

@end
