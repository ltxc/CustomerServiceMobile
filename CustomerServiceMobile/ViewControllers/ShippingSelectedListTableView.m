

#import "ShippingSelectedListTableView.h"
#import "ShippingListCellView.h"
#import "ShippingLineItem.h"
#import "SharedConstants.h"
#import "SDUserPreference.h"

@implementation ShippingSelectedListTableView
@synthesize transaction_type=_transaction_type;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    if(nil!=self.deleteDelegate.shippingHeader)
    {
        NSOrderedSet* lineitems = self.deleteDelegate.shippingHeader.shippingLineItems;
        if(nil!=lineitems)
            rowCount = [lineitems count];
    }
    return rowCount;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdnetifier = @"SelectedListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdnetifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ShippingLineItem* t = [self.deleteDelegate.shippingHeader.shippingLineItems objectAtIndex:indexPath.row];
    ShippingListCellView* listcell = (ShippingListCellView*)cell;

    if ([t.ldmnd_stat_id isEqualToString:kShippingTypePickStatID]||[t.ldmnd_stat_id isEqualToString:kShippingTypePickListOpenStatID]) {
        listcell.imgPicker.hidden = YES;
    }
    else
    {
        listcell.imgPicker.hidden = NO;
    }
    if([self.transaction_type isEqualToString:FormatShippingTypeName[PICK]]||[self.transaction_type isEqualToString:FormatShippingTypeName[ALLOCATEDSHIPLIST]])
    {
       listcell.lblOriginalDocID.text = t.orig_doc_id;
    }
    else
    {        
        listcell.lblOriginalDocID.text = t.pi_doc_id;
    }

    listcell.lblBin.text = t.fr_bin_code_id;
    listcell.lblPartNumber.text = t.bpart_id;
    listcell.lblSerialNo.text = t.serial_no;
    listcell.lblPriority.text = t.priority;    
    listcell.lblDueDate.text = [[SDUserPreference sharedUserPreference].dateFormatter stringFromDate:t.due_date];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //may call to get read only version of Shipping List Value. Implementation only when required.
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
        [self.deleteDelegate deleteLineItem:indexPath.row];
}

@end
