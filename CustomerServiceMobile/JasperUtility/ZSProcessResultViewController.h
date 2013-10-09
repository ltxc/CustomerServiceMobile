//
//  ProcessResultViewController.h
//  SFCMobile
//
//  Created by Jinsong Lu on 8/8/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSProcessResult.h"
#import "ZSGUIHelper.h"
@interface ZSProcessResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblActionName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTimestamp;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
- (IBAction)btnOK:(id)sender;

@property (weak, nonatomic) id<ZSModalViewDelegate> parent;
@property (strong,nonatomic)NSString* actionTitle;
@property (strong,nonatomic)NSString* actionName;
@property (strong,nonatomic)ZSProcessResult* processResult;

-(void)setResult:(NSString*)title actionName:(NSString*)actionName result:(ZSProcessResult*)result;
@end
