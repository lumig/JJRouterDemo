//
//  UIViewController+JJNavBar.m
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "UIViewController+JJNavBar.h"
#import <objc/runtime.h>
#import "JJMacro.h"
//#import <Aspects.h>

#define JJ_NAV_NAVIGATION_BAR_HEIGHT   44
#define STATUS_BAR_WIDTH ([UIApplication sharedApplication].statusBarFrame.size.width > 0 ? [UIApplication sharedApplication].statusBarFrame.size.width : [UIScreen mainScreen].bounds.size.width)

@interface UIViewController ()
@property (nonatomic, strong, readwrite) UILabel *jjNavTitleLabel;
@property (nonatomic, strong, readwrite) UIButton *jjNavBackBtn;

@end

@implementation UIView (JJNavBar)

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

@end

@implementation UIViewController (JJNavBar)

//+(void)load{
//    [self aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>info){
//        if([((UIViewController*)info.instance).navigationController.viewControllers containsObject:info.instance]){
////            NSLog(@"========== %@",info.instance);
////          NSLog(@"========== %@",((UIViewController*)info.instance).navigationController);
//            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//            [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        }
//    } error:NULL];
//}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(JJNavBar_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


- (void)JJNavBar_viewWillAppear:(BOOL)animated {
    if([self.navigationController.viewControllers containsObject:self]){
        //            NSLog(@"========== %@",self);
        //          NSLog(@"========== %@",self.navigationController);
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    [self JJNavBar_viewWillAppear:animated];
}


- (void)jjShowNavBar {
    
    CGFloat delta = (IS_HOTSPOT_CONNECTED?(iPhoneX?0:HOTSPOT_STATUSBAR_HEIGHT):0);
    
    self.jjNavBar.frame = CGRectMake(0, 0,STATUS_BAR_WIDTH, STATUS_AND_NAV_BAR_HEIGHT - delta);
    self.jjNavBackBtn.frame = CGRectMake(0, 0, JJ_NAV_NAVIGATION_BAR_HEIGHT, JJ_NAV_NAVIGATION_BAR_HEIGHT);
    self.jjNavTitleLabel.frame = CGRectMake(0, 0, STATUS_BAR_WIDTH, JJ_NAV_NAVIGATION_BAR_HEIGHT);
    self.jjNavBackBtn.bottom = self.jjNavBar.bottom;
    self.jjNavTitleLabel.bottom = self.jjNavBar.bottom;
    self.jjNavBar.hidden = NO;
}

- (void)jjShowNavBar:(NSString *)title {
    [self jjShowNavBar];
    self.jjNavTitle = title;
}

- (void)jjShowNavBar:(NSString *)title backBlock:(dispatch_block_t)backBlock {
    [self jjShowNavBar:title];
    self.jjNavBackBlock = backBlock;
}

- (void)jjHideNavBar {
    self.jjNavBar.hidden = YES;
    self.jjNavBar.frame = CGRectMake(0, 0,STATUS_BAR_WIDTH, 0);
}

- (void)jjInNavBack {
    if (self.jjNavBackBlock) {
        self.jjNavBackBlock();
    }else {
        //        [self.currentNav popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIImage *)jjInBackImage {
    NSString *image2 = @"iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAAEgBckRAAAAAXNSR0IArs4c6QAAAmhJREFUaAXtWUtOwzAQtVuOAWfojjuwoxISpNmjFonTIEHFvi2s4B4sKyT2cAxa49dmQhwSZ2znU6REKuPPzLx5E3viBCG4VxRN1R9d/iCZFlqwJkkplXF8c5l2qFE4SJOHIhGkNREUKFuRDCBZnrMG1PY2JAcHIIs4DMrigvJgMLgqmzfGocxeXU7Kk8n0Uxt8G3BVHRgcuFEVhX8+H0Wzc9w6G40j22TZHFbZdrt9EkIJKe3LU5Y5KRr/dSwE1v1icf9cpJcdYwH4OCYQKwByrNPwAmVuxOSYZOn2h8Jq9fCqxQZtnfMFpOtlZZB1luzXoR7brFZz9uJgAxCYK5AzgC8Q2fWyz4CZAVTSOJ6dmaNmz7qTTVWzh/2glDhWSj2aM2bPax+4bDZnABfn4OIE4OrcCcDHORvA1zkLIMR5JUCocwBU7QM8YPC4jCF9LisAnZhxRGEfiHNR7CLMjaXd9frtfTQ6/dC79QI/tDGWKjAaVgDYh4JUAoSCsABCQNgAviBOtQgguLJHSV3OxskBbT+Z+2tdpjndtItDLy1hKdVdOtE3+gz0GeggA151IjTOpM7ghW9XCKUUX8vl/MTHL/tFzsd53oYC14/fbAXfKCVv87rcfit3gALXQRmB46DC+RJhI9MogSYDJ1KNEGgj8EYItBl4rQS6CLwWAl0GHkwA3w7wek+OtNzUUVUy/lhNr/MoPCe1e/cVMkEa4msk7goLuSal4CrU9TIKJkCJ7IpIbQS6IlI7gbaJNEagLSKNE2iaSGsEbERC3ge8nwMUkKvE8Xn/DyU5RuD7n7x29dPr9xmoKQM/yJadGeRZ44AAAAAASUVORK5CYII=";
    NSString *image3 = @"iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAYAAAEi6oPRAAAAAXNSR0IArs4c6QAAA7hJREFUeAHtm7ty1DAUhm1PuPTJkFBRJfssUEGZpKEkzOQBqLJU0O8MoaRJtoQKniVJRUXCJD23idl/zNnVemRZks+xpUU7A9bK0tG3n21Zkp0sE/3s7r4oDw8P7zU24l2gUEPmef7l5ubPRzVPm97bO/iMf9qdaqZ1QbWScBqujE14F1iSaWxC3dnaHBW2LkgVhtsCtQk3t8Giyhsbd+5PJpOfujrGQDYBdEGX8hDE6jz/V8tIhEBlWT7GVXZ6evxkqaXaF2MgKusSkOoYtwhI3owF006tAaujhproy6+vf//IsvxyOj1+WI9mFWgRJMum0/faOtpMtTWbIChvDGQbxBjIJUhjINcgCKTttauj0ywWFa0/uKbYrqsUzNr7vGDl7ODbPCMlojZg7I26/DK1/yiK4u3JybtXNvHWbAq5lCGQWT80r7a9/eBo/qUlwWaIQNT2TIMytZya7gzEBUJQ3kDcIN5AUiBeQPX7m885Qg03bbV36qbCGGar+6wmtmoFi7TXOUTDdopvMx+gsm1bLyAKKgHWCUgCjAWIE4wVqAnM5V7mdJVRg21bTHgxSQEIZj0u97K22Gl/MpAMrJwBkY4RltT7XNPCic6mSMeowugaNeWxA9Vh6mMoEwz2sR4yHUzbumkdkA2IA4bNEBcMCxAnTGcgbphOQBIw3kBSMF5AkjDOQNIwALLuqff3X77BQyJUwodzclhFrP63Brq9LZ+rFdfX156p37nS1kCj0eYjtVGs1GMlRM3jSDvdOqSXYvCDnIBQQRrKGUgaygtIEsobSAqqE5AEVGcgbigWIE4oNiAuKOueGg22ffBuB5aK1XL07FXNM6VZgdCQDsoEUN/HDkRQo9HW7D6XX1araPVm0/dkIBlIBpKBZGA1DbCOhfpSNB6P715cfH9NM+miyD/g8dcs/xc3Q1SCMD/FU3l1vWMhRP9m5GK/X4r9RR0/DHMtEjMbCM8Xguo1cBbV8zi+B30GkRj9GVP9fKyYYZGq6a3xrpKCFBSCGBIblKCQxAQlKEQxQQgKWcyggmIQM4igmMT0KihGMb0IilmMqCDMlc7Prz4NOcCjH9h1KzLVODu7+ppl5ZYOTnrkq2uzS57IMrlpXoSzChNOXH5dwPuqKzaSXoX+BwdBTBAd4dhFiQuKXVRvgmIV1bug2EQNJigWUYMLCl1UMIJCFRWcoNBEBSvIVdTOzubT//q5WPuAU+a5mMhcjI4+5xaPdfBXIHhpTPfnKab5HydHipUMJAPJQDIQkIG/Ipfsq+yXd94AAAAASUVORK5CYII=";
    return [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[UIScreen mainScreen].scale>=3?image3:image2 options:NSDataBase64DecodingIgnoreUnknownCharacters] scale:[UIScreen mainScreen].scale];
}

#pragma mark- Getter & Setter

- (void)setJjNavTitle:(NSString *)jjNavTitle {
    self.jjNavTitleLabel.text = jjNavTitle;
}

- (NSString *)jjNavTitle {
    return self.jjNavTitleLabel.text;
}

- (dispatch_block_t)jjNavBackBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJjNavBackBlock:(dispatch_block_t)jjNavBackBlock {
    objc_setAssociatedObject(self, @selector(jjNavBackBlock), jjNavBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UILabel *)jjNavTitleLabel {
    UILabel *view = objc_getAssociatedObject(self, _cmd);
    if (view == nil) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        view = titleLabel;
        self.jjNavTitleLabel = view;
    }
    return view;
}

- (void)setJjNavTitleLabel:(UILabel *)jjNavTitleLabel {
    objc_setAssociatedObject(self, @selector(jjNavTitleLabel), jjNavTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)jjNavBackBtn {
    UIButton *btn = objc_getAssociatedObject(self, _cmd);
    if (btn == nil) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [view setImage:[self jjInBackImage] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(jjInNavBack) forControlEvents:UIControlEventTouchUpInside];
        btn = view;
        self.jjNavBackBtn = view;
    }
    return btn;
}

- (void)setJjNavBackBtn:(UIButton *)jjNavBackBtn {
    objc_setAssociatedObject(self, @selector(jjNavBackBtn), jjNavBackBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)jjNavBar {
    UIView *nav = objc_getAssociatedObject(self, _cmd);
    if (nav == nil) {
        nav = [UIView new];
        nav.backgroundColor = [UIColor whiteColor];
        nav.clipsToBounds = YES;
        [nav addSubview:self.jjNavBackBtn];
        [nav addSubview:self.jjNavTitleLabel];
        nav.hidden = YES;
        nav.frame = CGRectMake(0, 0,STATUS_BAR_WIDTH, 0);
        [self.view addSubview:nav];
        self.jjNavBar = nav;
    }
    return nav;
}

- (void)setJjNavBar:(UIView *)jjNavBar {
    objc_setAssociatedObject(self, @selector(jjNavBar), jjNavBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
