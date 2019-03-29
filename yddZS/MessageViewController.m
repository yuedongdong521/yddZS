//
//  MessageViewController.m
//  yddZS
//
//  Created by ydd on 2018/11/30.
//  Copyright © 2018 ydd. All rights reserved.
//

#import "MessageViewController.h"
#import <MessageUI/MessageUI.h>
@interface MessageViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self showSMSPicker:nil];
}

- (void)showSMSPicker:(id)sender
{
  if ([MFMessageComposeViewController canSendText]) {
    [self displaySMSComposerSheet];
  }
}

- (void)displaySMSComposerSheet
{
  MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc]init];
  picker.messageComposeDelegate = self;
  
  picker.recipients = @[@"17749757268"];
  picker.body = @"hello message";
  [self presentViewController:picker animated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
  switch (result)
  {
    case MessageComposeResultCancelled: //取消
      NSLog(@"Result: SMS sending canceled");
      break;
    case MessageComposeResultSent: //发送
      NSLog(@"Result: SMS sent");
      break;
    case MessageComposeResultFailed: //失败
      NSLog(@"Result: SMS sending failed");
      break;
    default: //默认
      NSLog(@"Result: SMS not sent");
      break;
  }
  
  [self dismissViewControllerAnimated:YES completion:NULL];
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
