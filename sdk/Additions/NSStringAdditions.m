//
//  NSStringAdditions.m
//  NextDay
//
//  Created by nickcheng on 13-1-16.
//  Copyright (c) 2013年 nx. All rights reserved.
//

#import "NSStringAdditions.h"

@implementation NSString (Additions)

- (NSString *)URLEncodedString {
	static CFStringRef toEscape = CFSTR(":/=,!$&'()*+;[]@#?%");
	return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                               (__bridge CFStringRef)self,
                                                                               NULL,
                                                                               toEscape,
                                                                               kCFStringEncodingUTF8);
}

@end
