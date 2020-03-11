//
//  CountLabelButton.h
//  DXNestCollectionDemo
//
//  Created by 邓星 on 2020/3/11.
//  Copyright © 2020 邓星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountLabelButton : UIButton
/**
 数量
 */
@property (nonatomic, strong) UILabel *countLabel;
/**
 文本显示
 */
@property (nonatomic, strong) UILabel *textLabel;

@end
