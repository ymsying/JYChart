//
//  SYPFilterListViewCell.m
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/8.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPFilterListViewCell.h"
#import "SYPConstantColor.h"

@implementation SYPFilterListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.tintColor = SYPColor_LineColor_Blue;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
