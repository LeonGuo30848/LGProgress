//
//  ViewController.m
//  LGProgress_Master
//
//  Created by 郭佳良 on 2019/1/8.
//  Copyright © 2019年 Leon. All rights reserved.
//

#import "ViewController.h"
#import "LGProgress.h"

#define HexRGB(rgbValue)            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
#define SCREEN_WIDTH  CGRectGetWidth([[UIScreen mainScreen] bounds])

@interface ViewController ()

@property (nonatomic,strong) LGProgress *progressView;

@property (nonatomic,strong) NSTimer *audioTimer;

@property (nonatomic,assign) CGFloat recordDuration;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.progressView];
    
    UIButton *beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    beginBtn.frame = CGRectMake(10, 100, 60, 20);
    [self.view addSubview:beginBtn];
    [beginBtn addTarget:self action:@selector(startAudioTimer) forControlEvents:UIControlEventTouchUpInside];
    [beginBtn setTitle:@"Begin" forState:UIControlStateNormal];
    [beginBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake(90, 100, 60, 20);
    [self.view addSubview:stopBtn];
    [stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [stopBtn setTitle:@"Stop" forState:UIControlStateNormal];
    [stopBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(160, 100, 60, 20);
    [self.view addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitle:@"delete" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
}


- (void)startAudioTimer {
    [self.audioTimer invalidate];
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addSeconed) userInfo:nil repeats:YES];
    
    if (_progressView.progressEnd ==0.0) {
        [_progressView drawBegan];
    }else{
        _progressView.progressEnd = [_progressView.pauseArray.lastObject floatValue];
        [_progressView.nowArray removeAllObjects];
        [_progressView drawMoved];
    }
}
-(void)stop
{
    if (_progressView.progressEnd <=1.0 && _progressView.progressEnd !=0.0) {
        [_progressView drawPause];
    }
    [self.audioTimer invalidate];
}

- (void)addSeconed {
    _recordDuration+=0.1;
    if (_recordDuration > 60) {
        [self stop];
        return;
    }
    _progressView.progressEnd += 0.0017;
    [_progressView drawMoved];
}
-(void)delete
{
    [self.audioTimer invalidate];
    [_progressView drawDelete];
}
-(LGProgress *)progressView
{
    if (!_progressView) {
        _progressView =[[LGProgress alloc]initWithFrame:CGRectMake(20,SCREEN_HEIGHT - 100 , SCREEN_WIDTH - 40, 3)];
        _progressView.progressEnd = 0.0;
        _progressView.drawColor =  HexRGB(0x7362FF);
        _progressView.pauseColor = [UIColor whiteColor];
    }
    return _progressView;
}
@end
