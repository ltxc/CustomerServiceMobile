//
//  QueriesSynchController.h
//  CustomerServiceMobile
//
#import "DataSynchController.h"

@interface QueriesSynchController : DataSynchController<RKObjectLoaderDelegate>
@property (weak,readonly, nonatomic) NSArray* queries;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end
