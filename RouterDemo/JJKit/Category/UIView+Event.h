//
//  UIView+Event.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);
typedef void (^GestureActionDoubleBlock)(UIGestureRecognizer *gestureRecoginzer);

typedef enum : NSUInteger {
    ViewLayerTop,
    ViewLayerLeft,
    ViewLayerBottom,
    ViewLayerRight,
} ViewLayer;

@interface UIView (Event)


@property (readonly) UIViewController *viewController;

#pragma mark - BlockGesture
- (void)addTapActionWithBlock:(GestureActionBlock)block;
- (void)addLongPressActionWithBlock:(GestureActionBlock)block;
- (void)addTapActionWithBlock:(GestureActionBlock)block andDoubleBlock:(GestureActionDoubleBlock)doubleBlock;

#pragma mark frame
// shortcuts for frame properties
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;


@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat left;

/**
 *  相当于left/top
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

/**
 切割圆角
 */
+ (void)cutCornersWithView:(UIView *)view cornersRadius:(CGFloat)radius;

//递归得到所有的subview（不仅仅是子视图）
- (NSMutableArray*)allSubViews;
/**
 *  添加到某个view，并且当作他的子视图
 *
 *  @param parentView parentView description
 *
 *  @return <#return value description#>
 */
- (instancetype)addTo: (UIView*)parentView;

/**
 *  在宽度一定的情况下得到高度(UIlabel高度计算)
 *
 *  @param width 期望的宽度
 *
 *  @return 高度
 */
- (CGFloat)heightWithWidth:(CGFloat)width;

/**
 *  添加动态效果，点击效果
 *  by ik
 */
- (void)performShakeAnimation:(UIView *)targetView;

/**
 删除所有子控件
 */
- (void)removeAllSubViews;
@end
