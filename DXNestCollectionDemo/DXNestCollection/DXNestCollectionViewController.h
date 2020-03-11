//
//  DXNestCollectionViewController.h
//  DXNestCollectionDemo
//
//  Created by 邓星 on 2020/3/11.
//  Copyright © 2020 邓星. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DXNestState) {
    DXNestStateNormol = 0, //常态
    DXNestStateSelect,  //选中态
};

@class DXNestCollectionViewController;
@protocol DXNestCollectionViewControllerDelegate <NSObject>

/**
 设置上方标题文字

 @return 标题文字数组
 */
- (NSArray <__kindof NSString*> *)nestCollectTitleStringsInController:(DXNestCollectionViewController *)nestCollectionVC;

/**
 设置下方内容视图

 @return 内容视图控制器数组
 */
- (NSArray <__kindof UIViewController*> *)nestCollectControllersInController:(DXNestCollectionViewController *)nestCollectionVC;

@optional

/**
 内容视图将要显示

 @param nestCollectionVC self
 @param viewController 内容视图控制器
 @param index 将要显示的索引
 */
- (void)nestCollectViewController:(DXNestCollectionViewController *)nestCollectionVC willAppearViewController:(UIViewController *)viewController formIndex:(NSInteger)index;

/**
 内容视图将要消失

 @param nestCollectionVC self
 @param viewController 内容视图控制器
 @param index 将要消失的索引
 */
- (void)nestCollectViewController:(DXNestCollectionViewController *)nestCollectionVC willDisAppearViewController:(UIViewController *)viewController formIndex:(NSInteger)index;

/**
 内容视图已经消失

 @param nestCollectionVC self
 @param viewController 内容视图控制器
 @param index 已经消失的索引
 */
- (void)nestCollectViewController:(DXNestCollectionViewController *)nestCollectionVC didDisAppearViewController:(UIViewController *)viewController formIndex:(NSInteger)index;

@end

@interface DXNestCollectionViewController : UIViewController

/**
 创建方式

 @param delegate 代理
 @return nestController
 */
+ (DXNestCollectionViewController *)creatNestControllerWithDelegate:(id)delegate;

/**
 当前显示索引
 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/**
 标题文字控件尺寸(默认(80,60))
 */
@property (nonatomic, assign) CGSize titleCollectionSize;
/**
 内容文字控件尺寸(默认(屏幕宽,300))
 */
@property (nonatomic, assign) CGSize contentCollectionSize;
/**
 title背景色(默认白色)
 */
@property (nonatomic, strong) UIColor *titleBackColor;

/**
 选中横条尺寸
 */
@property (nonatomic, assign) CGSize selectLineSize;

/**
 选中横线颜色(默认红色)
 */
@property (nonatomic, strong) UIColor *selectLineColor;

/**
 选中横线背景颜色(默认高亮灰)
 */
@property (nonatomic, strong) UIColor *selectBackLineColor;

/**
 是否显示选中横线(默认显示)
 */
@property (nonatomic, assign) BOOL showSelectLine;

/**
 是否显示选中横线背景(默认不显示)
 */
@property (nonatomic, assign) BOOL showSelectBackLine;

/**
 自动调节title长度(默认不开启, YES时 titleCollectionSize.width 和 selectLineSize.width 失效)
 */
@property (nonatomic, assign) BOOL autoJuestTitleWidth;

/**
 title间隔距离(默认 10, autoJuestTitleWidth = YES 时有效)
 */
@property (nonatomic, assign) CGFloat titleSpace;

/**
 是否支持内容滑动(默认支持)
 */
@property (nonatomic, assign) BOOL contentScroller;

/**
 标题提示点颜色(默认红色)
 */
@property (nonatomic, strong) UIColor *titlePromptColor;

/**
 标题提示点是否显示数组(@0不显示,其他显示, 默认@0)
 */
@property (nonatomic, copy) NSArray *titlePromptTagArray;

/**
 title右侧空出的视图
 */
@property (nonatomic, strong) UIView *titleRightView;

/**
 titleRightView 的尺寸
 */
@property (nonatomic, assign) CGSize titleRightViewSize;

/**
 titleRightView 左右间距 默认10
 */
@property (nonatomic, assign) CGFloat titleRightViewSpace;

/**
autoHiddenRightView 根据title数量自动隐藏rightView
*/
@property (nonatomic, assign) BOOL autoHiddenRightView;

/**
autoHiddenRightViewNum 自动隐藏rightView的数量阀值
*/
@property (nonatomic, assign) NSInteger autoHiddenRightViewNum;

/**
 刷新数据源
 */
- (void)reloadData;

/**
 设置title文本颜色

 @param color 文本颜色
 @param state 状态
 */
- (void)setTitleTextColor:(UIColor *)color forState:(DXNestState)state;

/**
 设置title字体

 @param font 字体
 @param state 状态
 */
- (void)setTitleTextFont:(UIFont *)font forState:(DXNestState)state;

/**
 刷新选中索引并且刷新数据源
 */
- (void)reloadSelectIndexAndData;

- (void)gotoLastIndex;

/// 内容聚焦到index索引下
/// @param index 需要聚焦呈现的索引
- (void)changeContentToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
