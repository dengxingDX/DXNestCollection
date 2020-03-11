//
//  DXNestCollectionVCCell.m
//  DXNestCollectionDemo
//
//  Created by 邓星 on 2020/3/11.
//  Copyright © 2020 邓星. All rights reserved.
//

#import "DXNestCollectionVCCell.h"

@implementation DXNestCollectionVCCell
- (void)setShowView:(UIView *)showView {
    if (_showView) {
        [_showView removeFromSuperview];
        _showView = nil;
    }
    _showView = showView;
    [self addSubview:_showView];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [_showView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
@end
