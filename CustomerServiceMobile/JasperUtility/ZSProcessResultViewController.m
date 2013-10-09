//
//  ProcessResultViewController.m
//  SFCMobile
//
//  Created by Jinsong Lu on 8/8/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSProcessResultViewController.h"
#import "SDUserPreference.h"
#import "ZSGUIHelper.h"
@interface ZSProcessResultViewController ()

@end

@implementation ZSProcessResultViewController

@synthesize actionName=_actionName;
@synthesize actionTitle=_actionTitle;
@synthesize processResult=_processResult;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_processResult) {
        self.lblActionName.text = _processResult.transactionType;
        self.lblStatus.text = _processResult.process_status;
        if (_processResult.process_date!=nil) {
            NSDateFormatter* _dateFormatter = [NSDateFormatter new];
            [_dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
            self.lblTimestamp.text = [_dateFormatter stringFromDate:_processResult.process_date];
        }
        self.txtMessage.text = _processResult.process_message;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setResult:(NSString *)title actionName:(NSString *)actionName result:(ZSProcessResult *)result
{
    _actionTitle = title;
    _actionName=actionName;
    _processResult=result;
    [self bind];
}

-(void)bind
{
    self.lblTitle.text = [_actionTitle capitalizedString];
    self.lblActionName.text = _actionName;
    NSDate* date = nil;
    if (_processResult!=nil) {
        //set the result
        date = _processResult.process_date;
        self.txtMessage.text = [NSString stringWithFormat:@"     %@", [_processResult.process_message capitalizedString]];
        self.lblStatus.text = _processResult.process_status;
    }
    else
    {
        date = [NSDate date];
    }
    self.lblTimestamp.text = [[SDUserPreference sharedUserPreference].dateFormatter stringFromDate:date];
}
- (IBAction)btnOK:(id)sender {
    [self.parent modalViewDismiss:_processResult view:self];
}
@end
