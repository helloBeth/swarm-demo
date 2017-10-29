//
//  AddCommentViewController.h
//  SignInSample
//
//  Created by jy on 2017/10/8.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentViewController : UIViewController

@property (nonatomic, copy) NSDictionary *answerDic;

@property(weak, nonatomic) IBOutlet UITextView      *commentContent;

@end
