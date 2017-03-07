//
// Created by Beautilut on 2017/3/6.
// Copyright (c) 2017 beautilut. All rights reserved.
//

#import "BRuntime.h"
#import "SecondClass.h"

@implementation BRuntime {

}
+ (NSString *)fetchClassName:(Class)class {

    const char * className = class_getName(class);
    return [NSString stringWithUTF8String:className];

}

+ (NSArray *)fetchIvarList:(Class)class {

    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(class, &count);

    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count ; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivarList[i]);
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        dic[@"type"] = [NSString stringWithUTF8String:ivarType];
        dic[@"ivarName"] = [NSString stringWithUTF8String:ivarName];

        [mutableList addObject:dic];
    }

    free(ivarList);
    return [NSArray arrayWithArray:mutableList];
}

+ (NSArray *)fetchPropertyList:(Class)class {

    unsigned int count = 0;

    objc_property_t *propertyList = class_copyPropertyList(class, &count);

    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0 ; i < count ; i++) {
        const char * propertyName = property_getName(propertyList[i]);
        [mutableList addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return [NSArray arrayWithArray:mutableList];

}

+ (NSArray *)fetchMethodList:(Class)class {

    unsigned int count = 0;

    Method *methodList = class_copyMethodList(class, &count);

    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0 ; i < count ; i++) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [mutableList addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return [NSArray arrayWithArray:mutableList];

    return nil;
}

+ (NSArray *)fetchProtocolList:(Class)class {

    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(class, &count);

    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:count];

    for (unsigned int i = 0 ; i < count ; i++ ) {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        [mutableList addObject:[NSString stringWithUTF8String:protocolName]];
    }

    return [NSArray arrayWithArray:mutableList];
    
}

+ (void)addMethod:(Class)class method:(SEL)methodSel methodImpl:(SEL)methodSelImpl {
    Method method = class_getInstanceMethod(class, methodSelImpl);
    IMP methodIMP = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod(class, methodSel, methodIMP, types);
}

-(void)dynamicAddMethod:(NSString*)value{

}

//
-(BOOL)resolveClassMethod:(SEL)sel {
    [[self class] addMethod:[self class] method:sel methodImpl:@selector(dynamicAddMethod:)];
    return YES;
}

//
-(id)forwardingTargetForSelector:(SEL)aSelector {
    return self;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    //查找父类的方法签名
    NSMethodSignature * signature = [super methodSignatureForSelector:aSelector];
    if (signature == nil) {
        signature = [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
    return signature;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
    SecondClass * forwardClass = [SecondClass new];
    SEL sel = anInvocation.selector;
    if ([forwardClass respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:forwardClass];
    }else {
        [self doesNotRecognizeSelector:sel];
    }
}

@end
