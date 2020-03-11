//
//  DXNestCollectionTitleCell.h
//  DXNestCollectionDemo
//
//  Created by 邓星 on 2020/3/11.
//  Copyright © 2020 邓星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountLabelButton.h"

@interface DXNestCollectionTitleCell : UICollectionViewCell

/**
 显示label
 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) CountLabelButton *contentLabel;

/**
 是否已选中
 */
@property (nonatomic, assign, readonly) BOOL didSelect;

@property (nonatomic, strong) UIColor *titleColorSelect;
@property (nonatomic, strong) UIColor *titleColorNormal;
@property (nonatomic, strong) UIFont *titleFontNormal;
@property (nonatomic, strong) UIFont *titleFontSelect;

/**
 是否显示提示红点(默认不显示)
 */
@property (nonatomic, assign) BOOL ifNeedShowPrompt;

/**
 提示红点颜色(默认红色)
 */
@property (nonatomic, strong) UIColor *promptTagColor;


/**
 选中
 */
- (void)didSelectCell;

/**
 取消选中
 */
- (void)didUnSelectCell;

@end


