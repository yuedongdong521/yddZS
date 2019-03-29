//
//  GCDViewController.m
//  yddZS
//
//  Created by ydd on 2018/10/26.
//  Copyright © 2018年 ydd. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@property (nonatomic, strong) NSMutableArray *mutArray;
@property (nonatomic, strong) NSMutableArray *testArray;
@property (nonatomic, strong) NSMutableArray *concurArray;
@property (nonatomic, strong) NSMutableArray *systemArray;
// 串行
@property (nonatomic, strong) dispatch_queue_t serialQueue;
// 并发
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor whiteColor];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 100)];
  label.textColor = [UIColor blueColor];
  label.numberOfLines = 0;
  [self.view addSubview:label];
  
  NSString *str = @" Do any additional setup \n after loading \n the view.";
  NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
  label.attributedText = att;
  
  
  for (int i = 0; i < 100; i++) {
    [self.mutArray addObject:@(i)];
  }
  
//  [self testSerialQueue];
  [self testConcurrentQueue];
  
 
  

  
  
}

- (void)testSerialQueue
{
  NSLog(@"start serial queue");
  dispatch_async(self.serialQueue, ^{
    for (int i = 0; i < 2; i++) {
      NSLog(@"serialQueue1 : %d", i);
    }
  });
  
  dispatch_async(self.serialQueue, ^{
    for (int i = 0; i < 2; i++) {
      NSLog(@"serialQueue2 : %d", i);
    }
  });
  dispatch_async(self.serialQueue, ^{
    for (int i = 0; i < 2; i++) {
      NSLog(@"serialQueue3 : %d", i);
    }
  });
  NSLog(@"stop serial queue");
}


- (void)testConcurrentQueue
{
  NSLog(@"start concurrent queue");
  dispatch_async(self.concurrentQueue, ^{
    for (int i = 0; i < 2; i++) {
      NSLog(@"concurrentQueue1 : %d", i);
    }
  });
  
  dispatch_async(self.concurrentQueue, ^{
    for (int i = 0; i < 2; i++) {
      NSLog(@"concurrentQueue2 : %d", i);
    }
  });
  
  dispatch_async(self.concurrentQueue, ^{
    for (int i = 0; i < 2; i++) {
      NSLog(@"concurrentQueue3 : %d", i);
    }
  });
  
  NSLog(@"stop concurrent queue");
}

- (dispatch_queue_t)serialQueue
{
  if (!_serialQueue) {
    _serialQueue = dispatch_queue_create("SerialQueue", DISPATCH_QUEUE_SERIAL);
  }
  return _serialQueue;
}

- (dispatch_queue_t)concurrentQueue
{
  if (!_concurrentQueue) {
    _concurrentQueue = dispatch_queue_create("ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
  }
  return _concurrentQueue;
}

- (NSMutableArray *)mutArray
{
  if (!_mutArray) {
    _mutArray = [NSMutableArray array];
  }
  return _mutArray;
}

- (NSMutableArray *)testArray
{
  if (!_testArray) {
    _testArray = [NSMutableArray array];
  }
  return _testArray;
}

- (NSMutableArray *)concurArray
{
  if (!_concurArray) {
    _concurArray = [NSMutableArray array];
  }
  return _concurArray;
}

- (NSMutableArray *)systemArray
{
  if (!_systemArray) {
    _systemArray = [NSMutableArray array];
  }
  return _systemArray;
}

- (void)dealy
{
  int count = arc4random() % 6 + 1;
  int outCount = 0;
  for (int i = 0; i < 1000000 * count; i++) {
    outCount++;
  }
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
