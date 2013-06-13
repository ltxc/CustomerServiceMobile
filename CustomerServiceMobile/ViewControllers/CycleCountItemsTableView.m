
#import "CycleCountItemsTableView.h"
#import "CycleCountItemsCellView.h"
#import "CycleCountCount.h"
#import "SharedConstants.h"

@implementation CycleCountItemsTableView
@synthesize cycleCountMaster=_cycleCountMaster;
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
    if(nil!=self.cycleCountMaster)
    {
        NSOrderedSet* items = self.cycleCountMaster.counts;
        if(nil!=items)
            rowCount = [items count];
    }
    return rowCount;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdnetifier = @"itemcell";

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
    CycleCountCount* count = [self.cycleCountMaster.counts objectAtIndex:indexPath.row];
    

    CycleCountItemsCellView* countCell = (CycleCountItemsCellView*)cell;
    countCell.lblBinCode.text = self.cycleCountMaster.bin_code_id;
    countCell.lblQty.text = count.qty;
    if([kCycleCountTypeBin isEqualToString:self.cycleCountMaster.cycle_type])
    {
        //bin count
        countCell.lblBPart.text = count.target;
    }
    else
    {
        //part count
        countCell.lblBPart.text = self.cycleCountMaster.bpart_id;
        countCell.lblSerialNo.text = count.target;
    }
   
    
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
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
        [self.deleteDelegate deleteItem:indexPath.row];
}


@end
