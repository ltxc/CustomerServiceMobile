

#import <Foundation/Foundation.h>

@interface ProcessResult : NSObject
-(ProcessResult*)init;

@property (strong,nonatomic) NSString* transactionType;
@property (strong,nonatomic) NSString* transactionId;
@property (strong,nonatomic) NSString* process_status;
@property (strong,nonatomic) NSString* process_message;
@property (strong,nonatomic) NSDate* process_date;
@end
