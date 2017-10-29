//
//  QuestDetailTableViewCell.h
//  SignInSample
//
//  Created by jy on 2017/10/6.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestDetailTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIWebView *userimage;
@property(weak, nonatomic) IBOutlet UIImageView *userimage2;
@property(weak, nonatomic) IBOutlet UILabel *username;
@property(weak, nonatomic) IBOutlet UILabel *answer;
@property(weak, nonatomic) IBOutlet UILabel *quality;
@property(weak, nonatomic) IBOutlet UILabel *likehood;
@property(weak, nonatomic) IBOutlet UILabel *strtime;




@end
