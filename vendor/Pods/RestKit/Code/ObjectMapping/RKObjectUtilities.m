//
//  RKObjectUtilities.m
//  RestKit
//
//  Created by Blake Watters on 9/30/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <objc/message.h>
#import "RKObjectUtilities.h"

BOOL RKObjectIsEqualToObject(id object, id anotherObject) {
    NSCAssert(object, @"Expected object not to be nil");
    NSCAssert(anotherObject, @"Expected anotherObject not to be nil");
    
    SEL comparisonSelector;
    if ([object isKindOfClass:[NSString class]] && [anotherObject isKindOfClass:[NSString class]]) {
        comparisonSelector = @selector(isEqualToString:);
    } else if ([object isKindOfClass:[NSNumber class]] && [anotherObject isKindOfClass:[NSNumber class]]) {
        comparisonSelector = @selector(isEqualToNumber:);
    } else if ([object isKindOfClass:[NSDate class]] && [anotherObject isKindOfClass:[NSDate class]]) {
        comparisonSelector = @selector(isEqualToDate:);
    } else if ([object isKindOfClass:[NSArray class]] && [anotherObject isKindOfClass:[NSArray class]]) {
        comparisonSelector = @selector(isEqualToArray:);
    } else if ([object isKindOfClass:[NSDictionary class]] && [anotherObject isKindOfClass:[NSDictionary class]]) {
        comparisonSelector = @selector(isEqualToDictionary:);
    } else if ([object isKindOfClass:[NSSet class]] && [anotherObject isKindOfClass:[NSSet class]]) {
        comparisonSelector = @selector(isEqualToSet:);
    } else {
        comparisonSelector = @selector(isEqual:);
    }
    
    // Comparison magic using function pointers. See this page for details: http://www.red-sweater.com/blog/320/abusing-objective-c-with-class
    // Original code courtesy of Greg Parker
    // This is necessary because isEqualToNumber will return negative integer values that aren't coercable directly to BOOL's without help [sbw]
    BOOL (*ComparisonSender)(id, SEL, id) = (BOOL (*)(id, SEL, id))objc_msgSend;
    return ComparisonSender(object, comparisonSelector, anotherObject);
}

BOOL RKClassIsCollection(Class aClass)
{
    return (aClass && ([aClass isSubclassOfClass:[NSSet class]] ||
                       [aClass isSubclassOfClass:[NSArray class]] ||
                       [aClass isSubclassOfClass:[NSOrderedSet class]]));
}

BOOL RKObjectIsCollection(id object)
{
    return RKClassIsCollection([object class]);
}

BOOL RKObjectIsCollectionContainingOnlyManagedObjects(id object)
{
    if (! RKObjectIsCollection(object)) return NO;
    Class managedObjectClass = NSClassFromString(@"NSManagedObject");
    if (! managedObjectClass) return NO;
    for (id instance in object) {
        if (! [object isKindOfClass:managedObjectClass]) return NO;
    }
    return YES;
}
