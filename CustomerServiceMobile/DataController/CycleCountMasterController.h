

#import "DataSynchController.h"

@interface CycleCountMasterController : DataSynchController
@property (weak,readonly, nonatomic) NSArray* cycleCountMasters;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end
