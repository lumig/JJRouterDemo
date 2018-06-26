//
//  Action.m
//  ZZTest
//
//  Created by zhgz on 2018/2/3.
//  Copyright © 2018年 Migu Video Technology. All rights reserved.
//

#import "Action.h"
#import <objc/runtime.h>

@implementation Action

@end

@implementation Params

@end

@implementation Extra

@end

@implementation NSObject (MGAction)

-(Action*)mgAction{
	return objc_getAssociatedObject(self, _cmd);
}

-(void)setMgAction:(Action *)mgAction{
	objc_setAssociatedObject(self, @selector(mgAction), mgAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView*)mgWeakView{
	NSPointerArray *weakArr = objc_getAssociatedObject(self, _cmd);
	return weakArr.allObjects.firstObject;
}

-(void)setMgWeakView:(UIView *)mgWeakView{
	NSPointerArray *weakArr = [NSPointerArray weakObjectsPointerArray];
	[weakArr addPointer:(__bridge void * _Nullable)(mgWeakView)];
	
	objc_setAssociatedObject(self, @selector(mgWeakView), weakArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(Component*)mgComp{
	NSPointerArray *weakArr = objc_getAssociatedObject(self, _cmd);
	return weakArr.allObjects.firstObject;
}

-(void)setMgComp:(Component *)mgComp{
	NSPointerArray *weakArr = [NSPointerArray weakObjectsPointerArray];
	[weakArr addPointer:(__bridge void * _Nullable)(mgComp)];
	
	objc_setAssociatedObject(self, @selector(mgComp), weakArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
