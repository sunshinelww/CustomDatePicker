//
//  NSArray+SafeAccess.m
//  MyFirstProject
//
//  Created by sunshinelww on 2018/2/25.
//  Copyright © 2018年 didi. All rights reserved.
//

#import "NSArray+SafeAccess.h"

@implementation NSArray (SafeAccess)

- (id)safeObjectAtIndex:(NSUInteger)index{
    if (index > self.count) {
        return nil;
    }
    id retObj = [self objectAtIndex:index];
    if (retObj == [NSNull null]) {
        return nil;
    }
    return retObj;
}

- (id)safeObjectAtIndex:(NSUInteger)index class:(Class)aClass{
    id value = [self safeObjectAtIndex:index];
    if ([value isKindOfClass:aClass]) {
        return value;
    }
    return nil;
}

- (BOOL)lw_boolAtIndex:(NSUInteger)index{
    id value = [self safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return NO;
}

- (CGFloat)lw_floatAtIndex:(NSUInteger)index{
    id value = [self safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return 0.f;
}

- (NSInteger)lw_integerAtIndex:(NSUInteger)index{
    id value = [self safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (NSString *)lw_stringAtIndex:(NSUInteger)index{
    return [self safeObjectAtIndex:index class:[NSString class]];
}

- (NSDictionary *)lw_dictionaryAtIndex:(NSUInteger)index{
    return [self safeObjectAtIndex:index class:[NSDictionary class]];
}

- (NSArray *)lw_arrayAtIndex:(NSUInteger)index{
    return [self safeObjectAtIndex:index class:[NSArray class]];
}


@end
