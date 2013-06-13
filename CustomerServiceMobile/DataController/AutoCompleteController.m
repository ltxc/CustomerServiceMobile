

#import "AutoCompleteController.h"
#import "AutoCompleteField.h"
#import <QuartzCore/QuartzCore.h> 

@interface AutoCompleteController ()

@end

@implementation AutoCompleteController
@synthesize autoCompleteDelegate=_autoCompleteDelegate;
@synthesize defaultValue=_defaultValue;
@synthesize autoCompleteTitle=_autoCompleteTitle;
CGRect _realBounds;
NSMutableArray* _autoCompletes;
NSArray* _objects;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
       //self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    _realBounds = self.view.bounds;    
    _autoCompletes = [[NSMutableArray alloc] init];
    [super viewDidLoad];

    

    if(nil!=self.autoCompleteTitle)
       self.lblTitle.text = self.autoCompleteTitle;
    if(nil==self.defaultValue)
    {
        self.defaultValue = @"";
    }
    self.txtSearch.text = self.defaultValue;
    _objects = [self.autoCompleteDelegate objects];
    [self searchAutocompleteEntriesWithSubstring:@""];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    
    self.tableView.layer.cornerRadius = 5.0;
    self.searchView.layer.cornerRadius = 5.0;
    
}

-(void)addShadow:(CALayer*) layer

{
    
    layer.shadowColor = [UIColor blackColor].CGColor;
    
    layer.shadowOpacity = 1.0;
    
    layer.shadowOffset = CGSizeMake(0,3);
    
    layer.cornerRadius = 5.0;
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
     
    [super viewWillAppear:animated];
    [self.searchView setCenter:self.view.center];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancel:(id)sender {
    [self.autoCompleteDelegate selected:nil status:NO];

}


- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {

    [_autoCompletes removeAllObjects];
    for(id object in _objects) {
        NSString* display = [self.autoCompleteDelegate display:object];
        if(nil==display)
        {
            continue;
        }
        AutoCompleteField* field = [[AutoCompleteField alloc]init];
        field.display = display;
        field.value = object;
        if(nil==substring||[substring isEqualToString:@""])
        {            
            [_autoCompletes addObject:field];
        }
        else
        {
            NSRange substringRange = [display rangeOfString:substring options:NSCaseInsensitiveSearch];
            if (substringRange.location == 0) {
                [_autoCompletes addObject:field];
            }

        }
    }
    [self.tableView reloadData];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *substring = [NSString stringWithString:self.txtSearch.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return _autoCompletes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }

    cell.textLabel.text = [(AutoCompleteField*)[_autoCompletes objectAtIndex:indexPath.row] display];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];

}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    //NSString* selected = selectedCell.textLabel.text;
    id selected = [(AutoCompleteField*)[_autoCompletes objectAtIndex:indexPath.row] value];
    [self.autoCompleteDelegate selected:selected status:YES];
}

@end
