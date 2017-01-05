//
//  TTSViewController.h
//  TuringTest
//
//  Created by Turing on 15/8/24.
//  Copyright (c) 2015年 Turing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRRSpeechSythesizer.h"

@interface TTSViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (nonatomic, strong) TRRSpeechSythesizer *sythesizer;

- (IBAction)startBtnDown:(id)sender;
- (IBAction)pauseBtnDown:(id)sender;
- (IBAction)resumeBtnDown:(id)sender;
- (IBAction)stopBtnDown:(id)sender;

@end
