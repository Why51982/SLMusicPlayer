//
//  SLMusic.m
//  音乐播放器
//
//  Created by CHEUNGYuk Hang Raymond on 16/5/5.
//  Copyright © 2016年 CHEUNGYuk Hang Raymond. All rights reserved.
//

#import "SLMusic.h"

@implementation SLMusic

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        //KVC赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
