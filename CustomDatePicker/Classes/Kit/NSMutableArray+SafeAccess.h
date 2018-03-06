//
//  NSMutableArray+SafeAccess.h
//  MyFirstProject
//
//  Created by sunshinelww on 2018/2/25.
//  Copyright © 2018年 didi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+SafeAccess.h"

@interface NSMutableArray (SafeAccess)

- (void)lw_safeAddObject:(id)anObject;

- (void)lw_insertObject:(id)anObject atIndex:(NSUInteger)index;

@end
