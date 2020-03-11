//
//  CountLabelButton.m
//  DXNestCollectionDemo
//
//  Created by 邓星 on 2020/3/11.
//  Copyright © 2020 邓星. All rights reserved.
//

#import "CountLabelButton.h"



@interface CountLabelButton ()

@property (nonatomic, strong) UIView *holdView;

@end


@implementation CountLabelButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    CountLabelButton *button = [super buttonWithType:buttonType];
    if (button) {
        button.userInteractionEnabled = NO;
        [button creatSubviews];
    }
    return button;
}

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
        [self creatSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        [self creatSubviews];
    }
    return self;
}

- (void)creatSubviews {
    if (_holdView) return;
    _holdView = [[UIView alloc] init];
    _holdView.userInteractionEnabled = NO;
    _holdView.backgroundColor = [UIColor clearColor];
    [self addSubview:_holdView];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont systemFontOfSize:18];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = HexColor(@"#E37409");
    [self addSubview:_countLabel];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = HexColor(@"#333232");
    _textLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_textLabel];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [_holdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countLabel.mas_top);
        make.bottom.equalTo(_textLabel.mas_bottom);
        make.centerY.equalTo(self);
        make.left.right.equalTo(self);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(ALDH(20));
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_countLabel.mas_bottom).offset(ALDH(3));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(ALDH(20));
    }];
    
    [super updateConstraints];
}

@end
