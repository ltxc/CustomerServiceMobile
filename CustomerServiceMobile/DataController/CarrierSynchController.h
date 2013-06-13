//
//  CarrierSynchController.h
//  CustomerServiceMobile
//
#import "DataSynchController.h"

@interface CarrierSynchController : DataSynchController<RKObjectLoaderDelegate>
@property (weak,readonly, nonatomic) NSArray* carriers;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end
