//
//  MasterViewController.h
//  CustomerServiceMobile
//
//  Created by LTXC on 10/17/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 SubstitutableDetailViewController defines the protocol that detail view controllers must adopt. The protocol specifies methods to hide and show the bar button item controlling the popover.
 
 */
@protocol SubstitutableDetailViewController
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end

@class HomeViewController;

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "BeautifulTableViewController.h"

@interface MasterViewController : BeautifulTableViewController <NSFetchedResultsControllerDelegate, UISplitViewControllerDelegate>
{
    UIPopoverController *popoverController;
    UIBarButtonItem *rootPopoverButtonItem;
}

@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) AppDelegate* myAppDelegate;
@end
