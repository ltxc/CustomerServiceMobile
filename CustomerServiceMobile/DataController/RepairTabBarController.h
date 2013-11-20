//
//  RepairTabBarController.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/9/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DetailViewNavigationController.h"
//RepairTabBarController as the initial controller of RepairStoryboard is called in the MasterViewController when rotate.
// SubstitutableDetailViewController delegate is called in (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem

@interface RepairTabBarController : UITabBarController<SubstitutableDetailViewController>
+(DetailViewNavigationController*) station;
//+(UINavigationController*) assignment;
@property (nonatomic, assign) AppDelegate *myAppDelegate;
@end
