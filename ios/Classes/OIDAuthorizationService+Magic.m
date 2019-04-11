//
//  OIDAuthorizationService+Magic.m
//  flutter_app_auth_wrapper
//
//  Created by William Wang on 2019/2/26.
//

#import "OIDAuthorizationService+Magic.h"
#import <objc/runtime.h>

BOOL newShouldHandleURL(OIDAuthorizationService *sender, SEL selector, NSURL *URL) {
	return YES;
}

@interface OIDAuthorizationFlowSessionImplementation : NSObject
@end

@implementation OIDAuthorizationService (Magic)

+ (void)load
{
	[super load];
	[OIDAuthorizationService methodSwizzle];
}

+ (void)methodSwizzle
{
	do {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
		SEL oldSelector = @selector(shouldHandleURL:);
		SEL newSelector = @selector(newShouldHandleURL:);
#pragma clang diagnostic pop
		
		Class class = [OIDAuthorizationFlowSessionImplementation class];
		class_addMethod(class, newSelector, (IMP)newShouldHandleURL, @encode(void));
		
		Method oldMethod = class_getInstanceMethod(class, oldSelector);
		Method newMethod = class_getInstanceMethod(class, newSelector);
		method_exchangeImplementations(oldMethod, newMethod);
	} while (0);
}

@end
