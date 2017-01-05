//
//  TTSRecongizeViewController.m
//  TuringTest
//
//  Created by Turing on 15/8/31.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

#import "TTSRecongizeViewController.h"

#import "TRRVoiceRecognitionManager.h"

#import "KeyString.h"

@interface TTSRecongizeViewController() <TRRVoiceRecognitionManagerDelegate>
@end

@implementation TTSRecongizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _recognizeResultTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    _recognizeResultTextView.layer.borderWidth = 1.0;
    _recognizeResultTextView.layer.cornerRadius = 5.0f;
    _recognizeResultTextView.text = @"正在语音识别，请讲话";
    [_recognizeResultTextView.layer setMasksToBounds:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    TRRVoiceRecognitionManager *sharedInstance=[TRRVoiceRecognitionManager sharedInstance];
    [sharedInstance setApiKey:BaiduAPIKey secretKey:BaiduSecretKey];
    sharedInstance.delegate = self;
    NSArray *array = @[@(20000)];
    sharedInstance.recognitionPropertyList = array;
    int startStatus = [sharedInstance startVoiceRecognition];
    if (startStatus != 0) {
        _recognizeResultTextView.text = [NSString stringWithFormat:@"err = %i", startStatus ];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRecognitionResult:(NSString *)result {
    _recognizeResultTextView.text = result;
    NSLog(@"result = %@", result);
}

- (void)onRecognitionError:(NSString *)errStr {
    _recognizeResultTextView.text = NSLocalizedString(errStr, nil);
    NSLog(@"Error = %@", errStr);
}

- (void)onStartRecognize {
    _recognizeResultTextView.text = @"正在语音识别，请讲话";
}

- (void)onSpeechStart {
    _recognizeResultTextView.text = @"检测到已说话";
}

- (void)onSpeechEnd {
    _recognizeResultTextView.text = @"检测到已停止说话";

}

@end
