//
//  AnswerDetailViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/7.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "AnswerDetailViewController.h"
#import "AllDataManager.h"
#import "NetLogicInterface.h"
#import "NSString+SBJSON.h"
#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Rotate.h"
#import "AddCommentViewController.h"
#import "RateAnswerViewController.h"

@interface AnswerDetailViewController ()
{
    UILabel* calcHeightLable;
    NSArray* curData;
}
@end

@implementation AnswerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    calcHeightLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 1000, 283, 21)];
    calcHeightLable.font = [UIFont systemFontOfSize:15];
    curData = [[NSArray alloc] init];
    
    int offsetHeight = 0;
    
    NSString* headUrl = [[_answerDic objectForKey:@"author"] objectForKey:@"avatar"];
    NSString* schame = [headUrl substringToIndex:4];
    if (![schame isEqualToString:@"http"]) {
        headUrl = [NSString stringWithFormat:@"https://swarm-dev2.eresearch.unimelb.edu.au%@", headUrl];
    }

    [_userHead sd_setImageWithURL:[NSURL URLWithString: headUrl]];
    
    _answerAuthor.text = [[_answerDic objectForKey:@"author"] objectForKey:@"displayName"];
    
    NSTimeInterval createTime = [[_answerDic objectForKey:@"lastEdited"] longLongValue]/1000;
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSString* timestr;
    
    if (nowTime - createTime < 60) {
        timestr = @"1 minutes ago";
    }
    else if (nowTime - createTime < 3600) {
        timestr = [NSString stringWithFormat:@"%d minutes ago", (int)(nowTime - createTime)/60];
    }
    else if (nowTime - createTime < 3600*24){
        timestr = [NSString stringWithFormat:@"%d hours ago", (int)(nowTime - createTime)/3600];
    }
    else if (nowTime - createTime < 3600*24*7){
        timestr = [NSString stringWithFormat:@"%d days ago", (int)(nowTime - createTime)/(3600*24)];
    }
    else {
        timestr = [NSString stringWithFormat:@"%d weeks ago", (int)(nowTime - createTime)/(3600*24*7)];
    }
    
    _answerTime.text = timestr;
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[_answerDic objectForKey:@"content"] options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    //NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[decodedString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //_answerBody.attributedText = attrStr;
    //_answerBody.numberOfLines = 0;
    //[_answerBody sizeToFit];
    
    _answerBody.dataDetectorTypes = UIDataDetectorTypeAll;
    [_answerBody setDelegate:self];
    [_answerBody loadHTMLString:decodedString baseURL:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"answerToAddComment"]){
        AddCommentViewController* vc = segue.destinationViewController;
        vc.answerDic = _answerDic;
    }
    else if ([[segue identifier] isEqualToString:@"answerToRate"]){
        RateAnswerViewController* vc = segue.destinationViewController;
        vc.answerDic = _answerDic;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetchData];
    _tableView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _tableView.delegate = nil;
}


-(void)requestChunkDetailFinished:(NSNotification*) notification
{
    [self refreshTableEnd];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestChunkDetailByToken" object:nil];
    
    if (!notification.object) {
        return;
    }
    
    NSLog(@"json:\n%@", notification.object);
    NSDictionary *jsonObj = [notification.object  JSONValue];
    if ([jsonObj objectForKey:@"author"] && [jsonObj objectForKey:@"author"]!=[NSNull null]) {
        _answerDic = jsonObj;
        
        //_commentNum.text = [NSString stringWithFormat:@"%d comments", (int)[curData count]];
        
        int p = 0 ;
        if ( [[[_answerDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"presentation"] && ![[[[_answerDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"presentation"] isEqual:[NSNull null]])
        {
            p =  [[[[_answerDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"presentation"] intValue];
        }
        
        int r = 0 ;
        if ( [[[_answerDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"reasoning"] && ![[[[_answerDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"reasoning"] isEqual:[NSNull null]])
        {
            r =  [[[[_answerDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"reasoning"] intValue];
        }
        
        int l = 0;
        if ( [[[_answerDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"midLikelihood"] && ![[[[_answerDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"midLikelihood"] isEqual:[NSNull null]])
        {
            l =  [[[[_answerDic objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"midLikelihood"] intValue];
        }
        
        _presentation.text = [NSString stringWithFormat:@"%d", p];
        _reasoning.text = [NSString stringWithFormat:@"%d", r];
        _likehood.text = [NSString stringWithFormat:@"%d", l];
        
    }
    else {
        NSString* msg = [[jsonObj objectForKey:@"message"] isEqual:[NSNull null]]?@"server unknow error!" : [jsonObj objectForKey:@"message"];
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
    }
}

-(void)requestCommentFinished:(NSNotification*) notification
{
    [self refreshTableEnd];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestCommentByToken" object:nil];
    
    if (!notification.object) {
        return;
    }
    
    NSLog(@"json:\n%@", notification.object);
    NSDictionary *jsonObj = [notification.object  JSONValue];
    if ([jsonObj objectForKey:@"data"] && [jsonObj objectForKey:@"data"]!=[NSNull null]) {
        curData = [jsonObj objectForKey:@"data"];
        
        _commentNum.text = [NSString stringWithFormat:@"%d comments", (int)[curData count]];
        
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    }
    else {
        NSString* msg = [[jsonObj objectForKey:@"message"] isEqual:[NSNull null]]?@"server unknow error!" : [jsonObj objectForKey:@"message"];
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
    }
    
}

-(void)fetchData{
    NSDictionary* dicToken = [AllDataManager sharedAllDataManager].dicToken;
    
    if (!dicToken) {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"login info invalid!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
        
        [self removeFromParentViewController];
    }
    else{
        
        [[NetLogicInterface sharedNetLogicInterface] RequestChunkDetailByToken:[dicToken objectForKey:@"access_token"] andChunkID:[_answerDic objectForKey:@"id"] andTaskID:@"RequestChunkDetailByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestChunkDetailByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestChunkDetailFinished:) name:@"RequestChunkDetailByToken" object:nil];
        
        [[NetLogicInterface sharedNetLogicInterface] RequestCommentByToken:[dicToken objectForKey:@"access_token"] andChunkID:[_answerDic objectForKey:@"id"] andTaskID:@"RequestCommentByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestCommentByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestCommentFinished:) name:@"RequestCommentByToken" object:nil];
    }
}

- (IBAction)clickComment:(id)sender {
    [self performSegueWithIdentifier:@"answerToAddComment" sender:self];
}

- (IBAction)clickRate:(id)sender {
    [self performSegueWithIdentifier:@"answerToRate" sender:self];
}

#pragma mark - UITableViewDataSource

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//
//    return _headerview.frame.size.height;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* chunks = curData;
    return [chunks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* chunks = curData;
    NSDictionary* chunk = [chunks objectAtIndex:indexPath.row];
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[chunk objectForKey:@"content"] options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[decodedString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //UILabel * myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    calcHeightLable.attributedText = attrStr;
    
    calcHeightLable.frame = CGRectMake(0, 1000, 277, 36);
    calcHeightLable.numberOfLines = 0;
    
    [calcHeightLable sizeToFit];
    
    int height = 120;
    if (calcHeightLable.frame.size.height > 36) {
        height = 120+calcHeightLable.frame.size.height-36;
    }
    
    
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary* chunk = [curData objectAtIndex:indexPath.row];
    
    cell.commentDic = chunk;
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[chunk objectForKey:@"content"] options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[decodedString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //UILabel * myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    cell.commentContent.attributedText = attrStr;
    cell.commentContent.numberOfLines = 0;
    cell.commentContent.frame = CGRectMake(cell.commentContent.frame.origin.x, cell.commentContent.frame.origin.y, cell.commentContent.frame.size.width, 36);
    [cell.commentContent sizeToFit];
    
    int offsetHeight = cell.commentContent.frame.size.height - 36;
    
    if (offsetHeight > 0){
        cell.likeNum.frame = CGRectMake(cell.likeNum.frame.origin.x, cell.likeNum.frame.origin.y+offsetHeight, cell.likeNum.frame.size.width, cell.likeNum.frame.size.height);
       
        cell.like.frame = CGRectMake(cell.like.frame.origin.x, cell.like.frame.origin.y+offsetHeight, cell.like.frame.size.width, cell.like.frame.size.height);
        
        cell.unlike.frame = CGRectMake(cell.unlike.frame.origin.x, cell.unlike.frame.origin.y+offsetHeight, cell.unlike.frame.size.width, cell.unlike.frame.size.height);
        
        cell.author.frame = CGRectMake(cell.author.frame.origin.x, cell.author.frame.origin.y+offsetHeight, cell.author.frame.size.width, cell.author.frame.size.height);
    }
    
    int like = 0;
    {
        
        NSDictionary* argumentRating = [[[chunk objectForKey:@"scores"] objectForKey:@"crowd"] objectForKey:@"argumentRating"];
        if (argumentRating && ![argumentRating isEqual:[NSNull null]] && [argumentRating count] > 0) {

            for (NSString* key in [argumentRating allKeys]) {
                like += [key intValue]*[[argumentRating objectForKey:key] intValue];
                
            }
            
        }
    }
    
    cell.likeNum.text = [NSString stringWithFormat:@"%d", like];
    
    int myRate = [[[[chunk objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"argumentRating"] isEqual:[NSNull null]] ? 0 : [[[[chunk objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"argumentRating"] intValue];

    if (myRate > 0) {
        [cell.like setBackgroundImage:[UIImage imageNamed:@"ico_like_selected"] forState:UIControlStateNormal];
        [cell.unlike setBackgroundImage:[[UIImage imageNamed:@"ico_like_unselected"] imageRotatedByDegrees:180] forState:UIControlStateNormal];
    }
    else if (myRate < 0)
    {
        [cell.like setBackgroundImage:[UIImage imageNamed:@"ico_like_unselected"] forState:UIControlStateNormal];
        [cell.unlike setBackgroundImage:[[UIImage imageNamed:@"ico_like_selected"] imageRotatedByDegrees:180] forState:UIControlStateNormal];
    }
    else
    {
        [cell.like setBackgroundImage:[UIImage imageNamed:@"ico_like_unselected"] forState:UIControlStateNormal];
        [cell.unlike setBackgroundImage:[[UIImage imageNamed:@"ico_like_unselected"] imageRotatedByDegrees:180] forState:UIControlStateNormal];
    }
    
    
    
    NSTimeInterval createTime = [[chunk objectForKey:@"createdAt"] longLongValue]/1000;
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSString* timestr;
    
    if (nowTime - createTime < 60) {
        timestr = @"1 minutes ago";
    }
    else if (nowTime - createTime < 3600) {
        timestr = [NSString stringWithFormat:@"%d minutes ago", (int)(nowTime - createTime)/60];
    }
    else if (nowTime - createTime < 3600*24){
        timestr = [NSString stringWithFormat:@"%d hours ago", (int)(nowTime - createTime)/3600];
    }
    else if (nowTime - createTime < 3600*24*7){
        timestr = [NSString stringWithFormat:@"%d days ago", (int)(nowTime - createTime)/(3600*24)];
    }
    else {
        timestr = [NSString stringWithFormat:@"%d weeks ago", (int)(nowTime - createTime)/(3600*24*7)];
    }
    
    cell.author.text = [NSString stringWithFormat:@"Post by %@ %@", [[chunk objectForKey:@"author"] objectForKey:@"displayName"], timestr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Refresh and load more methods

- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    [self performSelector:@selector(refreshTableEnd) withObject:nil afterDelay:1.0f];
    [self fetchData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    
    [self performSelector:@selector(loadMoreEnd) withObject:nil afterDelay:1.0f];
    
}

- (void)refreshTableEnd
{
    /*
     
     Code to actually refresh goes here.
     
     */
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
}

-(void)loadMoreEnd
{
    self.tableView.pullTableIsLoadingMore = NO;
}

#pragma mark - UIWebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    int offsetHeight = 0;
    CGFloat height = [[_answerBody stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    if (height > 30) {
        offsetHeight = height - 30;
        
        _reasoningLabel.frame = CGRectMake(_reasoningLabel.frame.origin.x, _reasoningLabel.frame.origin.y+offsetHeight, _reasoningLabel.frame.size.width, _reasoningLabel.frame.size.height);
        _presentationLabel.frame = CGRectMake(_presentationLabel.frame.origin.x, _presentationLabel.frame.origin.y+offsetHeight, _presentationLabel.frame.size.width, _presentationLabel.frame.size.height);
        _reasoning.frame = CGRectMake(_reasoning.frame.origin.x, _reasoning.frame.origin.y+offsetHeight, _reasoning.frame.size.width, _reasoning.frame.size.height);
        _presentation.frame = CGRectMake(_presentation.frame.origin.x, _presentation.frame.origin.y+offsetHeight, _presentation.frame.size.width, _presentation.frame.size.height);
        _commentNum.frame = CGRectMake(_commentNum.frame.origin.x, _commentNum.frame.origin.y+offsetHeight, _commentNum.frame.size.width, _commentNum.frame.size.height);
        _answerBody.frame = CGRectMake(_answerBody.frame.origin.x, _answerBody.frame.origin.y, _answerBody.frame.size.width, height);
        _headerview.frame = CGRectMake(_headerview.frame.origin.x, _headerview.frame.origin.y, _headerview.frame.size.width, _headerview.frame.size.height+offsetHeight);
        
        [self.tableView reloadData];
    }
    
}


@end
