
#import "DataSynchController.h"
#import "SharedConstants.h"

@interface ApplicationDataSynchController : DataSynchController<SynchController,RKObjectLoaderDelegate>
@property (weak, nonatomic, readonly) NSArray* appicationdata;
@end
