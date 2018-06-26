//
//  UIViewController+JJNavBar.h
//  JJKit
//
//  Created by luming on 2018/6/5.
//  Copyright © 2018年 luming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JJNavBar)
@property (nonatomic, strong, readonly) UIView *jjNavBar;
@property (nonatomic, copy) NSString *jjNavTitle;

@property (nonatomic, strong, readonly) UILabel *jjNavTitleLabel;
@property (nonatomic, strong, readonly) UIButton *jjNavBackBtn;
@property (nonatomic, copy) dispatch_block_t jjNavBackBlock;

- (void)jjShowNavBar;
- (void)jjHideNavBar;

- (void)jjShowNavBar:(NSString *)title;
- (void)jjShowNavBar:(NSString *)title backBlock:(dispatch_block_t)backBlock;
@end
