

#import "DataSynchController.h"
#import "RPInformation.h"
@interface RPInformationController : DataSynchController
-(id)init;

-(RPInformation *)query:(NSString*)request_id;
-(RKObjectMapping *) entityMapping;

@end
