//
//  UserInfoViewController.h
//  SignInSample
//
//  Created by jy on 2017/10/4.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIWebView *headImage;
@property(weak, nonatomic) IBOutlet UIImageView *headImage2;
@property(weak, nonatomic) IBOutlet UILabel *reputationNum;
@property(weak, nonatomic) IBOutlet UILabel *chunkNum;
@property(weak, nonatomic) IBOutlet UILabel *commentNum;
@property(weak, nonatomic) IBOutlet UILabel *questionNum;

@property(weak, nonatomic) IBOutlet UILabel *username;

@end
