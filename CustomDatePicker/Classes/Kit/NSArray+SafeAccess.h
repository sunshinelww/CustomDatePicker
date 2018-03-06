//
//  NSArray+SafeAccess.h
//  MyFirstProject
//
//  Created by sunshinelww on 2018/2/25.
//  Copyright © 2018年 didi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSArray (SafeAccess)

- (id)safeObjectAtIndex:(NSUInteger)index;
- (id)safeObjectAtIndex:(NSUInteger)index class:(__unsafe_unretained Class)aClass;

- (BOOL)lw_boolAtIndex:(NSUInteger)index;
- (CGFloat)lw_floatAtIndex:(NSUInteger)index;
- (NSInteger)lw_integerAtIndex:(NSUInteger)index;
- (NSString *)lw_stringAtIndex:(NSUInteger)index;
- (NSDictionary *)lw_dictionaryAtIndex:(NSUInteger)index;
- (NSArray *)lw_arrayAtIndex:(NSUInteger)index;

@end
