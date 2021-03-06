//
//  RepairTabBarController.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/9/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "RepairTabBarController.h"
#import "SharedConstants.h"
//#import "RepairAssignmentViewController.h"
#import "RepairStationViewController.h"
#import "HomeViewController.h"
#import "DetailViewNavigationController.h"
@interface RepairTabBarController ()

@end

@implementation RepairTabBarController

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

    // Dispose of any resources that can be recreated.
    NSMutableArray* tbViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    
    

    DetailViewNavigationController* station = [RepairTabBarController station];
    [tbViewControllers insertObject:station atIndex:0];
    [station setTitle:kTitleRepairStation];
    
//    UINavigationController* assignment = [RepairTabBarController assignment];
//    [assignment setTitle:kTitleRepairAssignment];
//    [tbViewControllers insertObject:assignment atIndex:4];
//    
    
    self.viewControllers = tbViewControllers;
    self.selectedIndex = 0;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem
{
    barButtonItem.title = @"Menu";

    DetailViewNavigationController* selectedOne = (DetailViewNavigationController*)[self.viewControllers objectAtIndex:self.selectedIndex];
    if (selectedOne!=nil) {
        selectedOne.menuBarButtonItem = barButtonItem;
        [selectedOne.topViewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    }
    
}
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem
{
    DetailViewNavigationController* selectedOne = (DetailViewNavigationController*)[self.viewControllers objectAtIndex:self.selectedIndex];
    if (selectedOne!=nil) {
        selectedOne.menuBarButtonItem = nil;
        [selectedOne.topViewController.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}


#pragma mark Singleton Controllers
+(DetailViewNavigationController *)station
{
    static DetailViewNavigationController* stationController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RepairStationViewController* viewController = [[RepairStationViewController alloc] initWithNibName:nil bundle:nil];
        stationController = [[DetailViewNavigationController alloc]initWithRootViewController:viewController];
        [viewController setTitle:kTitleRepairStation];
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:kTitleRepairStation image:[UIImage imageNamed:kIconRepairStation] tag:2];
        stationController.tabBarItem = item;
    });
    
    return stationController;
}

//+(UINavigationController *)assignment
//{
//    static UINavigationController* assignementController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        RepairAssignmentViewController* viewController = [[RepairAssignmentViewController alloc] initWithNibName:nil bundle:nil];
//        assignementController = [[UINavigationController alloc]initWithRootViewController:viewController];
//        [viewController setTitle:kTitleRepairAssignment];
//        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:kTitleRepairAssignment image:[UIImage imageNamed:kIconRepairAssignment] tag:3];
//        assignementController.tabBarItem = item;
//    });
//    
//    return assignementController;
//}



@end
