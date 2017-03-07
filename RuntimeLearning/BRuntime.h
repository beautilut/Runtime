//
// Created by Beautilut on 2017/3/6.
// Copyright (c) 2017 beautilut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface BRuntime : NSObject


//获取类名
+(NSString *)fetchClassName:(Class)class;

//获取成员变量
+(NSArray *)fetchIvarList:(Class)class;

//获取成员属性
+(NSArray *)fetchPropertyList:(Class)class;

//获取类的实例方法
+(NSArray *)fetchMethodList:(Class)class;

//获取协议列表
+(NSArray *)fetchProtocolList:(Class)class;

//动态添加方法实现 methodSel 方法名 methodSelImpl 对应方法实现的方法名
+(void)addMethod:(Class)class method:(SEL)methodSel methodImpl:(SEL)methodSelImpl;

//方法实现交换
+(void)methodSwap:(Class)class firstMethod:(SEL)method1 secondMethod:(SEL)method2;

//消息处理

@end
