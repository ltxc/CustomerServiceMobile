

#import <UIKit/UIKit.h>
@protocol CalculatorDelegate <NSObject>
@required
-(void)setResult: (NSString*)result status:(BOOL)status;
@end

enum calculatorOperator: NSInteger
{
    NONE = 0,
    PLUS = 1,
    MINUS = 2,
    TIME = 3,
    DIVIDE = 4,
    EQUAL=5
};

@interface CalculatorViewController : UIViewController 
    
@property (weak,nonatomic) IBOutlet UILabel *lblValue;
@property (weak,nonatomic) id<CalculatorDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblResult;

- (IBAction)btnOK:(id)sender;
- (IBAction)btnCancel:(id)sender;

- (IBAction)btn7:(id)sender;
- (IBAction)btn8:(id)sender;
- (IBAction)btn9:(id)sender;
- (IBAction)btn4:(id)sender;
- (IBAction)btn5:(id)sender;
- (IBAction)btn6:(id)sender;
- (IBAction)btn1:(id)sender;
- (IBAction)btn2:(id)sender;
- (IBAction)btn3:(id)sender;
- (IBAction)btn0:(id)sender;
- (IBAction)btnCE:(id)sender;
- (IBAction)btnC:(id)sender;
- (IBAction)btnDel:(id)sender;

- (IBAction)btnPlus:(id)sender;
- (IBAction)btnMinus:(id)sender;
- (IBAction)btnEqual:(id)sender;

@end
