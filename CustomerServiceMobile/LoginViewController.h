//
//  LoginViewController.h
//  CustomerServiceMobile
//
//  Created by LTXC on 10/18/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, assign) AppDelegate *myAppDelegate;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIView *layoutView;
- (IBAction)login:(id)sender;
- (void) clearPassword;
@end
