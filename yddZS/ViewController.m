//
//  ViewController.m
//  yddZS
//
//  Created by ydd on 2018/10/24.
//  Copyright © 2018年 ydd. All rights reserved.
//

#import "ViewController.h"
#import "ProgressViewController.h"
#import "GCDViewController.h"
#import "AudionVolumeViewController.h"
#import "TestHtmlViewController.h"
#import "MessageViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
//  [self testRunLoop];
  [self.view addSubview:self.tableView];
  [self.tableView reloadData];
}

- (void)testRunLoop
{
  NSTimer *defaultTimer= [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    NSLog(@"mode : %@", [[NSRunLoop currentRunLoop] currentMode]);
  }];
  [[NSRunLoop currentRunLoop] addTimer:defaultTimer forMode:NSDefaultRunLoopMode];
//  [[NSRunLoop currentRunLoop] addTimer:defaultTimer forMode:@"customMode"];
//  [[NSRunLoop currentRunLoop]  runMode:@"customMode" beforeDate:[NSDate distantFuture]];
  
  
  NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    NSLog(@"mode : %@", [[NSRunLoop currentRunLoop] currentMode]);
  }];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

  
}


- (UITableView *)tableView
{
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
  }
  return _tableView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case 1:
    {
      ProgressViewController *vc = [[ProgressViewController alloc] init];
      [self presentViewController:vc animated:YES completion:nil];
    }
      break;
    case 2:
    {
      GCDViewController *vc = [[GCDViewController alloc] init];
      [self.navigationController pushViewController:vc animated:YES];
    }
      break;
    case 3:
    {
      AudionVolumeViewController *av = [[AudionVolumeViewController alloc] init];
      [self.navigationController pushViewController:av animated:YES];
    }
      break;
    case 4:
    {
      TestHtmlViewController *vc = [[TestHtmlViewController alloc] init];
      [self presentViewController:vc animated:YES completion:nil];
    }
      break;
    case 5:
    {
      MessageViewController *vc = [[MessageViewController alloc] init];
      [self presentViewController:vc animated:YES completion:nil];
    }
      break;
      
    default:
      break;
  }
  
}


@end
