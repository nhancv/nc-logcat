//
//  NSString_Extensions.m
//  LogCat
//
//  Created by Chris Wilson on 12/12/12.
//

#import "NSStringExtension.h"

@implementation NSString (Helpers)

/**
 returns YES if the string is an integer
 **/
- (BOOL)isInteger {
    if([self intValue] != 0) {
        return true;
    } else if([self isEqualToString:@"0"]) {
        return true;
    }
    
    return false;
    
}

@end
