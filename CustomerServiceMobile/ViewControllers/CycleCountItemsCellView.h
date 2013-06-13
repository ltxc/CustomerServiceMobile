//
//  CycleCountItemsCellView.h
//  CustomerServiceMobile
//
//  Created by LTXC on 1/9/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleCountItemsCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblBinCode;
@property (weak, nonatomic) IBOutlet UILabel *lblBPart;
@property (weak, nonatomic) IBOutlet UILabel *lblSerialNo;
@property (weak, nonatomic) IBOutlet UILabel *lblQty;

@end
