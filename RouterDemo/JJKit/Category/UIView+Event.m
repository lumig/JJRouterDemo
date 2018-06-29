//
//  UIView+Event.m
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "UIView+Event.h"
#import <objc/runtime.h>

static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;
static char kActionHandlerTapDoubleBlockKey;
static char kActionHandlerTapDoubleGestureKey;
static char kActionHandlerLongPressBlockKey;
static char kActionHandlerLongPressGestureKey;

@implementation UIView (Event)

- (UIViewController *)viewController {
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    
    return nil;
}

- (void)addTapActionWithBlock:(GestureActionBlock)block
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)addTapActionWithBlock:(GestureActionBlock)block andDoubleBlock:(GestureActionDoubleBlock)doubleBlock
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        gesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
    
    UITapGestureRecognizer *doubleGesture = objc_getAssociatedObject(self, &kActionHandlerTapDoubleGestureKey);
    if (!doubleGesture)
    {
        doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForDoubleTapGesture:)];
        doubleGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleGesture];
        objc_setAssociatedObject(self, &kActionHandlerTapDoubleGestureKey, doubleGesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapDoubleBlockKey, doubleBlock, OBJC_ASSOCIATION_COPY);
    //    [gesture requireGestureRecognizerToFail:doubleGesture];
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        GestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

- (void)handleActionForDoubleTapGesture:(UITapGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        GestureActionDoubleBlock block = objc_getAssociatedObject(self, &kActionHandlerTapDoubleBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

- (void)addLongPressActionWithBlock:(GestureActionBlock)block
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerLongPressGestureKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        GestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerLongPressBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

#pragma mark - Shortcuts for the coords

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)heightWithWidth:(CGFloat)width{
    return [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
}
#pragma mark - Shortcuts for frame properties

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
#pragma mark - Shortcuts for positions

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (instancetype)addTo: (UIView*)parentView{
    if (self && parentView) {
        [parentView addSubview:self];
    }
    return self;
}

- (NSMutableArray*)allSubViews
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:self];
    for (UIView *subview in self.subviews)
    {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    return arr;
}

/**
 *  添加动态效果，点击效果
 *
 *  @param 目标view
 */
- (void)performShakeAnimation:(UIView *)targetView {
    [targetView.layer removeAnimationForKey:@"anim"];
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5f;
    animation.values = @[[NSValue valueWithCATransform3D:targetView.layer.transform],
                         [NSValue valueWithCATransform3D:CATransform3DScale(targetView.layer.transform, 1.05, 1.05, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DScale(targetView.layer.transform, 0.95, 0.95, 1.0)],
                         [NSValue valueWithCATransform3D:targetView.layer.transform]
                         ];
    animation.removedOnCompletion = YES;
    [targetView.layer addAnimation:animation forKey:@"anim"];
}

- (void)removeAllSubViews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

+ (void)cutCornersWithView:(UIView *)view cornersRadius:(CGFloat)radius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

@end
