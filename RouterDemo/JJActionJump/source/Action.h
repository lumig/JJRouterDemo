//
//  Action.h
//  ZZTest
//
//  Created by zhgz on 2018/2/3.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Action.h"
@class Params,Extra,Component;

@interface Action : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) Params *params;

@end

@interface Params : NSObject

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *contentID;

@property (nonatomic, copy) NSString *frameID;

@property (nonatomic, copy) NSString *pageID;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, strong) Extra *extra;

@end

@interface Extra : NSObject

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *contentId;

@property (nonatomic, copy) NSString *shareSubTitle;

@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic, copy) NSString *contentType;

@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, assign) BOOL isRedrain;

@property (nonatomic, copy) NSString *goodsType;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *mediaYear;

@property (nonatomic, copy) NSString *mediaType;

@property (nonatomic, copy) NSString *mediaArea;

@end

@interface NSObject(MGAction)

@property (nonatomic,strong) Action *mgAction;

@property (nonatomic,weak) UIView *mgWeakView;

@property (nonatomic,weak) Component *mgComp;

@end
