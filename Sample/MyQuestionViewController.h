//
//  MyQuestionViewController.h
//  SignInSample
//
//  Created by jy on 2017/10/4.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
@interface MyQuestionViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>

@property(weak, nonatomic) IBOutlet PullTableView *tableView;

@property(weak, nonatomic) IBOutlet UISearchBar *searchbar;

@end
