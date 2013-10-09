//
//  DynamicaTextInputView.m
//  SFCMobile
//
//  Created by Jinsong Lu on 9/12/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSDynamicTextInputView.h"

@implementation ZSDynamicTextInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(UILabel *)getTitle
{
    return self.lblTitle;
}
-(UITextField *)getUITextField
{
    return self.txtValue;
}

-(UISwitch *)getUISwitch
{
    return nil;
}
-(void)resignMyFirstRepond
{
    [self.txtValue resignFirstResponder];
}
@end
