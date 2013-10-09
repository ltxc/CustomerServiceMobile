//
//  RepairStationAssignmentViewController.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 10/9/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "RepairStationViewController.h"
#import "RepairStation.h"
#import "SDDataControllers.h"
#import "NSString+JasperAddon.h"
#import "ZSGUIHelper.h"
#import "SharedConstants.h"
#import "AutoComplete.h"
#import "AutoCompleteDataHelper.h"
#import "ZSSDDataEngine.h"
#import "SDUserPreference.h"

#import "ZSAutoComplete.h"
#import "ZSAutoCompleteController.h"
#import "ZSAutoCompleteDataHelper.h"

@interface RepairStationViewController ()

@end

@implementation RepairStationViewController
NSString* _emptyString = @"";
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)validateInput
{
    NSString* orderID = self.txtOrderId.text;
    NSString* serialNo = self.txtSerialNo.text;
    NSString* stationID = self.txtStationId.text;
    
    if(([orderID isEqualToString:@""])&&([serialNo isEqualToString:@""]))
    {
        [ZSGUIHelper alert:kMessageAssignStationNoValue title:nil template:nil delegate:self];
        return NO;
    }
    
    if([stationID isEqualToString:@""])
    {
        [ZSGUIHelper alert:kMessageAssignStationIDNoValue title:nil template:nil delegate:self];
        return NO;
    }
    
    return YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.txtSerialNo becomeFirstResponder];
}

-(void)positionFrame{
    CGFloat width = self.view.bounds.size.width/2;
    CGFloat height = self.view.bounds.size.height/2;
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait||self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        height = self.view.bounds.size.height/2;
    }
    
    self.viewLayout.center = CGPointMake(width,height );
}



-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self positionFrame];
}

- (IBAction)btnSubmit:(id)sender {
    
    if(![self validateInput])
        return;
    
    NSString* orderID = self.txtOrderId.text;
    NSString* serialNo = self.txtSerialNo.text;
    NSString* stationID = self.txtStationId.text;
    NSString* clientID = [NSString GetUUID];
    
    
    //[_activityDisplay startAnimating];
    
    [[SDDataControllers shared]assignStation:orderID serialNo:serialNo stationId:stationID clientId:clientID];
}

- (IBAction)btnClear:(id)sender {
    self.txtOrderId.text = @"";
    self.txtSerialNo.text = @"";
    self.txtStationId.text = @"";
    [self.txtSerialNo becomeFirstResponder];

}

-(void)btnStation:(id)sender
{
    NSArray* list = [[ZSSDDataEngine sharedEngine] data:kEntityRepairStation predicateTemplate:kPredicateWarehouseId predicateValue:[SDUserPreference sharedUserPreference].DefaultWarehouseID descriptors:nil];
    ZSAutoCompleteDataHelper* helper = [[ZSAutoCompleteDataHelper alloc] initWithEntityName:kEntityRepairStation
                                                                           withDisplayBlock:^(id object){
                                                                               RepairStation* repairstation = (RepairStation*)object;
                                                                               NSString* display = [NSString stringWithFormat:@"%@", [repairstation station_id]];
                                                                               
                                                                               return display;
                                                                           }
                                                                                  withBlock:    ^(BOOL status,id result){
                                                                                      if(status==YES)
                                                                                          self.txtStationId.text = [(RepairStation*)result station_id];
                                                                                      else
                                                                                          self.txtStationId.text = @"";
                                                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                                                  }
                                                                          withData:^(NSString* entityName)
                                                                          {
                                                                              return list;
                                                                          }
                                        ];
    // [helper addSortDescript:kSortAttributeWarehouse ascending:YES];
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    ZSAutoCompleteController* pickViewController = [[ZSAutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    //pickViewController.defaultValue = [[SDUserPreference sharedUserPreference]DefaultWarehouseID];
    pickViewController.autoCompleteTitle = @"Please select a Repair Station";
    [self presentViewController:pickViewController animated:YES completion:nil];
}
@end
