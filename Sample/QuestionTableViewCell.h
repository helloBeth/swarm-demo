//
//  QuestionTableViewCell.h
//  SignInSample
//
//  Created by jy on 2017/10/3.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *title;
@property(weak, nonatomic) IBOutlet UILabel *author;
@property(weak, nonatomic) IBOutlet UILabel *time;

@property(weak, nonatomic) IBOutlet UIWebView *head;
@property(weak, nonatomic) IBOutlet UIImageView *head2;
@end
