//
//  RepairTabBarController.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/9/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "RepairTabBarController.h"
#import "SharedConstants.h"
#import "RepairAssignmentViewController.h"
#import "RepairStationViewController.h"

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
    return;
    // Dispose of any resources that can be recreated.
    NSMutableArray* tbViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];

    UINavigationController* station = [RepairTabBarController station];
    [tbViewControllers addObject:station];
    [station setTitle:kTitleRepairStation];
    UINavigationController* assignment = [RepairTabBarController assignment];
    [assignment setTitle:kTitleRepairAssignment];
    [tbViewControllers addObject:assignment];
    self.viewControllers = tbViewControllers;
    self.selectedIndex = 0;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - SubstitutableDetailViewController Protocol Methods
-(void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem
{
}

-(void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem
{
}

/*********************** static methods ****************************/
+(UINavigationController *)station
{
    static UINavigationController* controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RepairStationViewController* viewController = [[RepairStationViewController alloc] initWithNibName:nil bundle:nil];
        controller = [[UINavigationController alloc]initWithRootViewController:viewController];
        [viewController setTitle:kTitleRepairStation];
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:kTitleRepairStation image:[UIImage imageNamed:kIconRepairStation] tag:2];
        controller.tabBarItem = item;
    });
    
    return controller;
}

+(UINavigationController *)assignment
{
    static UINavigationController* controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RepairAssignmentViewController* viewController = [[RepairAssignmentViewController alloc] initWithNibName:nil bundle:nil];
        controller = [[UINavigationController alloc]initWithRootViewController:viewController];
        [viewController setTitle:kTitleRepairAssignment];
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:kTitleRepairAssignment image:[UIImage imageNamed:kIconRepairAssignment] tag:3];
        controller.tabBarItem = item;
    });
    
    return controller;
}

@end
