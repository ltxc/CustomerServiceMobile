//
//  ReceivingRootViewController.m
//  CustomerServiceMobile


#import "ReceivingRootViewController.h"
#import "ReceivingViewController.h"
#import "SharedConstants.h"
#import "SDDataEngine.h"
#import "SDUserPreference.h"
#import "ReceivingListTableViewCell.h"
#import "InventoryHeader.h"
#import <QuartzCore/QuartzCore.h>

@interface ReceivingRootViewController ()
@property (nonatomic,retain) InventoryHeader* selectedInventoryHeader;
@property (nonatomic) BOOL isNew;

-(void)showDetail:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ReceivingRootViewController
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize selectedInventoryHeader=_selectedInventoryHeader;
@synthesize isNew=_isNew;
//NSDateFormatter *_dateFormatter;
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    _dateFormatter = [[NSDateFormatter alloc] init];
//	[_dateFormatter setDateFormat:@"MM/dd/yy HH:mm"];
	
    self.viewButtons.clipsToBounds = NO;
    [SDUserPreference addShadow:self.viewButtons.layer];
    
    self.tableView.layer.cornerRadius = 5.0;
    
    NSError* error;
    if(![[self fetchedResultsController] performFetch:&error ])
    {
        NSLog(@"Unexpected Error when fetch Receiving(Inventory) Transaction List.Unresolved Error %@ ; User Info:%@",error,[error userInfo]);
        exit(-1);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
//if scroll, the table view bounce will not work as it shares the same event
//    if(!(self.interfaceOrientation == UIInterfaceOrientationPortrait||self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
//    {
//        UIScrollView *tempScrollView = (UIScrollView*)self.view;
//        tempScrollView.contentSize = CGSizeMake(1004,768);
//    }
    
    self.isNew=YES;
    self.selectedInventoryHeader=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _fetchedResultsController = nil;
    //_dateFormatter=nil;
}



-(NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController!=nil)
        return _fetchedResultsController;
    
    //create one
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityInventoryHeader inManagedObjectContext:[SDDataEngine sharedEngine].managedObjectContext];
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
    ReceivingViewController* controller = (ReceivingViewController*)[segue destinationViewController];
    controller.isNew=self.isNew;
    controller.inventoryHeader = self.selectedInventoryHeader;
    if([identifier isEqualToString:@"ShowMRCSegue"])
    {
        //miscellaneous
        controller.transactionType = kTransactionTypeMRC;
    }
    else if([identifier isEqualToString:@"ShowDRCSegue"])
    {
        //ship list
        controller.transactionType = kTransactionTypeDRC;
    }
    else if([identifier isEqualToString:@"ShowRRFVSegue"])
    {
        //vendor repair
        controller.transactionType = kTransactionTypeRRFV;
    }
    else if([identifier isEqualToString:@"ShowRFRSegue"])
    {
        //repair order
        controller.transactionType = kTransactionTypeRFR;
    }    

}

#pragma NSFetchResultControllerDelegate
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
    static NSString *CellIdentifier = @"ReceivingTransaction";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    InventoryHeader *t = (InventoryHeader*)[_fetchedResultsController objectAtIndexPath:indexPath];
    ReceivingListTableViewCell* listcell = (ReceivingListTableViewCell*)cell;
    listcell.lblID.text = [NSString stringWithFormat:@"%@",[[SDDataEngine sharedEngine] getPKString:t]];
    listcell.lblTransactionType.text = [ReceivingViewController receivingTypeDescription:t.transaction_type title:NO];
    listcell.lblWarehouse.text = t.to_warehouse_id;
    listcell.lblLines.text = [NSString stringWithFormat:@"%d",[t.inventoryLineItems count]];
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
    InventoryHeader* inv = (InventoryHeader*)[_fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedInventoryHeader = inv;
    self.isNew = NO;
    if([self.selectedInventoryHeader.transaction_type isEqualToString:kTransactionTypeDRC])
    {
        [self performSegueWithIdentifier:@"ShowDRCSegue" sender:self];
    }
    else if([self.selectedInventoryHeader.transaction_type isEqualToString:kTransactionTypeRRFV])
    {
        [self performSegueWithIdentifier:@"ShowRRFVSegue" sender:self];
    }
    else if([self.selectedInventoryHeader.transaction_type isEqualToString:kTransactionTypeRFR])
    {
        [self performSegueWithIdentifier:@"ShowRFRSegue" sender:self];
    }
    else if([self.selectedInventoryHeader.transaction_type isEqualToString:kTransactionTypeMRC])
    {
        [self performSegueWithIdentifier:@"ShowMRCSegue" sender:self];
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
        InventoryHeader* inv = (InventoryHeader*)[_fetchedResultsController objectAtIndexPath:indexPath];
        [[SDDataEngine sharedEngine] delete:inv];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
[self showDetail:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (IBAction)btnRemoveHistoryData:(id)sender {
    NSString* message = [NSString stringWithFormat:kMessageClearTableConfirmation, @"Receiving"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTitleClearTable message:message delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (buttonIndex == 0) {
        
        [[SDDataEngine sharedEngine] truncateTable:kEntityInventoryHeader];
        
    }
    
}
@end
