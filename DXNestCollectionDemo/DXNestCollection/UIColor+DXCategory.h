//
//  UIColor+DXCategory.h
//  DXNestCollectionDemo
//
//  Created by 邓星 on 2020/3/11.
//  Copyright © 2020 邓星. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DXCategory)

/**
 *  将16进制颜色如#FF0000，转换为UIColor
 *
 *  @param stringToConvert    16进制颜色如#FF0000
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end

NS_ASSUME_NONNULL_END
