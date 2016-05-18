//
//  SLMusic.h
//  音乐播放器
//
//  Created by CHEUNGYuk Hang Raymond on 16/5/5.
//  Copyright © 2016年 CHEUNGYuk Hang Raymond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLMusic : NSObject

@property (assign, nonatomic) NSString *musicImage;
@property (assign, nonatomic) NSString *musicAudio;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
