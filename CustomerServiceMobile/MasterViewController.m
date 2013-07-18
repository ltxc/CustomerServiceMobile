//
//  MasterViewController.m
//  CustomerServiceMobile
//
//  Created by LTXC on 10/17/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "MasterViewController.h"
#import "HomeViewController.h"
#import "SharedConstants.h"
#import "DetailViewNavigationController.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController
@synthesize popoverController, splitViewController, rootPopoverButtonItem;

NSMutableArray *menuTransactions;
NSMutableArray *menuUtilities;
NSMutableDictionary *detailViewControllers;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
//    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    
    //Create menu items
    menuTransactions = [[NSMutableArray alloc] init];
    [menuTransactions addObject:kMenuReceiving];
    [menuTransactions addObject:kMenuShipping];
    //[menuTransactions addObject:kMenuInventory];
    //[menuTransactions addObject:kMenuRepair];
    [menuTransactions addObject:kMenuCycleCount];
    
    menuUtilities = [[NSMutableArray alloc] init];
    [menuUtilities addObject:kMenuQueries];
    [menuUtilities addObject:kMenuSynchronization];
    [menuUtilities addObject:kMenuHome];
    [menuUtilities addObject:kMenuLogout];
    
    detailViewControllers = [NSMutableDictionary dictionary];
    [detailViewControllers setObject:[self.splitViewController.viewControllers lastObject] forKey:kDetailViewDefault];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender
//{
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//    
//    // If appropriate, configure the new managed object.
//    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
//    
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//         // Replace this implementation with code to handle the error appropriately.
//         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    UIViewController<SubstitutableDetailViewController> *detailViewController = (UIViewController<SubstitutableDetailViewController>*)splitViewController.viewControllers[1];
    [detailViewController showRootPopoverButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
    UIViewController<SubstitutableDetailViewController> *detailViewController = (UIViewController<SubstitutableDetailViewController>*)splitViewController.viewControllers[1];
    [detailViewController invalidateRootPopoverButtonItem:barButtonItem];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//[[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    //return [sectionInfo numberOfObjects];
    if (section==0) {
        return menuTransactions.count;
    }
    else
        return menuUtilities.count;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return kMenuSectionTransation;
    }
    else{
        return kMenuSectionUtility;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterViewCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    [super beautifyCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //    cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
    NSString* menuItem = nil;
    if (indexPath.section == 0) {
        menuItem = [menuTransactions objectAtIndex:indexPath.row];
    }else
    {
        menuItem = [menuUtilities objectAtIndex:indexPath.row];
    }
    NSString *imageName =  [NSString stringWithFormat:kMenuIconTemplate, [menuItem stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    [cell.textLabel setText:menuItem];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//        
//        NSError *error = nil;
//        if (![context save:&error]) {
//             // Replace this implementation with code to handle the error appropriately.
//             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }   
//}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* menuItem = nil;

    if(indexPath.section==0)
    {
         menuItem = [menuTransactions objectAtIndex:indexPath.row];

    }
    else{
        menuItem = [menuUtilities objectAtIndex:indexPath.row];

    }
    UIViewController* homeViewController = [detailViewControllers objectForKey:kMenuHome];
    if(nil!=menuItem)
    {
        NSString* menuItemTrimmedName = [menuItem stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([menuItem isEqualToString:kMenuLogout]) {
            //call logout
            [self.myAppDelegate logout];
        }
        else if ([menuItem isEqualToString:kMenuHome]) {
            //load first page
            if(homeViewController!=nil)
            {
                // Update the split view controller's view controllers array.
                NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, homeViewController, nil];
                self.splitViewController.viewControllers = viewControllers;
            }
        }
        else
        {
            //check whether it has been created before, which may be stored in the detailViewControllers array
            UINavigationController* detailNavigationController = [detailViewControllers objectForKey:menuItemTrimmedName];
            if(nil==detailNavigationController)
            {
                //load navigation view controller from story board based on the name. Check out the name convention each storyboard, which has to match the MenuItem key.
                NSString* storyboardName = [NSString stringWithFormat:kStoryboardTemplate, menuItemTrimmedName];
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                detailNavigationController= [storyboard instantiateInitialViewController];
                
                if([detailNavigationController conformsToProtocol:@protocol(SubstitutableDetailViewController)]&&nil!=rootPopoverButtonItem)
                {
                    DetailViewNavigationController* substituableDetailViewController = (DetailViewNavigationController*)detailNavigationController;
                    [substituableDetailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
                    if([detailNavigationController conformsToProtocol:@protocol(UINavigationControllerDelegate)])
                    {
                        detailNavigationController.delegate = (id)detailNavigationController;
                    }
                    
                }
                [detailViewControllers setObject:detailNavigationController forKey:menuItemTrimmedName];
            }
            // now change the detial view controller
            if(homeViewController==nil)
            {
                //retrieve it
                homeViewController = self.splitViewController.viewControllers[1];
                [detailViewControllers setObject:homeViewController forKey:kMenuHome];
            }
            // Update the split view controller's view controllers array.
            NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailNavigationController, nil];
            self.splitViewController.viewControllers = viewControllers;
            
            

        }
        if(popoverController!=nil)
        {
            [popoverController dismissPopoverAnimated:YES];
        }



    }
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */



@end
