

#import <Foundation/Foundation.h>

@interface CompanyProxy : NSObject
@property (nonatomic, retain) NSString * company_id;
-(CompanyProxy*)initWithID:(NSString*)company_id;
@end
