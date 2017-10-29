//
//  LoginViewController.h
//  SignInSample
//
//  Created by jy on 2017/10/2.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GIDSignInButton;

@interface LoginViewController : UIViewController

@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property(weak, nonatomic) IBOutlet UIView *loginFrame;
@property(weak, nonatomic) IBOutlet UITextField *textUsername;
@property(weak, nonatomic) IBOutlet UITextField *textPassword;

@end
