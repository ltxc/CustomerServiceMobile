//
//  AutoCompleteDataHelper.h
//  CustomerServiceMobile


#import <Foundation/Foundation.h>
#import "ZSAutoCompleteController.h"

#pragma mark - Blocks
//call back block when user finish using the autocomplete view.
typedef void(^ZSAutoCompleteBlock)(BOOL,id);
//return display string
typedef NSString*(^ZSAutoCompleteDisplayBlock)(id);
//input search search, return search results
typedef NSArray*(^ZSAutoCompleteDataBlock)(NSString*);

@interface ZSAutoCompleteDataHelper : NSObject <ZSAutoCompleteDelegate>

@property (strong, nonatomic) NSString* entityName;

-(ZSAutoCompleteDataHelper*)initWithEntityName:(NSString*) entityName withDisplayBlock:(ZSAutoCompleteDisplayBlock)displayBlock  withBlock:(ZSAutoCompleteBlock)block;
-(ZSAutoCompleteDataHelper*)initWithEntityName:(NSString*) entityName withDisplayBlock:(ZSAutoCompleteDisplayBlock)displayBlock withBlock:(ZSAutoCompleteBlock)block withData:(ZSAutoCompleteDataBlock)dataBlock ;
//@property (weak, nonatomic) NSString* template;
//@property (weak, nonatomic) NSString* value;
@property (weak, nonatomic)NSPredicate* predicate;
@property (readonly,nonatomic) NSMutableArray* sortDescriptors;

-(void)addSortDescript:(NSString*)key ascending:(BOOL)ascending;
-(void)setPredicateWithTemplate:(NSString*)template value:(NSString*)value;
@end
