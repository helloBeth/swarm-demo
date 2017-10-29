//
//  QuestionDetailViewController.h
//  SignInSample
//
//  Created by jy on 2017/10/6.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

@interface QuestionDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, PullTableViewDelegate,UIWebViewDelegate>

@property (nonatomic, copy) NSDictionary *questDic;

@property(weak, nonatomic) IBOutlet PullTableView *tableView;

@property(weak, nonatomic) IBOutlet UILabel *questTitle;
@property(weak, nonatomic) IBOutlet UIWebView *questBody;
@property(weak, nonatomic) IBOutlet UILabel *questAuthor;
@property(weak, nonatomic) IBOutlet UILabel *questTime;

@property(weak, nonatomic) IBOutlet UIView *headerview;

@end
