
#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CoreDataSynch.h"
#import "ApplicationDataSynchController.h"
#import "UserProfileController.h"
#import "WarehouseSynchController.h"
#import "CompanySynchController.h"
#import "CarrierSynchController.h"
#import "BinPartSynchController.h"
#import "QueriesSynchController.h"
#import "ManAdjustReasonController.h"
#import "InventoryTransactionController.h"
#import "CycleCountMasterController.h"
#import "CycleCountController.h"
#import "ShippingListSynchController.h"
#import "ShippingTransactionController.h"
#import "RPInformationController.h"
#import "ShipmentInstructionsSynchController.h"
#import "ProcessResultController.h"

@interface SDRestKitEngine : NSObject


@property (strong,atomic) RKObjectManager* objectManager;
@property (strong,atomic) NSString* username;
@property (strong,atomic) NSString* password;
@property (strong, nonatomic) UIAlertView *alert;
+(SDRestKitEngine *) sharedEngine;

//+(ApplicationDataSynchController *) sharedApplicationDataController;
+(CoreDataSynch *) sharedApplicationDataController;
+(UserProfileController *) sharedUserProfileController;
//+(WarehouseSynchController *) sharedWarehouseController;
+(CoreDataSynch *) sharedWarehouseController;
//+(CompanySynchController *) sharedCompanyController;
+(CoreDataSynch *) sharedCompanyController;
//+(CarrierSynchController *) sharedCarrierController;
+(CoreDataSynch *) sharedCarrierController;
//+(BinPartSynchController *) sharedBinPartController;
+(CoreDataSynch *) sharedBinPartController;
//+(QueriesSynchController *) sharedQueriesController;
+(CoreDataSynch *) sharedQueriesController;
//+(ShipmentInstructionsSynchController *) sharedShipmentInstructionsController;
+(CoreDataSynch *) sharedShipmentInstructionsController;
//+(ManAdjustReasonController *) sharedReasonController;
+(CoreDataSynch *) sharedReasonController;


+(InventoryTransactionController*) sharedInventoryTransactionController;
+(InventoryTransactionController*) sharedMISCInventoryTransactionController;
+(CycleCountMasterController*) sharedCycleCountMasterController;
+(CycleCountController*) sharedCycleCountController;
+(ShippingListSynchController*) sharedShippingListController;
+(ShippingTransactionController*) sharedShippingController;
+(RPInformationController*) sharedRPInformationController;
+(ProcessResultController*) sharedProcessResultController;

-(SDRestKitEngine *) setAuthentication:(NSString*) username password:(NSString *) password;
-(void)alert:(NSString*) message title:(NSString*) title;

-(void)notify:(NSString*) notificationName status:(NSNumber*) status message:(NSString*) message object:(id) object;
-(void)addNotificationObserver:(id) observer notificationName:(NSString*)notificationName selector:(SEL)selector;
-(void)removeNotificationObserver:(id) observer notificationName:(NSString*)notificationName;
-(NSNumber*) getNotificationStatus:(NSNotification *)notification;
-(NSString*)getNofiticationInfo:(NSNotification *)notification actionname:(NSString*) actionName;
@end
