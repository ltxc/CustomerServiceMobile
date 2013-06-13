
#import "ReceivingLineItemsTableView.h"
#import "ReceivingLineItemCellViewCell.h"
#import "InventoryLineItem.h"

@implementation ReceivingLineItemsTableView
@synthesize inventoryHeader=_inventoryHeader;
@synthesize deleteDelegate=_deleteDelegate;

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
    if(nil!=self.inventoryHeader)
    {
        NSOrderedSet* lineitems = self.inventoryHeader.inventoryLineItems;
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
    NSString* cellIdnetifier = @"lineitemcell";
//    if(indexPath.row%2==0)
//    {
//        cellIdnetifier=@"lineitemevencell";
//    }
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
    InventoryLineItem* item = [self.inventoryHeader.inventoryLineItems objectAtIndex:indexPath.row];
    ReceivingLineItemCellViewCell* receivingCell = (ReceivingLineItemCellViewCell*)cell;
    receivingCell.lblProduct.text = item.bpart_id;
    receivingCell.lblSerialNo.text = item.serial_no;
    receivingCell.lblQty.text=item.qty;
    receivingCell.lblBin.text=item.bin_code_id;
    receivingCell.lblReason.text=item.man_adj_reason_id;
    receivingCell.lblInvType.text=item.inv_type_id;
    receivingCell.lblCause.text = item.cause;
    
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
    //show edit view
    InventoryLineItem* item = [self.inventoryHeader.inventoryLineItems objectAtIndex:indexPath.row];
    [self.deleteDelegate editLineItem:item];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
        [self.deleteDelegate deleteLineItem:indexPath.row];
}


@end
