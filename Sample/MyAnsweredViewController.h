//
//  MyAnsweredViewController.h
//  SignInSample
//
//  Created by jy on 2017/10/4.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAnsweredViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIView *searchView;
@property(weak, nonatomic) IBOutlet UITextField *keywords;
@property(weak, nonatomic) IBOutlet UISwitch *state;

@end
