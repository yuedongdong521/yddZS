//
//  AudionVolumeViewController.m
//  yddZS
//
//  Created by ydd on 2018/11/9.
//  Copyright © 2018 ydd. All rights reserved.
//

#import "AudionVolumeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPVolumeView.h>


@interface AudionVolumeViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AudionVolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor grayColor];
  
  [self initPlayer];
  
  UISlider *testSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 100, 200, 50)];
  testSlider.minimumValue = 0;
  testSlider.maximumValue = 1.0;
  testSlider.minimumTrackTintColor = [UIColor greenColor];
  testSlider.maximumTrackTintColor = [UIColor whiteColor];
  [testSlider addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:testSlider];
  
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
  btn.frame = CGRectMake(20, 300, 100, 50);
  [btn setTitle:@"player" forState:UIControlStateNormal];
  [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn];
}

- (void)btnAction
{
  [_player play];
}

- (void)testAction:(UISlider *)slider
{
  [self setSystemVolume:slider.value];
}

- (void)setSystemVolume:(CGFloat)volume {
  static UISlider* volumeSlider;
  if (!volumeSlider) {
    // 初步同步系统的音量跟耳机初步音量达成一致
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    for (UIView* view in [volumeView subviews]) {
      if ([[view.class description] isEqualToString:@"MPVolumeSlider"]) {
        volumeSlider = (UISlider*)view;
        break;
      }
    }
    
    // 这个默认值是YES,设为NO之后，系统音量条是隐藏了，可是会弹出音量提示框
    volumeView.showsVolumeSlider = YES;
    // 去掉提示框
    volumeView.showsRouteButton = NO;
    // 通过设置frame隐藏音量滑动条
    [volumeView sizeToFit];
    [volumeView setFrame:CGRectMake(-1000, -1000, 10, 10)];
    volumeView.hidden = NO;
    
    [volumeView userActivity];
    
    [[UIApplication sharedApplication].keyWindow addSubview:volumeView];
  }
  NSLog(@"系统音量 ： %f", volumeSlider.value);
  [volumeSlider setValue:volume animated:NO];
}

- (void)initPlayer
{
  [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
  AVAudioSession *session = [AVAudioSession sharedInstance];
  [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
  [session setActive:YES error:nil];
  NSString *path = [[NSBundle mainBundle] pathForResource:@"audio544" ofType:@"mp3"];
  NSURL *url = [NSURL fileURLWithPath:path];
  NSError *error;
  AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
  player.volume = 1.0;
  player.numberOfLoops = -1;
  _player = player;
  [_player prepareToPlay];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
