//
//  CycleCountMasterTableViewController.m
//  CustomerServiceMobile
//
//  Created by LTXC on 1/8/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "CycleCountMasterTableViewController.h"
#import "CycleCountMaster.h"
#import "CycleCountMasterController.h"
#import "CycleCountMasterTableCell.h"
#import "CycleCountViewController.h"
#import "SDRestKitEngine.h"
#import "SharedConstants.h"
#import "SDDataEngine.h"
#import "SDUserPreference.h"

@interface CycleCountMasterTableViewController ()
@property (nonatomic) CycleCountMaster* selectedCycleCountMaster;
//@property (strong,nonatomic)NSMutableArray *filteredCycleCountArray;
@property (strong, nonatomic)NSArray* sortDescriptionArray;
-(NSFetchedResultsController *)fetchedResultsController;
-(NSArray*) getSortDescriptions;
-(void)fetchCycleCountMaster;
@end

@implementation CycleCountMasterTableViewController
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize selectedCycleCountMaster=_selectedCycleCountMaster;
@synthesize sortDescriptionArray=_sortDescriptionArray;





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

   
	//self.searchDisplayController.delegate = self;
    [self refreshCycleCountMaster];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _fetchedResultsController = nil;

}


- (IBAction)selectCycleType:(id)sender {
    NSPredicate* predicate = nil;
    NSString* predicateFormat = @"cycle_type == %@";
    switch (self.btnButtons.selectedSegmentIndex) 
    {
        case 0:
            break;
        case 1:
            predicate = [NSPredicate predicateWithFormat:predicateFormat,@"BIN"];
            break;
            
        case 2:
            predicate = [NSPredicate predicateWithFormat:predicateFormat,@"PART"];
            break;
            
        default:break;
    }
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self fetchCycleCountMaster]; //no need to reload data from server
    
}

- (IBAction)btnRefresh:(id)sender {
         [self refreshCycleCountMaster];
}


- (void)refreshCycleCountMaster
{
    //first connect to the server
    CycleCountMasterController* cycleCountMasterController = [SDRestKitEngine sharedCycleCountMasterController];
    [cycleCountMasterController load];
    [self fetchCycleCountMaster];
}

-(void)fetchCycleCountMaster
{
    //then do a database fetch
    NSError* error;
    if(![[self fetchedResultsController] performFetch:&error ])
    {
        NSLog(@"Unexpected Error when fetch Receiving(CycleCountMaster) Transaction List.Unresolved Error %@ ; User Info:%@",error,[error userInfo]);
        exit(-1);
    }
    
    [[self tableView] reloadData];

}

-(NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController!=nil)
        return _fetchedResultsController;
    
    //create one
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityCycleCountMaster inManagedObjectContext:[SDDataEngine sharedEngine].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray* sortedArray = [self getSortDescriptions];

    [fetchRequest setSortDescriptors:sortedArray];
    
    [fetchRequest setFetchBatchSize:[[SDUserPreference sharedUserPreference] MaxRows]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[SDDataEngine sharedEngine] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}


-(NSArray*) getSortDescriptions
{
    if(nil!=_sortDescriptionArray)
    {
    
        return _sortDescriptionArray;
    }
    
//    NSSortDescriptor *sortAssignedDate = [[NSSortDescriptor alloc]initWithKey:@"assigneddate" ascending:YES];
    
    NSSortDescriptor *sortBinCodeID = [[NSSortDescriptor alloc]initWithKey:@"bin_code_id" ascending:YES];
    
    _sortDescriptionArray = @[sortBinCodeID];
    return _sortDescriptionArray;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSString* identifier = [segue identifier];

    
    
    if(([identifier isEqualToString:@"ShowBinSegue"])||([identifier isEqualToString:@"ShowPartSegue"]))
    {
        CycleCountViewController* controller = (CycleCountViewController*)[segue destinationViewController];
        controller.cycleCountMaster = self.selectedCycleCountMaster;
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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath tableView:self.tableView];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return [[_fetchedResultsController sections] count];
 
}

#pragma mark - UITableViewDataSource,UITableViewDelegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    CycleCountMaster *t = nil;
    
    CycleCountMasterTableCell* listcell = (CycleCountMasterTableCell*)cell;
    
    t = (CycleCountMaster*)[_fetchedResultsController objectAtIndexPath:indexPath];
    listcell.lblCycleCountType.text = [NSString stringWithFormat:@"%@ Count",t.cycle_type];
    listcell.lblBinCode.text = t.bin_code_id;
    listcell.lblBPart.text = t.bpart_id;
    listcell.lblProcessStatus.text = t.process_status;
    listcell.lblProcessMessage.text = t.process_message;
    listcell.lblAssignedDate.text = [[SDUserPreference sharedUserPreference].dateFormatter stringFromDate:t.assigneddate];
}



-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDetail:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

-(void)showDetail:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    CycleCountMaster* obj = nil;

    obj = (CycleCountMaster*)[_fetchedResultsController objectAtIndexPath:indexPath];
   
    self.selectedCycleCountMaster = obj;

    if([self.selectedCycleCountMaster.cycle_type isEqualToString:kCycleCountTypeBin])
    {
        [self performSegueWithIdentifier:@"ShowBinSegue" sender:self];
    }
    else if([self.selectedCycleCountMaster.cycle_type isEqualToString:kCycleCountTypePart])
    {
        [self performSegueWithIdentifier:@"ShowPartSegue" sender:self];
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetail:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}


#pragma mark - UISearchDisplayController Delegate Methods

@end
