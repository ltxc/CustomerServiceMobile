//
//  DetailViewNavigationController.h
//  Base class for detail view navigation controller. It takes care of the master detail view structure.
//
//  Created by Jinsong LU on 10/25/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface DetailViewNavigationController : UINavigationController <SubstitutableDetailViewController,UINavigationControllerDelegate>


@property (strong, nonatomic) UIBarButtonItem *menuBarButtonItem;
@end
