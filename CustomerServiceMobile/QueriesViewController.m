
#import "QueriesViewController.h"
#import "SDUserPreference.h"
#import "SharedConstants.h"
#import "QueryViewController.h"
#import "MyRestkit.h"
#import "Queries.h"

@interface QueriesViewController ()

@end

@implementation QueriesViewController
//@synthesize queries=_queries;
@synthesize fetchedResultsController=_fetchedResultsController;


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

//load url from file
//    if(nil==_queries)
//    {
//        NSError* err = nil;
//        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Queries" ofType:@"json"];
//        _queries = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
//        NSLog(@"Imported Queries:%@", _queries);
//        if(err)
//            NSLog(@"Error:%@", [err description]);
//    }
    
    [self fetchResults];
    
}



-(void)fetchResults
{
    //load url from coredata
    NSError* error;
    if(![[self fetchedResultsController] performFetch:&error ])
    {
        NSLog(@"Unexpected Error when fetch Queries(Reports) List.Unresolved Error %@ ; User Info:%@",error,[error userInfo]);
        exit(-1);
    }
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController!=nil)
        return _fetchedResultsController;
    
    //create one
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityQueries inManagedObjectContext:[SDDataEngine sharedEngine].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortTag = [[NSSortDescriptor alloc]initWithKey:@"tag" ascending:YES];
    
    NSSortDescriptor *sortQueryName = [[NSSortDescriptor alloc]initWithKey:@"queryname" ascending:YES];
    
    NSArray *sortedArray = @[sortTag,sortQueryName];
    [fetchRequest setSortDescriptors:sortedArray];
    
    [fetchRequest setFetchBatchSize:[[SDUserPreference sharedUserPreference] MaxRows]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[SDDataEngine sharedEngine] managedObjectContext] sectionNameKeyPath:nil cacheName:@"Queries"];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (IBAction)btnRefresh:(id)sender {
    [self fetchResults];
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
    static NSString *CellIdentifier = @"QueryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    //s[super beautifyCell:cell atIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary* objDict = [_queries objectAtIndex:indexPath.row];
    //    if(nil!=objDict)
    //    {
    //        cell.textLabel.text = [objDict objectForKey:@"queryname"];
    //        cell.detailTextLabel.text = [objDict objectForKey:@"descr"];
    //    }
    
    Queries *t = (Queries*)[_fetchedResultsController objectAtIndexPath:indexPath];
    
    
    if(nil!=t)
    {
        cell.textLabel.text = t.queryname;
        cell.detailTextLabel.text = t.descr;
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate



-(NSString *)prepareWebViewURL:(NSIndexPath*)indexPath
{
    NSString* webviewurl  = nil;
//    NSDictionary* objDict = [_queries objectAtIndex:indexPath.row];
//    if(nil!=objDict)
//    {
//        NSString* url = [objDict objectForKey:@"url"];
//        NSString* username = [SDUserPreference sharedUserPreference].LastLogin;
//        NSString* password = [SDUserPreference sharedUserPreference].LastLoginPassword;
//        NSString* reportserver = [SDUserPreference sharedUserPreference].ReportServer;
//        webviewurl = [NSString stringWithFormat:kWebViewJasperReportTemplate,reportserver,url,[self urlEncode:username],[self urlEncode:password]];
//        NSLog(@"URL:%@", webviewurl);        
//    }
    
    Queries *t = (Queries*)[_fetchedResultsController objectAtIndexPath:indexPath];

    if(nil!=t)
    {
        NSString* url = t.url;
        NSString* username = [SDUserPreference sharedUserPreference].LastLogin;
        NSString* password = [SDUserPreference sharedUserPreference].LastLoginPassword;
        NSString* reportserver = [SDUserPreference sharedUserPreference].ReportServer;
        webviewurl = [NSString stringWithFormat:kWebViewJasperReportTemplate,reportserver,url,[self urlEncode:username],[self urlEncode:password]];
        NSLog(@"URL:%@", webviewurl);
    }

    return webviewurl;
}

-(NSString*) urlEncode:(NSString*) unEscaptedString
{
    CFStringRef valueCF = (__bridge CFStringRef)unEscaptedString;
    NSString * escapedUrlString = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(
                                                        NULL,
                                                        valueCF,
                                                        NULL,
                                                        (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                        kCFStringEncodingUTF8 );
    return escapedUrlString;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowQuerySegue"])
    {
        NSIndexPath* selecteRowIndex = [self.tableView indexPathForSelectedRow];
        NSString* webviewurl = [self prepareWebViewURL:selecteRowIndex];
        QueryViewController* queryView = (QueryViewController*)segue.destinationViewController;
        queryView.webviewURL = webviewurl;
    }
}




@end
