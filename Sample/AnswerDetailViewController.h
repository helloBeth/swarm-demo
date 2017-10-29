//
//  AnswerDetailViewController.h
//  SignInSample
//
//  Created by jy on 2017/10/7.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

@interface AnswerDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, PullTableViewDelegate,UIWebViewDelegate>

@property (nonatomic, copy) NSDictionary *answerDic;

@property(weak, nonatomic) IBOutlet PullTableView *tableView;

@property(weak, nonatomic) IBOutlet UIImageView *userHead;
@property(weak, nonatomic) IBOutlet UIWebView *answerBody;
@property(weak, nonatomic) IBOutlet UILabel *answerAuthor;
@property(weak, nonatomic) IBOutlet UILabel *answerTime;
@property(weak, nonatomic) IBOutlet UILabel *commentNum;

@property(weak, nonatomic) IBOutlet UILabel *reasoningLabel;
@property(weak, nonatomic) IBOutlet UILabel *presentationLabel;
@property(weak, nonatomic) IBOutlet UITextField *reasoning;
@property(weak, nonatomic) IBOutlet UITextField *presentation;


@property(weak, nonatomic) IBOutlet UITextField *likehood;

@property(weak, nonatomic) IBOutlet UIView *headerview;

@end
