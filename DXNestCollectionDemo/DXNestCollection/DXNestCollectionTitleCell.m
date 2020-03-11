//
//  DXNestCollectionTitleCell.m
//  DXNestCollectionDemo
//
//  Created by 邓星 on 2020/3/11.
//  Copyright © 2020 邓星. All rights reserved.
//

#import "DXNestCollectionTitleCell.h"

@interface DXNestCollectionTitleCell ()
@property (nonatomic, strong) UIView *promptPoint;
@end

@implementation DXNestCollectionTitleCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleColorNormal = [UIColor blackColor];
        _titleColorSelect = [UIColor orangeColor];
        _titleFontNormal = [UIFont systemFontOfSize:16];
        _titleFontSelect = [UIFont systemFontOfSize:21];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = _titleFontNormal;
        _titleLabel.textColor = _titleColorNormal;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _contentLabel = [[CountLabelButton alloc] init];
        _contentLabel.textLabel.font = _titleFontNormal;
        _contentLabel.countLabel.font = [UIFont systemFontOfSize:_titleFontNormal.pointSize + 4];
        _contentLabel.textLabel.textColor = _titleColorNormal;
        _contentLabel.countLabel.textColor = _titleColorNormal;
        [self addSubview:_contentLabel];
        
        _promptPoint = [[UIView alloc] init];
        _promptPoint.hidden = YES;
        _promptPoint.layer.cornerRadius = 2;
        _promptPoint.layer.masksToBounds = YES;
        _promptPoint.backgroundColor = [UIColor redColor];
        [self addSubview:_promptPoint];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_promptPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-3);
        make.top.equalTo(self).offset(3);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
    
    [super updateConstraints];
}

- (void)didSelectCell {
    _didSelect = YES;
    if (!_titleLabel.hidden) {
        _titleLabel.font = _titleFontSelect;
        _titleLabel.textColor = _titleColorSelect;
    }
    if (!_contentLabel.hidden) {
        _contentLabel.textLabel.font = _titleFontSelect;
        _contentLabel.countLabel.font = [UIFont systemFontOfSize:_titleFontSelect.pointSize + 4];
        _contentLabel.textLabel.textColor = _titleColorSelect;
        _contentLabel.countLabel.textColor = _titleColorSelect;
    }
}

- (void)didUnSelectCell {
    _didSelect = NO;
    if (!_titleLabel.hidden) {
        _titleLabel.font = _titleFontNormal;
        _titleLabel.textColor = _titleColorNormal;
    }
    if (!_contentLabel.hidden) {
        _contentLabel.textLabel.font = _titleFontNormal;
        _contentLabel.countLabel.font = [UIFont systemFontOfSize:_titleFontNormal.pointSize + 4];
        _contentLabel.textLabel.textColor = _titleColorNormal;
        _contentLabel.countLabel.textColor = _titleColorNormal;
    }
}

- (void)setTitleColorNormal:(UIColor *)titleColorNormal {
    if (titleColorNormal) {
        _titleColorNormal = titleColorNormal;
    }
}

- (void)setTitleFontNormal:(UIFont *)titleFontNormal {
    if (titleFontNormal) {
        _titleFontNormal = titleFontNormal;
    }
}

- (void)setTitleColorSelect:(UIColor *)titleColorSelect {
    if (titleColorSelect) {
        _titleColorSelect = titleColorSelect;
    }
}

- (void)setTitleFontSelect:(UIFont *)titleFontSelect {
    if (titleFontSelect) {
        _titleFontSelect = titleFontSelect;
    }
}

-(void)setPromptTagColor:(UIColor *)promptTagColor {
    if (promptTagColor) {
        _promptTagColor = promptTagColor;
        _promptPoint.backgroundColor = _promptTagColor;
    }
}

- (void)setIfNeedShowPrompt:(BOOL)ifNeedShowPrompt {
    _ifNeedShowPrompt = ifNeedShowPrompt;
    _promptPoint.hidden = !_ifNeedShowPrompt;
}


@end
