//
//  CommentTableViewCell.m
//  SignInSample
//
//  Created by jy on 2017/10/7.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "NetLogicInterface.h"
#import "NSString+SBJSON.h"
#import "AllDataManager.h"
#import "UIImage+Rotate.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)like:(id)sender {
    NSDictionary* dicToken = [AllDataManager sharedAllDataManager].dicToken;
    
    if (dicToken) {
        int myRate = [[[[_commentDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"argumentRating"] isEqual:[NSNull null]] ? 0 : [[[[_commentDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"argumentRating"] intValue];
        
        NSDictionary* rate;
        
        if (myRate > 0)
        {
            _likeoffset = -1;
            rate = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"argumentRating", nil];
        }
        else
        {
            _likeoffset = 1;
            rate = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1],@"argumentRating", nil];
        }
        
        NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys: rate, @"rate", nil];
        
        [[NetLogicInterface sharedNetLogicInterface] RequestRatingByToken:[dicToken objectForKey:@"access_token"]  andCommentID:[_commentDic objectForKey:@"id"] andRateDic:param andTaskID:@"RequestRatingByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestRatingByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestRateFinished:) name:@"RequestRatingByToken" object:nil];
    }

}

-(void)requestRateFinished:(NSNotification*) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestRatingByToken" object:nil];
    
    if (!notification.object) {
        return;
    }
    

    NSLog(@"json:\n%@", notification.object);
    NSDictionary *jsonObj = [notification.object  JSONValue];
    if ([jsonObj objectForKey:@"data"] && [jsonObj objectForKey:@"data"]!=[NSNull null]) {
        int argumentRating = [[[jsonObj objectForKey:@"mine"] objectForKey:@"argumentRating"] intValue];
        if (argumentRating > 0) {
            [self.like setBackgroundImage:[UIImage imageNamed:@"ico_like_selected"] forState:UIControlStateNormal];
            [self.unlike setBackgroundImage:[[UIImage imageNamed:@"ico_like_unselected"] imageRotatedByDegrees:180] forState:UIControlStateNormal];
            
        }
        else if (argumentRating < 0)
        {
            [self.like setBackgroundImage:[UIImage imageNamed:@"ico_like_unselected"] forState:UIControlStateNormal];
            [self.unlike setBackgroundImage:[[UIImage imageNamed:@"ico_like_selected"] imageRotatedByDegrees:180] forState:UIControlStateNormal];
        }
        else
        {
            [self.like setBackgroundImage:[UIImage imageNamed:@"ico_like_unselected"] forState:UIControlStateNormal];
            [self.unlike setBackgroundImage:[[UIImage imageNamed:@"ico_like_unselected"] imageRotatedByDegrees:180] forState:UIControlStateNormal];
        }
        
        int like = 0;
        {
            
            NSDictionary* argumentRating = [[[_commentDic objectForKey:@"scores"] objectForKey:@"crowd"] objectForKey:@"argumentRating"];
            if (argumentRating && ![argumentRating isEqual:[NSNull null]] && [argumentRating count] > 0) {
                
                for (NSString* key in [argumentRating allKeys]) {
                    like += [key intValue]*[[argumentRating objectForKey:key] intValue];
                    
                }
                
            }
        }
        
        self.likeNum.text = [NSString stringWithFormat:@"%d", like + _likeoffset];
        [self.like layoutIfNeeded];
        [self.likeNum layoutIfNeeded];
        [self.unlike layoutIfNeeded];

    }
    else {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"operation failed!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];

    }
    
}

- (IBAction)unlike:(id)sender {
    NSDictionary* dicToken = [AllDataManager sharedAllDataManager].dicToken;
    
    if (dicToken) {
        int myRate = [[[[_commentDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"argumentRating"] isEqual:[NSNull null]] ? 0 : [[[[_commentDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"argumentRating"] intValue];
        
        NSDictionary* rate;
        
        if (myRate < 0)
        {
            _likeoffset = 1;
            rate = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"argumentRating", nil];
        }
        else
        {
            _likeoffset = -1;
            rate = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:-1],@"argumentRating", nil];
        }
        
        NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys: rate, @"rate", nil];
        
        [[NetLogicInterface sharedNetLogicInterface] RequestRatingByToken:[dicToken objectForKey:@"access_token"]  andCommentID:[_commentDic objectForKey:@"id"] andRateDic:param andTaskID:@"RequestRatingByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestRatingByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestRateFinished:) name:@"RequestRatingByToken" object:nil];
    }
}

@end
