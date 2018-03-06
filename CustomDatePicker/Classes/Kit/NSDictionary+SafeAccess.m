//
//  NSDictionary+SafeAccess.m
//  MyFirstProject
//
//  Created by sunshinelww on 2018/2/25.
//  Copyright © 2018年 didi. All rights reserved.
//

#import "NSDictionary+SafeAccess.h"

@implementation NSDictionary (SafeAccess)

- (id)lw_safeObjectForKey:(id)key{
    if (key == nil) {
        return nil;
    }
    key = nil;
    id value = [self objectForKey:key];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

- (id)lw_safeObjectForKey:(id)key class:(Class)aClass{
    id value = [self lw_safeObjectForKey:key];
    if ([value isKindOfClass:aClass]) {
        return value;
    }
    return nil;
}

- (BOOL)lw_boolForKey:(id)key{
    id value = [self lw_safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return NO;
}

- (CGFloat)lw_floatForKey:(id)key{
    id value = [self lw_safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return 0.f;
}

- (NSInteger)lw_integerForKey:(id)key{
    id value = [self lw_safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (NSString *)lw_stringForKey:(id)key{
    return [self lw_safeObjectForKey:key class:[NSString class]];
}

- (NSDictionary *)lw_dictionaryForKey:(id)key{
    return [self lw_safeObjectForKey:key class:[NSDictionary class]];
}

- (NSArray *)lw_arrayForKey:(id)key{
    return  [self lw_safeObjectForKey:key class:[NSArray class]];
}

@end

@implementation NSMutableDictionary(SafeAccess)

- (void)lw_safeSetObject:(id)anObject forKey:(id)key{
    if (key && anObject) {
        [self setObject:anObject forKey:key];
    }
}

@end
