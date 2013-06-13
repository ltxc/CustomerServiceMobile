//
//  BinPartSynchController.h
//  CustomerServiceMobile
//
#import "DataSynchController.h"


@interface BinPartSynchController : DataSynchController<RKObjectLoaderDelegate>
@property (weak,readonly, nonatomic) NSArray* binparts;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end
