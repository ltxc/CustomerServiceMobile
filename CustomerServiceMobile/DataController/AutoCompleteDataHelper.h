//
//  AutoCompleteDataHelper.h
//  CustomerServiceMobile


#import <Foundation/Foundation.h>
#import "AutoCompleteController.h"

#pragma mark - Blocks
//call back block when user finish using the autocomplete view.
typedef void(^AutoCompleteBlock)(BOOL,id);
//return display string
typedef NSString*(^AutoCompleteDisplayBlock)(id);
//input search search, return search results
typedef NSArray*(^AutoCompleteDataBlock)(NSString*);

@interface AutoCompleteDataHelper : NSObject <AutoCompleteDelegate>

@property (strong, nonatomic) NSString* entityName;

-(AutoCompleteDataHelper*)initWithEntityName:(NSString*) entityName withDisplayBlock:(AutoCompleteDisplayBlock)displayBlock  withBlock:(AutoCompleteBlock)block;
-(AutoCompleteDataHelper*)initWithEntityName:(NSString*) entityName withDisplayBlock:(AutoCompleteDisplayBlock)displayBlock withData:(AutoCompleteDataBlock)dataBlock withBlock:(AutoCompleteBlock)block;
//@property (weak, nonatomic) NSString* template;
//@property (weak, nonatomic) NSString* value;
@property (weak, nonatomic)NSPredicate* predicate;
@property (readonly,nonatomic) NSMutableArray* sortDescriptors;

-(void)addSortDescript:(NSString*)key ascending:(BOOL)ascending;
-(void)setPredicateWithTemplate:(NSString*)template value:(NSString*)value;
@end
