

#import "ZSCalculatorViewController.h"

@interface ZSCalculatorViewController ()
@property (strong,nonatomic) NSMutableString* result;
@property (nonatomic) NSInteger value;
@property (nonatomic) enum ZSCalculatorOperator operator;
@end

@implementation ZSCalculatorViewController
@synthesize result=_result;
@synthesize value=_value;
@synthesize operator=_operator;
CGRect _realBounds;

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
    _realBounds = self.view.bounds;
    
	[self reset];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.superview.bounds = _realBounds;
   
    //self.presentingViewController.contentSizeForViewInPopover =_realBounds.size;
    self.lblResult.text = [_result copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)reset
{
    _value = INT_MIN;
    _result = [NSMutableString stringWithString:@""];
    _operator = NONE;
    
}

-(void)calculate:(enum ZSCalculatorOperator) prevOperator newOperation:(enum ZSCalculatorOperator)newOperator
{
    NSInteger newValue = 0;
    if(![_result isEqualToString:@""])
    {
        //do the calculation
        switch(prevOperator)
        {
            case PLUS:
                newValue= [_result integerValue];
                _value = _value + newValue;
                break;
            case MINUS:
                newValue = [_result integerValue];
                _value = _value - newValue;
                break;
            case TIME:
//                newValue = [_result integerValue];
//                _value = _value * newValue;

//                _result = [NSMutableString stringWithFormat:@"%d",_value];
                break;
            case DIVIDE:break;
            case NONE:
                _value = [_result intValue];                
                break;
            default:break;
                    };
        _result = [NSMutableString stringWithString:@""];
        self.operator = newOperator;
        [self displayResult:YES];

    }
    else
    {
        self.operator = newOperator;
    }
}



-(void)displayResult:(BOOL)showValue
{
    if(showValue&&_value>INT_MIN)
    {
        self.lblValue.text = [[NSMutableString stringWithFormat:@"%d",_value] copy];
    }
    else
        self.lblValue.text = @"";
    self.lblResult.text = [_result copy];
}

- (IBAction)btnOK:(id)sender {
    [[self delegate]setResult:self.lblValue.text status:YES];
}

- (IBAction)btnCancel:(id)sender {
    [[self delegate]setResult:self.lblValue.text status:NO];
}

- (IBAction)btn7:(id)sender {
    [_result appendString:@"7"];
    [self displayResult:YES];
}

- (IBAction)btn8:(id)sender {
    [_result appendString:@"8"];
    [self displayResult:YES];
}

- (IBAction)btn9:(id)sender {
    [_result appendString:@"9"];
    [self displayResult:YES];
}

- (IBAction)btn4:(id)sender {
    [_result appendString:@"4"];
    [self displayResult:YES];
}

- (IBAction)btn5:(id)sender {
    [_result appendString:@"5"];
    [self displayResult:YES];
}

- (IBAction)btn6:(id)sender {
    [_result appendString:@"6"];
    [self displayResult:YES];
}

- (IBAction)btn1:(id)sender {
    [_result appendString:@"1"];
    [self displayResult:YES];
}

- (IBAction)btn2:(id)sender {
    [_result appendString:@"2"];
    [self displayResult:YES];
}

- (IBAction)btn3:(id)sender {
    [_result appendString:@"3"];
    [self displayResult:YES];
}

- (IBAction)btn0:(id)sender {
    [_result appendString:@"0"];
    [self displayResult:YES];
}

- (IBAction)btnCE:(id)sender {
    _result = [NSMutableString stringWithString:@""];
    [self displayResult:YES];
}

- (IBAction)btnC:(id)sender {
    [self reset];
    [self displayResult:NO];
}



- (IBAction)btnDel:(id)sender {
    //remove the last character
    if([_result length]>0)
    {
        [_result deleteCharactersInRange:NSMakeRange([_result length]-1, 1)];
        [self displayResult:YES];
    }
}

- (IBAction)btnPlus:(id)sender {
    [self calculate:[self operator] newOperation:PLUS];
}


-(void)btnMinus:(id)sender
{
    [self calculate:[self operator] newOperation:MINUS];
}

-(void)btnEqual:(id)sender
{
    [self calculate:[self operator] newOperation:NONE];
    [self displayResult:YES];
}

@end
