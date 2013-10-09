//
//  DynamicSwitchInputView.h
//  SFCMobile
//
//  Created by Jinsong Lu on 9/12/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSDynamicInput.h"
@interface ZSDynamicSwitchView : UIView<ZSDynamicInputViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UISwitch *switchSelect;

@end
