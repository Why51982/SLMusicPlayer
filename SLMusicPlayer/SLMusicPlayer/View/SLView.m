//
//  SLView.m
//  音乐播放器
//
//  Created by CHEUNGYuk Hang Raymond on 16/5/5.
//  Copyright © 2016年 CHEUNGYuk Hang Raymond. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SLView.h"
#import "SLMusic.h"

@interface SLView ()<AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *musicIndictor;
@property (weak, nonatomic) IBOutlet UIImageView *musicImage;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *progressTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *musicTitle;
@property (strong, nonatomic) UIButton *playButton;
@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) CADisplayLink *timer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (assign, nonatomic) NSInteger musicIndex;
@property (strong, nonatomic) CADisplayLink *sliderTimer;

@end

#define SLIndictorRotation M_PI_2 * 0.2

@implementation SLView

- (CADisplayLink *)timer {
    if (!_timer) {
        _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(beginRotation)];
        [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (CADisplayLink *)sliderTimer {
    
    if (!_sliderTimer) {
        _sliderTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(setSliderCurrentTime)];
        [_sliderTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _sliderTimer;
}

- (void)beginRotation {
    
    self.musicImage.transform = CGAffineTransformRotate(self.musicImage.transform, M_PI * 2 / 60 / 5);
}

+ (instancetype)loadView {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    CGRect oldRect = self.musicIndictor.frame;
    self.musicIndictor.layer.anchorPoint = CGPointMake(0.25, 0.14);
    self.musicIndictor.frame = oldRect;
    
    self.audioPlayer.delegate = self;
    
    self.musicIndictor.transform = CGAffineTransformRotate(self.musicIndictor.transform, - SLIndictorRotation);
    
    self.musicImage.clipsToBounds = YES;
    self.musicImage.layer.cornerRadius = 82;
    
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"processBar"] forState:UIControlStateNormal];
    [self.timeSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
}

//滑块改变产生的事件
- (void)sliderValueChange {
    
    self.audioPlayer.currentTime = self.timeSlider.value;
    self.progressTime.text = [self formatTime:self.audioPlayer.currentTime];
}

- (void)setArray:(NSArray *)array {
    
    _array = array;
    [self changeImageAndMusic:0];
}

- (void)changeImageAndMusic:(NSInteger)index {
    
    SLMusic *music = self.array[index];
    self.musicImage.image = [UIImage imageNamed:music.musicImage];
    self.musicTitle.text = music.musicAudio;
    NSString *path = [[NSBundle mainBundle] pathForResource:music.musicAudio ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURL *url1 = [NSURL URLWithString:path];
    NSLog(@"%@ -- %@", url, url1);
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.audioPlayer prepareToPlay];
    
    //初始化进度条
    self.timeSlider.value = 0;
    self.timeSlider.minimumValue = self.audioPlayer.currentTime;
    self.timeSlider.maximumValue = self.audioPlayer.duration;
    
    //显示Label
    self.progressTime.text = [self formatTime:self.audioPlayer.currentTime];
    self.totalTime.text = [self formatTime:self.audioPlayer.duration];
}

- (void)setSliderCurrentTime {
    
    self.progressTime.text = [self formatTime:self.audioPlayer.currentTime];
    self.timeSlider.value = self.audioPlayer.currentTime;
}

- (NSString *)formatTime:(double)time {
    
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

- (IBAction)next:(id)sender {
    
    if (self.musicIndex >= self.array.count - 1) {
        self.musicIndex = -1;
    }
    self.musicIndex++;
    [self changeImageAndMusic:self.musicIndex];
    
    if (self.isPlaying) {
        [self.audioPlayer play];
    }
}

- (IBAction)prev:(id)sender {
    
    if (self.musicIndex <= 0) {
        self.musicIndex = 3;
    }
    self.musicIndex--;
    [self changeImageAndMusic:self.musicIndex];
    
    if (self.isPlaying) {
        [self.audioPlayer play];
    }
}

- (IBAction)play:(UIButton *)button {
    
    self.isPlaying = !self.isPlaying;
    self.playButton = button;
    
    if (self.isPlaying) { //播放
        
        [self playing];
    } else {
        
        [button setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        
        self.timer.paused = YES;
        self.sliderTimer.paused = YES;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.musicIndictor.transform = CGAffineTransformRotate(self.musicIndictor.transform, - SLIndictorRotation);
        }];
        
        [self.audioPlayer pause];
    }
}

- (void)playing {
    
    [self.playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateHighlighted];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.musicIndictor.transform = CGAffineTransformRotate(self.musicIndictor.transform, SLIndictorRotation);
    }];
    
    self.timer.paused = NO;
    self.sliderTimer.paused = NO;
    
    [self.audioPlayer play];
}

#pragma mark -- <AVAudioPlayerDelegate>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    NSLog(@"audioPlayerDidFinishPlaying");
    [self next:nil];
}
@end
