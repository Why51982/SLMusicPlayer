//
//  ViewController.m
//  SLMusicPlayer
//
//  Created by CHEUNGYuk Hang Raymond on 16/5/18.
//  Copyright © 2016年 CHEUNGYuk Hang Raymond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#import "ViewController.h"
#import "SLView.h"

#import "SLMusic.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SLView *view = [SLView loadView];
    
    //给模型赋值
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"一万个理由" forKey:@"musicAudio"];
    [dic setValue:@"郑源" forKey:@"musicImage"];
    SLMusic *model1 = [[SLMusic alloc] initWithDic:dic];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setValue:@"一直很安静" forKey:@"musicAudio"];
    [dic1 setValue:@"阿桑" forKey:@"musicImage"];
    SLMusic *model2 = [[SLMusic alloc] initWithDic:dic1];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setValue:@"如果怀念" forKey:@"musicAudio"];
    [dic2 setValue:@"杨晓" forKey:@"musicImage"];
    SLMusic *model3 = [[SLMusic alloc] initWithDic:dic2];
    
    NSArray *array = @[model1, model2, model3];
    view.array = array;
    
    [self.view addSubview:view];
}
@end
