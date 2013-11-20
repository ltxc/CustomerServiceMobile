//
//  RepairStationViewController.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/10/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSGUIHelper.h"

@interface RepairStationViewController : UIViewController <ZSDataBindingPatternDelegate>


//@property (strong, nonatomic) RPStation* rpStation;
@property (strong, nonatomic) IBOutlet UITextField *txtOrderId;
@property (strong, nonatomic) IBOutlet UITextField *txtSerialNo;
@property (strong, nonatomic) IBOutlet UITextField *txtStationId;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UIView *viewLayout;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityDisplay;


- (IBAction)btnRepairStation:(id)sender;
- (IBAction)btnSubmitAction:(id)sender;
- (IBAction)btnClear:(id)sender;
-(void)positionFrame;


@end
