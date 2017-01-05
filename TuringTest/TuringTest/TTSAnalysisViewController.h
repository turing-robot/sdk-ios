//
//  TTSAnalysisViewController.h
//  TuringTest
//
//  Created by Turing on 15/9/4.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSAnalysisViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

- (IBAction)startAnalysis:(id)sender;

@end
