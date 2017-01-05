//
//  TTSViewController.m
//  TuringTest
//
//  Created by Turing on 15/8/24.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

#import "TTSViewController.h"

#import "TRRTuringAPIConfig.h"
#import "TRRTuringRequestManager.h"

#import "KeyString.h"

@interface TTSViewController ()
{
}

@end

@implementation TTSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sythesizer = [[TRRSpeechSythesizer alloc] initWithAPIKey:BaiduAPIKey secretKey:BaiduSecretKey];
    
        
    _inputTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    _inputTextView.layer.borderWidth = 1.0;
    _inputTextView.layer.cornerRadius = 5.0f;
    _inputTextView.text = @"";
    
    [_inputTextView.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startBtnDown:(id)sender {
    [self.sythesizer start: self.inputTextView.text];
}

- (IBAction)pauseBtnDown:(id)sender {
    [self.sythesizer pause];
}

- (IBAction)resumeBtnDown:(id)sender {
    [self.sythesizer resume];
}

- (IBAction)stopBtnDown:(id)sender {
    [self.sythesizer stop];
}
@end
