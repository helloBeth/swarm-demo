//
//  AddAnswerViewController.h
//  SignInSample
//
//  Created by jy on 2017/10/7.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAnswerViewController : UIViewController

@property (nonatomic, copy) NSDictionary *questDic;

@property(weak, nonatomic) IBOutlet UITextView      *answerContent;

@end
