//
//  DPCardCell.m
//  XPTableDeleteButtonCustom
//
//  Created by Chance on 2017/6/26.
//  Copyright © 2017年 Chance. All rights reserved.
//

#import "DPCardCell.h"

@interface DPCardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UILabel *numberLB;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation DPCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [super insertSubview:view atIndex:index];
    
    if ([view isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
        view.top = 10;
        view.height = self.height - 10;
        
        UIButton *btn = view.subviews.firstObject;
        [btn setBackgroundColor:[UIColor orangeColor]];
        
        [btn setTitle:nil forState:UIControlStateNormal];
        
        UIImage *img = [image_name(@"del") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [btn setImage:img forState:UIControlStateNormal];
        [btn setImage:img forState:UIControlStateHighlighted];
        
        [btn setTintColor:[UIColor whiteColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadModel:(id)model {
    self.titleLB.text = @"test";
    self.nameLB.text = @"简了个书1993";
    self.typeLB.text = @"普通卡";
    self.numberLB.text = @"13312";
}

@end
