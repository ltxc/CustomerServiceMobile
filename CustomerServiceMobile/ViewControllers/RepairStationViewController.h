//
//  RepairStationAssignmentViewController.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 10/9/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairStationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtSerialNo;
@property (weak, nonatomic) IBOutlet UITextField *txtOrderId;
@property (weak, nonatomic) IBOutlet UITextField *txtStationId;
@property (weak, nonatomic) IBOutlet UIView *viewLayout;
- (IBAction)btnStation:(id)sender;
- (IBAction)btnSubmit:(id)sender;
- (IBAction)btnClear:(id)sender;


@end
