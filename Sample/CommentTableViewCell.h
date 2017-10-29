//
//  CommentTableViewCell.h
//  SignInSample
//
//  Created by jy on 2017/10/7.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
{
    int _likeoffset;
}
@property (nonatomic, copy) NSDictionary *commentDic;

@property(weak, nonatomic) IBOutlet UIButton      *like;
@property(weak, nonatomic) IBOutlet UIButton      *unlike;
@property(weak, nonatomic) IBOutlet UILabel       *commentContent;
@property(weak, nonatomic) IBOutlet UILabel       *likeNum;
@property(weak, nonatomic) IBOutlet UILabel       *author;


@end
