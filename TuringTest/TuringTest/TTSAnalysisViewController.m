//
//  TTSAnalysisViewController.m
//  TuringTest
//
//  Created by Turing on 15/9/4.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

#import "TTSAnalysisViewController.h"

#import "TRRTuringRequestManager.h"

#import "KeyString.h"

@interface TTSAnalysisViewController ()

@end

@implementation TTSAnalysisViewController

TRRTuringAPIConfig *apiConfig;
TRRTuringRequestManager *apiRequest;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiConfig = [[TRRTuringAPIConfig alloc] initWithAPIKey:TuringAPIKey];
    apiRequest = [[TRRTuringRequestManager alloc] initWithConfig:apiConfig];
    
    _inputTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    _inputTextView.layer.borderWidth = 1.0;
    _inputTextView.layer.cornerRadius = 5.0f;
    _inputTextView.text = @"";
    [_inputTextView.layer setMasksToBounds:YES];
    
    _outputTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    _outputTextView.layer.borderWidth = 1.0;
    _outputTextView.layer.cornerRadius = 5.0f;
    _outputTextView.text = @"";
    [_outputTextView.layer setMasksToBounds:YES];

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

- (IBAction)startAnalysis:(id)sender {
    [_inputTextView resignFirstResponder];
    [apiConfig request_UserIDwithSuccessBlock:^(NSString *str) {
        NSLog(@"result = %@", str);
        [apiRequest request_OpenAPIWithInfo:self.inputTextView.text successBlock:^(NSDictionary *dict) {
            NSLog(@"apiResult =%@",dict);
            _outputTextView.text = [dict objectForKey:@"text"];
        } failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
            _outputTextView.text = infoStr;
            NSLog(@"errorinfo = %@", infoStr);
        }];
    }
    failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
        _outputTextView.text = infoStr;
                                        NSLog(@"erroresult = %@", infoStr);
                                    }];

    
}
@end
