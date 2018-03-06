//
//  NSDictionary+SafeAccess.h
//  MyFirstProject
//
//  Created by sunshinelww on 2018/2/25.
//  Copyright © 2018年 didi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSDictionary (SafeAccess)

- (id)lw_safeObjectForKey:(id)key;
- (id)lw_safeObjectForKey:(id)key class:(Class)aClass;

- (BOOL)lw_boolForKey:(id)key;
- (CGFloat)lw_floatForKey:(id)key;
- (NSInteger)lw_integerForKey:(id)key;
- (NSString *)lw_stringForKey:(id)key;
- (NSDictionary *)lw_dictionaryForKey:(id)key;
- (NSArray *)lw_arrayForKey:(id)key;

@end

@interface NSMutableDictionary(SafeAccess)

- (void)lw_safeSetObject:(id)anObject forKey:(id)key;

@end
