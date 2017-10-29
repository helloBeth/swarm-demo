//
//  RateAnswerViewController.h
//  SignInSample
//
//  Created by jy on 2017/10/8.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateAnswerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, copy) NSDictionary *answerDic;

@property(weak, nonatomic) IBOutlet UIPickerView      *likehood;
@property(weak, nonatomic) IBOutlet UIPickerView      *Reasoning;
@property(weak, nonatomic) IBOutlet UIPickerView      *Presentation;

@end
