//
//  DynamicSwitchInputView.m
//  SFCMobile
//
//  Created by Jinsong Lu on 9/12/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSDynamicSwitchView.h"

@implementation ZSDynamicSwitchView
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
    return nil;
}

-(UISwitch *)getUISwitch
{
    return self.switchSelect;
}

-(void)resignMyFirstRepond
{

}
@end
