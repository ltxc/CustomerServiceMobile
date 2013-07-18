
#import "HomeViewController.h"
#import "SDUserPreference.h"
#import "AutoComplete.h"
#import "SharedConstants.h"
#import "Warehouse.h"
#import "ApplicationData.h"
#import "SDDataEngine.h"
#import "SDRestKitEngine.h"

@interface HomeViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
-(void) alertWhenEnvironmentChange:(NSInteger)alertAction newLandscape:(NSString*)newLandscape oldLandscape:(NSString*)oldLandscape;
@end

@implementation HomeViewController
BOOL _synchInProgressWarehouse = NO;
BOOL _synchInProgressApplicationData = NO;
BOOL _isLandscapeChanged = NO;

NSInteger _alertViewActionCode = 0; //1 - click button, 2 - changed by settings, 3 - warn the logout after successful sync., 4 - synch failed
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }

}

- (void)configureView
{
//    // Update the user interface for the detail item.
//
//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
//    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
    UIColor *backGroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BlueBackground.png"]];
    self.view.backgroundColor = backGroundColor;
    self.layoutView.clipsToBounds = NO;
    [SDUserPreference addShadow:self.layoutView.layer];
    [self checkLandscapeChange];
    //check whether there is need to synch application and warehouse data
    if (![SDUserPreference sharedUserPreference].IsInited) {
        [self synchWarehouse];        
        [self synchApplicationData];
        return;
    }

}


-(void)binding
{
    
    self.lblDefaultWarehouse.text = [SDUserPreference sharedUserPreference].DefaultWarehouseID;
    self.lblUserName.text = [SDUserPreference sharedUserPreference].LastLogin;
    self.lblVersion.text = [SDUserPreference sharedUserPreference].Version;
    self.lblPrinter.text = [SDUserPreference sharedUserPreference].Printer;
    self.lblApplicationServer.text = [SDUserPreference sharedUserPreference].ServiceServer;
    self.lblReportServer.text = [SDUserPreference sharedUserPreference].ReportServer;
    self.lblLandscape.text = [SDUserPreference sharedUserPreference].Landscape;
    if ([self.lblLandscape.text isEqualToString:@"production"]) {
        self.btnLandscape.hidden = YES;
    }
    else
        self.btnLandscape.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self positionFrame];
    [self binding];

}

-(void)viewDidAppear:(BOOL)animated
{
    if (_isLandscapeChanged) {
        [self alertWhenEnvironmentChange:2 newLandscape:[SDUserPreference sharedUserPreference].Landscape oldLandscape:[SDUserPreference sharedUserPreference].LastLandscape];
    }
}

-(void)positionFrame{
    CGFloat width = self.view.bounds.size.width/2;
    CGFloat height = self.view.bounds.size.height/2;
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait||self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        height = self.view.bounds.size.height/2;
    }
    
    self.layoutView.center = CGPointMake(width,height );
}



-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self positionFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
    [self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark -- Event

- (IBAction)btnWarehouseID:(id)sender {
    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityWarehouse
        withDisplayBlock:^(id object){
            Warehouse* warehouse = (Warehouse*)object;
            NSString* display = [NSString stringWithFormat:@"%@", [warehouse warehouse_id]];
            return display;
        }
        withBlock:    ^(BOOL status,id result){
            if(status==YES)
            {
                //change the default warehouse
                self.lblDefaultWarehouse.text = [(Warehouse*)result warehouse_id];
                [SDUserPreference sharedUserPreference].DefaultWarehouseID = [(Warehouse*)result warehouse_id];
            }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [helper addSortDescript:kSortAttributeWarehouse ascending:YES];
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    AutoCompleteController* pickViewController = [[AutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    pickViewController.defaultValue = [[SDUserPreference sharedUserPreference]DefaultWarehouseID];
    pickViewController.autoCompleteTitle = @"Please select a default warehouse";
    [self presentViewController:pickViewController animated:YES completion:nil];
    
}

- (IBAction)btnPrinter:(id)sender {

    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityApplicationData 
        withDisplayBlock:^(id object){
            
            return [NSString stringWithFormat:@"%@ - %@", [(ApplicationData*)object value],[(ApplicationData*)object desc]];
        }        
        withBlock:^(BOOL status, id result){
            if(status==YES)
            {
                self.lblPrinter.text = [(ApplicationData*)result value];
                [SDUserPreference sharedUserPreference].Printer = [(ApplicationData*)result value];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    [helper setPredicateWithTemplate:kFetchTemplatePrinter value:@"printer"];
    //specify the sort column that is in the entity table
    [helper addSortDescript:kSortAttributeValue ascending:YES];
    
    AutoCompleteController* pickViewController = [[AutoCompleteController alloc] init];
    
    pickViewController.autoCompleteDelegate = helper;
    
    pickViewController.autoCompleteTitle = @"Please select the printer";
    
    
    
    [self presentViewController:pickViewController animated:YES completion:nil];

}

- (IBAction)btnLandscape:(id)sender {
    NSArray* availableValues = [[SDDataEngine sharedEngine] distinctValues:kEntityApplicationData attributeName:@"landscape" predicate:nil];
    
    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityWarehouse
        withDisplayBlock:^(id object){
            return (NSString*)[object objectForKey:@"landscape"];
        }
        withData:^(NSString *entityName) {
              return availableValues;
        }
        withBlock:^(BOOL status, id result){
                if(status==YES)
                {
                    //change landscape
                    [self setServerViaLandscape:(NSString*)[result objectForKey:@"landscape"]];
                }
            [self dismissViewControllerAnimated:YES completion:nil];

        }];
    [helper addSortDescript:kSortAttributeWarehouse ascending:YES];
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    AutoCompleteController* pickViewController = [[AutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    pickViewController.autoCompleteTitle = @"Please select a landscape";
    [self presentViewController:pickViewController animated:YES completion:nil];
}

- (IBAction)btnRefresh:(id)sender {
    [self checkLandscapeChange];
    [self synchWarehouse];
    [self synchApplicationData];
    
}



#pragma mark -- Application Data Handling
-(void) alertWhenEnvironmentChange:(NSInteger)alertAction newLandscape:(NSString*)newLandscape oldLandscape:(NSString*)oldLandscape
{
    _alertViewActionCode = alertAction;
    NSString* message = nil;
    if (alertAction==1) {
        message = [NSString stringWithFormat:@"Are you sure you want to change the environment from %@ to %@? It will result in refreshing the local database, including your history transaction data. After that, you will be logout of the application...",oldLandscape,newLandscape]  ;
    }
    else if(alertAction==2)
    {
        message =[NSString stringWithFormat:@"You have changed the environment from %@ to %@. This will result in refreshing the local database, including your history transaction data. Click Yes to continue, otherwise, click No to reverse the setting.",oldLandscape,newLandscape];
    }
    else if(alertAction==3)
    {
        message = @"Application Setting has been synchronized with the server. It needs to logout to take effect.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout Warning" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Application Environment Change Warning" message:message delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (_alertViewActionCode==3) {
        [[SDDataEngine sharedEngine]saveRKCache];
        exit(0);
    }
    else if (_alertViewActionCode == 1 || _alertViewActionCode == 2)
    {
        if (buttonIndex != 0) {
            //cancelled
            [SDUserPreference sharedUserPreference].Landscape = [SDUserPreference sharedUserPreference].LastLandscape;
            _isLandscapeChanged = NO;
            [[SDDataEngine sharedEngine]saveRKCache];
            exit(0);
        }
        else
        {
            [self checkLandscapeChange];
            [self synchApplicationData];
        }
    }
   }
//called when landscape change is done through the homepage, click the landscape change button.
-(void)setServerViaLandscape:(NSString*)landscape
{
 
    [SDUserPreference sharedUserPreference].Landscape = landscape;
    NSString* originalLandscape = [SDUserPreference sharedUserPreference].LastLandscape;
    if (![landscape isEqualToString:originalLandscape]) {
        if (![landscape isEqualToString:@"none"]) {
           
            [self alertWhenEnvironmentChange:1 newLandscape:landscape oldLandscape:originalLandscape];
        }
        else
        {
            //change it
            [SDUserPreference sharedUserPreference].Landscape = landscape;
            [SDUserPreference sharedUserPreference].LastLandscape = landscape;
            [self binding];
        }
        
    }
   
    
}


//make sure the server settings match the landscape, if changed, force a logout.
-(void)synchServerSettings:(NSString*)landscape
{
    //reset the application server name and reporting server
    BOOL isApplicatonDataChange = NO;
    NSArray* data = [[SDDataEngine sharedEngine] data:kEntityApplicationData predicateTemplate:kPredicateServerApplicationData predicateValue:landscape descriptors:nil];
    for (id object in data){
        ApplicationData* appData = (ApplicationData*)object;
        
        if ([appData.subcategory isEqualToString:@"applicationserver"]) {
            NSString* serverurl = [SDUserPreference sharedUserPreference].ServiceServer;
            if (![serverurl isEqualToString:appData.value]) {
                [SDUserPreference sharedUserPreference].ServiceServer = appData.value;
                isApplicatonDataChange = YES;
            }            
        }
        else if ([appData.subcategory isEqualToString:@"reportserver"])
        {
            NSString* reportserverurl =  [SDUserPreference sharedUserPreference].ReportServer;
            if (![reportserverurl isEqualToString:appData.value]) {
                [SDUserPreference sharedUserPreference].ReportServer = appData.value;
                isApplicatonDataChange = YES;
            }
            
        }
    }
    
    //if system landscape change, it will need a clear database
    if (isApplicatonDataChange&&!_isLandscapeChanged) {

        [self alertWhenEnvironmentChange:3 newLandscape:[SDUserPreference sharedUserPreference].Landscape oldLandscape:[SDUserPreference sharedUserPreference].LastLandscape];
        
    }
    if (![SDUserPreference sharedUserPreference].IsInited) {
        [SDUserPreference sharedUserPreference].LastLandscape = [SDUserPreference sharedUserPreference].Landscape;
        [SDUserPreference sharedUserPreference].IsInited = YES;
    }
    
    [self binding];
    [self positionFrame];
}

//if first time, it is not considered as landscape change
-(void)checkLandscapeChange
{
    _isLandscapeChanged = NO;
    NSString* lastLandscape = [SDUserPreference sharedUserPreference].LastLandscape;
    if(lastLandscape!=nil)
    {
        //not first time
        NSString* currentLandscape = [SDUserPreference sharedUserPreference].Landscape;
        if (![lastLandscape isEqualToString:currentLandscape]) {
            _isLandscapeChanged = YES;
        }
        else
            _isLandscapeChanged = NO;
    }
    
}

-(void) synchWarehouse
{

    CoreDataGetSynch* controller = [SDRestKitEngine sharedWarehouseController];
    if(!_synchInProgressWarehouse)
    {
        _synchInProgressWarehouse = YES;
        [self.activity_SynchWarehouse startAnimating];
        //add observer
        [controller addNotificationObserver:self notificationName:kNotificationNameWarehouse selector:@selector(synchNotifiedWarehouse:)];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load:^(NSString* baseUrl,id postedObject){
                NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
                return [kUrlBaseWarehouse appendQueryParams:dictionary];
            }];
        });
    }

}

-(void) synchNotifiedWarehouse:(NSNotification *)notification
{
    [self.activity_SynchWarehouse stopAnimating];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameWarehouse];
    _synchInProgressWarehouse = NO;
    
}

//only called when the landscape has been changed.
-(void) synchApplicationData
{
    
    CoreDataGetSynch* controller = [SDRestKitEngine sharedApplicationDataController];
    if(!_synchInProgressApplicationData)
    {
        _synchInProgressApplicationData = YES;
        [self.activity_SynchApplicationData startAnimating];
        
        //add observer
        [controller addNotificationObserver:self notificationName:kNotificationNameApplicationData selector:@selector(synchNotifiedApplicationData:)];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load:^(NSString* baseUrl,id postedObject){
                NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
                return [kUrlBaseApplicationData appendQueryParams:dictionary];
            }];
        });
    }
    
}

-(void) synchNotifiedApplicationData:(NSNotification *)notification
{
    NSNumber* status = [[SDRestKitEngine sharedEngine] getNotificationStatus:notification];
   
    [self.activity_SynchApplicationData stopAnimating];
    _synchInProgressApplicationData = NO;
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameApplicationData];
    if ([status intValue]==1) {        
        if (!_isLandscapeChanged) 
             [self synchServerSettings:[SDUserPreference sharedUserPreference].Landscape];
    }
    else
    {
        NSString* processmessage = [NSString stringWithFormat:@"%@. This may result in inconsistent server settings. Please contact IT for help.", [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:@"synch application data"]];
        [SDDataEngine alert:processmessage title:@"Synchronization Failed" template:nil delegate:nil];
    }
   
    if (_isLandscapeChanged) {
        [self synchServerSettings:[SDUserPreference sharedUserPreference].Landscape];
        //change it
        [SDUserPreference sharedUserPreference].LastLandscape = [SDUserPreference sharedUserPreference].Landscape;
        [SDUserPreference sharedUserPreference].IsInited = YES;
        [[SDDataEngine sharedEngine] clearDatabase];
        sleep(8);
        exit(0);

    }

    [self binding];
    [self positionFrame];
   
}


@end
