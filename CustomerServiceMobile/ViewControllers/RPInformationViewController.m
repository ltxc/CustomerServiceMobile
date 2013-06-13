

#import "RPInformationViewController.h"

@interface RPInformationViewController ()

@end

@implementation RPInformationViewController
@synthesize rpInformation=_rpInformation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //display now
    if(nil!=self.rpInformation)
    {
        self.lblContract.text = _rpInformation.cconth_id;
        self.lblDestWarehouseID.text = _rpInformation.dest_warehouse_id;
        self.lblPO.text = _rpInformation.po_id;
        self.lblPriority.text = _rpInformation.priority;
        self.lblProblemCode.text = _rpInformation.pcode_id;
        self.lblWarranty.text = _rpInformation.warr_type_id;
        
    }
    else
    {
        self.lblContract.text = @"";
        self.lblDestWarehouseID.text = @"";
        self.lblPO.text = @"";
        self.lblPriority.text = @"";
        self.lblProblemCode.text = @"";
        self.lblWarranty.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOK:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
