//
//  SLView.h
//  音乐播放器
//
//  Created by CHEUNGYuk Hang Raymond on 16/5/5.
//  Copyright © 2016年 CHEUNGYuk Hang Raymond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLView : UIView

@property (nonatomic, strong) NSArray *array;

+ (instancetype)loadView;

@end
