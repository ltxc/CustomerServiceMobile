//
//  RepairStationViewController.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/10/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "RepairStationViewController.h"
#import "ZSAutoCompleteDataHelper.h"
#import "SharedConstants.h"
#import "ZSAutoCompleteController.h"
#import "SDUserPreference.h"
#import "ZSProcessResultViewController.h"
#import "RepairStation.h"
#import "SDDataControllers.h"
#import "ZSSDDataEngine.h"
#import "ZSGUIHelper.h"
#import "NSString+JasperAddon.h"
#import "NSString+JasperAddon.h"

@interface RepairStationViewController ()


@end

@implementation RepairStationViewController

@synthesize activityDisplay=_activityDisplay;

BOOL _isSubmitted;

//NSString* _empty = @"";

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

-(void)viewWillAppear:(BOOL)animated
{
    _isSubmitted = NO;
     [self.txtSerialNo becomeFirstResponder];
    [self positionFrame];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self positionFrame];
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




- (IBAction)btnSubmitAction:(id)sender {
    
    if(!_isSubmitted)
    {
        
        if(![self validateInput])
            return;
        [self.activityDisplay startAnimating];
        ZSTransientDataGetSynch* controller = [SDDataControllers sharedAssignStationController];        
        
        [controller addNotificationObserver:self notificationName:kNotificationAssignStation selector:@selector(synchNotifiedAssignStation:)];
        NSString* inputString =  [NSString trimSpace:self.txtSerialNo.text];
        NSString* station_id = [NSString trimSpace:self.txtStationId.text];
        NSString* clientID = [NSString GetUUID];
        NSString* order_id = @"";
        NSString* serial_no = @"";
        if ([inputString hasPrefix:@"RP"]) {
            order_id = inputString;
        }
        else
        {
            serial_no = inputString;
        }
        
        [controller load:^(NSString* baseUrl,id postedObject){
            NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamOrderId,order_id,kQueryParamSerialNo,serial_no,kQueryParamStationId,station_id, kQueryParamClientId, clientID, nil];
            return [baseUrl stringByAppendingQueryParameters:dictionary];
        }];

        self.txtMessage.text = @"Please wait...";
    }
    else
    {

        self.txtMessage.text =  @"It's still waiting for server response. You may click reset to cancel it.";
    }


    
}


-(void) synchNotifiedAssignStation:(NSNotification *)notification
{
    [self.activityDisplay stopAnimating];
    _isSubmitted = NO;
    ZSProcessResult* processResult = (ZSProcessResult*)[(NSArray*)notification.object objectAtIndex:0];
    
    NSString* message = processResult.process_message;
    NSString* status = processResult.process_status;
    
    if ([status isEqual:@"COMPLETED"]&&notification.object!=nil) {
        
        //[ZSGUIHelper alert:message title:@"Process Result" template:nil delegate:nil];
        self.txtMessage.text = message;
        self.txtSerialNo.text = @"";
        //self.txtStationId.text = @"";
        [self.txtSerialNo becomeFirstResponder];
    }    
    else
    {
        //[ZSGUIHelper alert:message title:@"Process Result" template:nil delegate:nil];
        if (message==nil||[[NSString trimSpace:message] isEqualToString:@""]) {
            message = @"Server may not be reachable at this moment. Please check the connection by doing a synch such as reason code to see whether the server is responding.";
        }
        self.txtMessage.text = message;
        
    }
    
    [[SDDataControllers sharedAssignStationController]removeNotificationObserver:self notificationName:kNotificationAssignStation];
    
    
    
}








#pragma mark - Data Binding Pattern Delegate
-(void)databind:(id)datasource bind:(id)caller
{
//    <#EntityClass#>* entity = (<#EntityClass#>*)datasource;
//    if (entity!=nil) {
//        self.txt<#fieldname#>.text = entity.<#fieldname#>;
//    }
}
-(BOOL)databind:(id)datasource fetch:(id)caller
{
    
//    <#Entity Class#>* entity = (<#Entity Class#>*)datasource;
//    if ([self databindValidation:datasource]) {
//        entity.<#fieldattribute#> = self.txt<#fieldname#>.text;
//        return YES;
//    }
//    else
        return NO;
}
-(BOOL)databindValidation:(id)datasource
{
//    BOOL isValidated = YES;
//    StringBuilder* stringBuilder = [[StringBuilder alloc]init];
//    
//    NSString* <#entity#> = self.<#uicomponent#>.text;
//    if (<#entity#>==nil||[[NSString trimSpace:<#entity#>] isEqualToString:kEmptyString]) {
//        [stringBuilder add:[NSString stringWithFormat:kMessageValidationRequiredTemplate, @"<#fieldname#>"]  checkDuplicate:NO];
//        isValidated = NO;
//    }
//
//    if(!isValidated)
//    {
//    //display the alert
//    NSString* message = [stringBuilder toString:nil];
//    [GUIHelper alert:message title:kAlertTitleValidationFailed template:kMessageValidationFailedTemplate delegate:nil];
//    }
//    return isValidated;
    return YES;
}



#pragma mark - GUI Data Binding and Validation
-(BOOL)validateInput
{
    NSString* orderID = [NSString trimSpace:self.txtOrderId.text];
    NSString* serialNo = [NSString trimSpace:self.txtSerialNo.text];
    NSString* stationID = [NSString trimSpace:self.txtStationId.text];
    
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





#pragma mark - Event Handling

- (IBAction)btnRepairStation:(id)sender {
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kSortAttributeStation ascending:YES];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray* list = [[ZSSDDataEngine sharedEngine] data:kEntityRepairStation predicateTemplate:kPredicateWarehouseId predicateValue:[SDUserPreference sharedUserPreference].DefaultWarehouseID descriptors:sortDescriptors];
    ZSAutoCompleteDataHelper* helper = [[ZSAutoCompleteDataHelper alloc] initWithEntityName:kEntityRepairStation
           withDisplayBlock:^(id object){
               RepairStation* repairstation = (RepairStation*)object;
               NSString* display = [NSString stringWithFormat:@"%@", [repairstation station_id]];
               
               return display;
           }
                  withBlock:    ^(BOOL status,id result){
                      if(status==YES)
                          self.txtStationId.text = [(RepairStation*)result station_id];
                      
                      [self dismissViewControllerAnimated:YES completion:nil];
                  }
                   withData:^(NSString* entityName)
    {
        return list;
    }
    ];
    // [helper addSortDescript:kSortAttributeStation ascending:YES];
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    ZSAutoCompleteController* pickViewController = [[ZSAutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    //pickViewController.defaultValue = [[SDUserPreference sharedUserPreference]DefaultWarehouseID];
    pickViewController.autoCompleteTitle = @"Please select a Repair Station";
    [self presentViewController:pickViewController animated:YES completion:nil];
    
}
- (IBAction)btnClear:(id)sender {
    self.txtOrderId.text = @"";
    self.txtSerialNo.text = @"";
    self.txtStationId.text = @"";
    self.txtMessage.text=@"";
    _isSubmitted = NO;
    [self.txtSerialNo becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
