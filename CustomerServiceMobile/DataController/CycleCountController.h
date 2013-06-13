
#import "DataSynchController.h"
#import "CycleCountMaster.h"
@interface CycleCountController : DataSynchController
@property (nonatomic) BOOL isBinCount;
-(BOOL)post:(CycleCountMaster*)cycleCountMaster;
-(RKObjectMapping *) cycleCountMapping;

@end
