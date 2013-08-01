//
//  SynchTableViewController.m
//  CustomerServiceMobile
//


#import "SynchTableViewController.h"
#import "SDUserPreference.h"
#import "SharedConstants.h"
#import "ManAdjustReason.h"
#import "Queries.h"
#import "SDRestKitEngine.h"
#import "SDDataEngine.h"

@interface SynchTableViewController ()

@end
BOOL _synchInProgressWarehouse;
BOOL _synchInProgressApplicationData;
BOOL _synchInProgressCompany;
BOOL _synchInProgressCarrier;
BOOL _synchInProgressBinPart;


BOOL _synchInProgressQueries;
BOOL _synchInProgressReason;
BOOL _synchInProgressReports;
BOOL _synchInProgressShipmentInstructions;
BOOL _synchInProcessRepairMasterData;

@implementation SynchTableViewController
@synthesize lblLastUpdate_SynchApplicationData, lblLastUpdated_SynchBin,lblLastUpdated_SynchCarrier,lblLastUpdated_SynchCompany,
lblLastUpdated_SynchWarehosue,lblLastUpdated_SynchReason, lblLastUpdated_SynchReports,lblLastUpdated_SynchRepairMasterData;
@synthesize lblStatus_SynchApplicationData,lblStatus_SynchBin,lblStatus_SynchCarrier,lblStatus_SynchCompany,lblStatus_SynchWarehouse,lblStatus_SynchReason, lblStatus_SynchReports,lblLastUpdated_SynchShipmentInstructions,lblStatus_SynchShipmentInstructions, lblStatus_SynchRepairMasterData;
@synthesize dateFormatter;
@synthesize activity_synchApplicationData, activity_SynchBin,activity_SynchCarrier,activity_SynchCompany,activity_SynchWarehouse,activity_SynchReason, activity_SynchReports,activity_SynchShipmentInstructions, activity_SynchRepairMasterData;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:kSynchDateTemplate options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    self.dateFormatter = formatter;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self setDataFromUserDefault:formatter];

    
    
}

- (void) setDataFromUserDefault:(NSDateFormatter*) formatter
{
    //last updated
    lblLastUpdate_SynchApplicationData.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchApplicationData]] ;
    lblLastUpdated_SynchBin.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchBin]] ;
    lblLastUpdated_SynchCompany.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchCompany]] ;
    lblLastUpdated_SynchCarrier.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchCarrier]] ;
    lblLastUpdated_SynchWarehosue.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchWarehouse]] ;
    lblLastUpdated_SynchReason.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchReason]] ;
    lblLastUpdated_SynchReports.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchReports]] ;
    lblLastUpdated_SynchShipmentInstructions.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchShipmentInstructions]] ;
    lblLastUpdated_SynchRepairMasterData.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchRepairMasterData]];
    //last update status
    
}

- (void) resetDataToUserDefault
{
    [SDUserPreference sharedUserPreference].LastSynchApplicationData = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchBin = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchCarrier = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchCompany = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchWarehouse = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchReason = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchReports = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchShipmentInstructions = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchRepairMasterData = [NSDate distantPast];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) synchAll:(id)sender{

    [self synchApplicationData:sender];
    [self synchCompany:sender];
    [self synchCarrier:sender];
    [self synchWarehouse:sender];
    [self synchReason:sender];
    [self synchReports:sender];
    [self synchShipmentInstructions:sender];
    sleep(1);
    [self synchBin:sender];
    
}

- (IBAction)resetAll:(id)sender {
    [self resetDataToUserDefault];
    [self setDataFromUserDefault:self.dateFormatter];
    
    
}

//- (IBAction)synchApplicationData:(id)sender {
//    ApplicationDataSynchController* controller = [SDRestKitEngine sharedApplicationDataController];
//    if(!_synchInProgressApplicationData)
//    {
//        _synchInProgressApplicationData = YES;
//        [activity_synchApplicationData startAnimating];
//        [lblStatus_SynchApplicationData setText:@""];
//        //add observer
//        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameApplicationData selector:@selector(synchNotifiedApplicationData:)];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [controller load];
//        });
//    }
//}

-(IBAction) synchApplicationData:(id)sender{
    CoreDataGetSynch* controller = [SDRestKitEngine sharedApplicationDataController];
    if(!_synchInProgressApplicationData)
    {
        _synchInProgressApplicationData = YES;
        [activity_synchApplicationData startAnimating];
        [lblStatus_SynchApplicationData setText:@""];
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
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameApplicationData];
    [lblStatus_SynchApplicationData setText:info];
    _synchInProgressApplicationData = NO;
    [activity_synchApplicationData stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchApplicationData = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameApplicationData];
}


//-(IBAction) synchCompany:(id)sender{
//    CompanySynchController* controller = [SDRestKitEngine sharedCompanyController];
//    if(!_synchInProgressCompany)
//    {
//        _synchInProgressCompany = YES;
//        [activity_SynchCompany startAnimating];
//        [lblStatus_SynchCompany setText:@""];
//        //add observer
//        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameCompany selector:@selector(synchNotifiedCompany:)];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [controller load];
//        });
//    }
//}

-(IBAction) synchCompany:(id)sender{
    CoreDataGetSynch* controller = [SDRestKitEngine sharedCompanyController];
    if(!_synchInProgressCompany)
    {
        _synchInProgressCompany = YES;
        [activity_SynchCompany startAnimating];
        [lblStatus_SynchCompany setText:@""];
        //add observer
        [controller addNotificationObserver:self notificationName:kNotificationNameCompany selector:@selector(synchNotifiedCompany:)];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load:^(NSString* baseUrl,id postedObject){
                NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
               return [kUrlBaseCompany appendQueryParams:dictionary];
            }];
        });
    }
}





-(void) synchNotifiedCompany:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameCompany];
    [lblStatus_SynchCompany setText:info];
    _synchInProgressCompany = NO;
    [activity_SynchCompany stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchCompany = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameCompany];
}


//-(IBAction) synchCarrier:(id)sender{
//    CarrierSynchController* controller = [SDRestKitEngine sharedCarrierController];
//    if(!_synchInProgressCarrier)
//    {
//        _synchInProgressCarrier = YES;
//        [activity_SynchCarrier startAnimating];
//         [lblStatus_SynchCarrier setText:@""];
//        //add observer
//        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameCarrier selector:@selector(synchNotifiedCarrier:)];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [controller load];
//        });
//    }
//}

-(IBAction) synchCarrier:(id)sender{
    CoreDataGetSynch* controller = [SDRestKitEngine sharedCarrierController];
    if(!_synchInProgressCarrier)
    {
        _synchInProgressCarrier = YES;
        [activity_SynchCarrier startAnimating];
        [lblStatus_SynchCarrier setText:@""];
        //add observer
        [controller addNotificationObserver:self notificationName:kNotificationNameCarrier selector:@selector(synchNotifiedCarrier:)];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load:^(NSString* baseUrl,id postedObject){
                NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
               return [kUrlBaseCarrier appendQueryParams:dictionary];
            }];
        });
    }
}


-(void) synchNotifiedCarrier:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameCarrier];
    [lblStatus_SynchCarrier setText:info];
    _synchInProgressCarrier= NO;
    [activity_SynchCarrier stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchCarrier = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameCarrier];
}

//-(IBAction) synchWarehouse:(id)sender{
//    WarehouseSynchController* controller = [SDRestKitEngine sharedWarehouseController];
//    if(!_synchInProgressWarehouse)
//    {
//        _synchInProgressWarehouse = YES;
//        [activity_SynchWarehouse startAnimating];
//         [lblStatus_SynchWarehouse setText:@""];
//        //add observer
//        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameWarehouse selector:@selector(synchNotifiedWarehouse:)];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [controller load];
//        });
//    }}

-(IBAction) synchWarehouse:(id)sender{
    CoreDataGetSynch* controller = [SDRestKitEngine sharedWarehouseController];
    if(!_synchInProgressWarehouse)
    {
        _synchInProgressWarehouse = YES;
        [activity_SynchWarehouse startAnimating];
        [lblStatus_SynchWarehouse setText:@""];
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
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameWarehouse];
    [lblStatus_SynchWarehouse setText:info];
    _synchInProgressWarehouse= NO;
    [activity_SynchWarehouse stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchWarehouse = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameWarehouse];
}

//-(IBAction) synchBin:(id)sender{
//    BinPartSynchController* controller = [SDRestKitEngine sharedBinPartController];
//    if(!_synchInProgressBinPart)
//    {
//        _synchInProgressBinPart = YES;
//         [lblStatus_SynchBin setText:@""];
//        [activity_SynchBin startAnimating];
//        //add observer
//        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameBinPart selector:@selector(synchNotifiedBin:)];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [controller load];
//        });
//    }
//
//}


-(IBAction) synchBin:(id)sender{
    CoreDataGetSynch* controller = [SDRestKitEngine sharedBinPartController];
    if(!_synchInProgressBinPart)
    {
        _synchInProgressBinPart = YES;
        [activity_SynchBin startAnimating];
        [lblStatus_SynchBin setText:@""];
        //add observer
        [controller addNotificationObserver:self notificationName:kNotificationNameBinPart selector:@selector(synchNotifiedBin:)];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load:^(NSString* baseUrl,id postedObject){
                NSString* defaultWarehouseID = [SDUserPreference sharedUserPreference].DefaultWarehouseID;
                NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamWarehouseId,defaultWarehouseID,kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];

               return [kUrlBaseBinPart appendQueryParams:dictionary];
            }];
        });
    }
}




-(void) synchNotifiedBin:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameBinPart];
    [lblStatus_SynchBin setText:info];
    _synchInProgressBinPart= NO;
    [activity_SynchBin stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchBin = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameBinPart];
}



//- (IBAction)synchReason:(id)sender {
//    ManAdjustReasonController* controller = [SDRestKitEngine sharedReasonController];
//    if(!_synchInProgressReason)
//    {
//        _synchInProgressReason = YES;
//        [lblStatus_SynchReason setText:@""];
//        [activity_SynchReason startAnimating];
//        //add observer
//        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameManAdjustReason selector:@selector(synchNotifiedReason:)];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [controller load];
//        });
//    }
//
//}

-(IBAction) synchReason:(id)sender{
    CoreDataGetSynch* controller = [SDRestKitEngine sharedReasonController];
    if(!_synchInProgressReason)
    {
        _synchInProgressReason = YES;
        [activity_SynchReason startAnimating];
        [lblStatus_SynchReason setText:@""];
        //add observer
        [controller addNotificationObserver:self notificationName:kNotificationNameManAdjustReason selector:@selector(synchNotifiedReason:)];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load:^(NSString* baseUrl,id postedObject){
                NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
               return [kUrlBaseManAdjustReason appendQueryParams:dictionary];
            }];
        });
    }
}





-(void) synchNotifiedReason:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameManAdjustReason];
    [lblStatus_SynchReason setText:info];
    _synchInProgressReason= NO;
    [activity_SynchReason stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchReason = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameManAdjustReason];
}


//- (IBAction)synchReports:(id)sender {
//    QueriesSynchController* controller = [SDRestKitEngine sharedQueriesController];
//    if(!_synchInProgressReports)
//    {
//        _synchInProgressReports = YES;
//        [lblStatus_SynchReports setText:@""];
//        [activity_SynchReports startAnimating];
//        //add observer
//        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationReports selector:@selector(synchNotifiedReports:)];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [controller load];
//        });
//    }
//    
//    
//}

-(IBAction) synchReports:(id)sender{
    CoreDataGetSynch* controller = [SDRestKitEngine sharedQueriesController];
    if(!_synchInProgressReports)
    {
        _synchInProgressReports = YES;
        [activity_SynchReports startAnimating];
        [lblStatus_SynchReports setText:@""];
        //add observer
        [controller addNotificationObserver:self notificationName:kNotificationReports selector:@selector(synchNotifiedReports:)];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load:^(NSString* baseUrl,id postedObject){
                NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
               return [kUrlBaseQueries appendQueryParams:dictionary];
            }];
        });
    }
}





-(void) synchNotifiedReports:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationReports];
    [lblStatus_SynchReports setText:info];
    _synchInProgressReports= NO;
    [activity_SynchReports stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchReports = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationReports];
}


//- (IBAction)synchShipmentInstructions:(id)sender {
//    ShipmentInstructionsSynchController* controller = [SDRestKitEngine sharedShipmentInstructionsController];
//    if(!_synchInProgressShipmentInstructions)
//    {
//        _synchInProgressShipmentInstructions = YES;
//        [lblStatus_SynchShipmentInstructions setText:@""];
//        [activity_SynchShipmentInstructions startAnimating];
//        //add observer
//        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationShipmentInstructions selector:@selector(synchNotifiedShipmentInstructions:)];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [controller load];
//        });
//    }
//    
//    
//}

-(IBAction) synchShipmentInstructions:(id)sender{
    CoreDataGetSynch* controller = [SDRestKitEngine sharedShipmentInstructionsController];
    if(!_synchInProgressShipmentInstructions)
    {
        _synchInProgressShipmentInstructions = YES;
        [activity_SynchShipmentInstructions startAnimating];
        [lblStatus_SynchShipmentInstructions setText:@""];
        //add observer
        [controller addNotificationObserver:self notificationName:kNotificationShipmentInstructions  selector:@selector(synchNotifiedShipmentInstructions:)];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load:^(NSString* baseUrl,id postedObject){
                NSDictionary* dictionary = [NSDictionary dictionaryWithKeysAndObjects:kQueryParamFirstResult,@"0", kQueryParamMaxResult, @"0", nil];
               return [kUrlBaseShipmentInstructions appendQueryParams:dictionary];
            }];
        });
    }
}




-(void) synchNotifiedShipmentInstructions:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationReports];
    [lblStatus_SynchShipmentInstructions setText:info];
    _synchInProgressShipmentInstructions= NO;
    [activity_SynchShipmentInstructions stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchShipmentInstructions = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationShipmentInstructions];
}


- (IBAction)synchRepairMasterData:(id)sender {
    
    [self synchApplicationData:sender];
    [self synchWarehouse:sender];
    [self synchReports:sender];
    sleep(1);
    //synch the master data of repair
    RepairMasterDataSynch* controller = [SDRestKitEngine sharedRepairMasterDataController];
    if (!_synchInProcessRepairMasterData) {
        _synchInProcessRepairMasterData = YES;
        //[activity_SynchRepairMasterData startAnimating];
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:activity_SynchRepairMasterData];
        sleep(1);
        [lblStatus_SynchRepairMasterData setText:@""];        
        //add observer
        [controller addNotificationObserver:self notificationName:kNotificationRepairMasterData  selector:@selector(synchNotifiedRepairMasterData:)];
//Restful requires the synch run in the main thread. RepairMasterDataSynch has already forked the extra threads.
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [controller load];
//        });
        [controller load];
    }
    
}

-(void)synchNotifiedRepairMasterData:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:@"Repair Master Data"];
    [lblStatus_SynchRepairMasterData setText:info];
    _synchInProcessRepairMasterData= NO;
    [activity_SynchRepairMasterData stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchRepairMasterData = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationRepairMasterData];
}


- (IBAction)clearLocalDatabase:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear Database Confirmation" message:@"Are you sure you want to clear the database? Once deleted, you will not be able to recover all the transaction data. After deletion, you will be logout of this application..." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[SDDataEngine sharedEngine] performSelector:@selector(clearDatabase:) withObject:nil afterDelay:0];
        //[[SDDataEngine sharedEngine] clearDatabase];
        exit(0);
    }
}


-(void) threadStartAnimating:(UIActivityIndicatorView*) indicator
{
    [indicator startAnimating];

}






@end
