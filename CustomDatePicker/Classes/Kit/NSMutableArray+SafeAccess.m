//
//  NSMutableArray+SafeAccess.m
//  MyFirstProject
//
//  Created by sunshinelww on 2018/2/25.
//  Copyright © 2018年 didi. All rights reserved.
//

#import "NSMutableArray+SafeAccess.h"

@implementation NSMutableArray (SafeAccess)

- (void)lw_safeAddObject:(id)anObject{
    if (anObject) {
        [self addObject:anObject];
    }
}

- (void)lw_insertObject:(id)anObject atIndex:(NSUInteger)index{
    NSAssert(index > self.count, @"index: %lud out of the range of array.", (unsigned long)index);
    if (anObject && index < self.count) {
        [self insertObject:anObject atIndex:index];
    }
}

@end
