//
//  AutoCompleteController.h
//
//  Created by Jinsong Lu on 12/6/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
//delegate that provides the search result, how to display and what to do after user finish the autocomplete view.
@protocol ZSAutoCompleteDelegate <NSObject>
@required
-(void)selected:(id)value status:(BOOL)status;
-(NSString*) display:(id)object;
-(NSArray*) objects;
@end

@interface ZSAutoCompleteController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) NSString* autoCompleteTitle;
@property (strong, nonatomic) NSString* defaultValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id<ZSAutoCompleteDelegate> autoCompleteDelegate;
- (IBAction)btnCancel:(id)sender;
@end
