//
//  QuestionDetailViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/6.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "AllDataManager.h"
#import "NetLogicInterface.h"
#import "NSString+SBJSON.h"
#import "QuestDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AddAnswerViewController.h"
#import "AnswerDetailViewController.h"

#define CELL_MIN_HEIGHT 70

@interface QuestionDetailViewController ()
{
    UILabel* calcHeightLable;
    NSArray* curData;
    NSDictionary* curAnswerDic;
}
@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    calcHeightLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 1000, 283, 21)];
    calcHeightLable.font = [UIFont systemFontOfSize:15];
    curData = [[NSArray alloc] init];
    
    int offsetHeight = 0;
    _questTitle.text = [_questDic objectForKey:@"title"];
    _questTitle.numberOfLines = 0;
    [_questTitle sizeToFit];
    
    if (_questTitle.frame.size.height > 21) {
        offsetHeight = _questTitle.frame.size.height - 21;
        
        _questBody.frame = CGRectMake(_questBody.frame.origin.x, _questBody.frame.origin.y+offsetHeight, _questBody.frame.size.width, _questBody.frame.size.height);
        
        _questAuthor.frame = CGRectMake(_questAuthor.frame.origin.x, _questAuthor.frame.origin.y+offsetHeight, _questAuthor.frame.size.width, _questAuthor.frame.size.height);
        _questTime.frame = CGRectMake(_questTime.frame.origin.x, _questTime.frame.origin.y+offsetHeight, _questTime.frame.size.width, _questTime.frame.size.height);
        
        _headerview.frame = CGRectMake(_headerview.frame.origin.x, _headerview.frame.origin.y, _headerview.frame.size.width, _headerview.frame.size.height+offsetHeight);
        
    }
    
    
    _questAuthor.text = [[_questDic objectForKey:@"author"] objectForKey:@"displayName"];
    
    NSTimeInterval createTime = [[_questDic objectForKey:@"lastEdited"] longLongValue]/1000;
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
    
    _questTime.text = timestr;
    
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[_questDic objectForKey:@"content"] options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    
    _questBody.dataDetectorTypes = UIDataDetectorTypeAll;
    [_questBody setDelegate:self];
    [_questBody loadHTMLString:decodedString baseURL:nil];
    //[_questBody loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://swarm-dev2.eresearch.unimelb.edu.au/static/avatars/dingo2.svg"]]];

    
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
    if ([[segue identifier] isEqualToString:@"detailToAddAnswer"]){
        AddAnswerViewController* vc = segue.destinationViewController;
        vc.questDic = _questDic;
    }
    else if ([[segue identifier] isEqualToString:@"detailToAnswerDetail"])
    {
        AnswerDetailViewController* vc = segue.destinationViewController;
        vc.answerDic = curAnswerDic;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _tableView.delegate = self;
    [self fetchData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _tableView.delegate = nil;
}


-(void)requestHypothesisFinished:(NSNotification*) notification
{
    [self refreshTableEnd];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestHypothesisByToken" object:nil];
    
    if (!notification.object) {
        return;
    }
    
    NSLog(@"json:\n%@", notification.object);
    NSDictionary *jsonObj = [notification.object  JSONValue];
    if ([jsonObj objectForKey:@"data"] && [jsonObj objectForKey:@"data"]!=[NSNull null]) {
        curData = [jsonObj objectForKey:@"data"];
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
                                                       message: @"login info invalid !"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
        
        [self removeFromParentViewController];
    }
    else{
        [[NetLogicInterface sharedNetLogicInterface] RequestHypothesisByToken:[dicToken objectForKey:@"access_token"] andChunkID:[_questDic objectForKey:@"id"] andTaskID:@"RequestHypothesisByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestHypothesisByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestHypothesisFinished:) name:@"RequestHypothesisByToken" object:nil];
    }
}

- (IBAction)clickAdd:(id)sender {
    [self performSegueWithIdentifier:@"detailToAddAnswer" sender:self];
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
    return 151;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuestDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary* chunk = [curData objectAtIndex:indexPath.row];
    
    NSString* headUrl = [[chunk objectForKey:@"author"] objectForKey:@"avatar"];
    NSString* schame = [headUrl substringToIndex:4];
    if (![schame isEqualToString:@"http"]) {
        headUrl = [NSString stringWithFormat:@"https://swarm-dev2.eresearch.unimelb.edu.au%@", headUrl];
    }
    
    cell.userimage.dataDetectorTypes = UIDataDetectorTypeAll;
    
    NSString* part = [headUrl substringFromIndex:[headUrl length]-3];
    part = [part lowercaseString];
    if ([part isEqualToString:@"png"]) {
        [cell.userimage2 sd_setImageWithURL:[NSURL URLWithString:headUrl]];
        cell.userimage2.hidden = NO;
        cell.userimage.hidden = YES;
    }
    else {
        [cell.userimage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:headUrl]]];
        cell.userimage2.hidden = YES;
        cell.userimage.hidden = NO;
    }
    
    [cell.userimage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:headUrl]]];
    //[cell.userimage sd_setImageWithURL:[NSURL URLWithString:headUrl]];
    cell.username.text = [[chunk objectForKey:@"author"] objectForKey:@"displayName"];
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[chunk objectForKey:@"content"] options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[decodedString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //UILabel * myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    cell.answer.attributedText = attrStr;
    
    //cell.answer.text = ;
    
    float quality_p = 0;
    {
        
        
        NSDictionary* presentation = [[[chunk objectForKey:@"scores"] objectForKey:@"crowd"] objectForKey:@"presentation"];
        if (presentation && ![presentation isEqual:[NSNull null]] && [presentation count]>0) {
            int count = 0;
            for (NSString* key in [presentation allKeys]) {
                quality_p += [key floatValue]*[[presentation objectForKey:key] intValue];
                count += [[presentation objectForKey:key] intValue];
            }
            
            if (count) {
                quality_p /= count;
            }
            
        }
        else {
            if ( [[[chunk objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"presentation"] && ![[[[chunk objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"presentation"] isEqual:[NSNull null]])
            {
                quality_p =  [[[[chunk objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"presentation"] intValue];
            }

        }
    }
    
    float quality_r = 0;
    
    {
        
        NSDictionary* reasoning = [[[chunk objectForKey:@"scores"] objectForKey:@"crowd"] objectForKey:@"reasoning"];
        if (reasoning && ![reasoning isEqual:[NSNull null]] && [reasoning count]>0) {
            int count = 0;
            for (NSString* key in [reasoning allKeys]) {
                quality_r += [key floatValue]*[[reasoning objectForKey:key] intValue];
                count += [[reasoning objectForKey:key] intValue];
            }
            
            if (count) {
                quality_r /= count;
            }
            
        }
        else {
            
            if ( [[[chunk objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"reasoning"] && ![[[[chunk objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"reasoning"] isEqual:[NSNull null]])
            {
                quality_r =  [[[[chunk objectForKey:@"scores"] objectForKey:@"mine"] objectForKey:@"reasoning"] intValue];
            }
        }
    }
    
    int quality = MIN(quality_r, quality_p);
    
    cell.quality.text = [NSString stringWithFormat:@"aggregate quality: %d", quality];
    
    float midlikehood = 0;
    
    NSDictionary* likehood = [[[chunk objectForKey:@"scores"] objectForKey:@"crowd"] objectForKey:@"midLikelihood"];
    if (likehood && ![likehood isEqual:[NSNull null]] && [likehood count]>0) {
        int count = 0;
        for (NSString* key in [likehood allKeys]) {
            midlikehood += [key floatValue]*[[likehood objectForKey:key] intValue];
            count += [[likehood objectForKey:key] intValue];
        }
        
        if (count) {
            midlikehood /= count;
        }
        
    }
    
    cell.likehood.text = [NSString stringWithFormat:@"aggregate likehood: %d", (int)midlikehood];
    
    NSTimeInterval createTime = [[chunk objectForKey:@"lastEdited"] longLongValue]/1000;
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
    
    cell.strtime.text = timestr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curAnswerDic = [curData objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"detailToAnswerDetail" sender:self];
    
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
    CGFloat height = [[_questBody stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    if (height > 70) {
        offsetHeight = height-70;
        _questBody.frame = CGRectMake(_questBody.frame.origin.x, _questBody.frame.origin.y, _questBody.frame.size.width, height);
        
        _questAuthor.frame = CGRectMake(_questAuthor.frame.origin.x, _questAuthor.frame.origin.y+offsetHeight, _questAuthor.frame.size.width, _questAuthor.frame.size.height);
        _questTime.frame = CGRectMake(_questTime.frame.origin.x, _questTime.frame.origin.y+offsetHeight, _questTime.frame.size.width, _questTime.frame.size.height);
        
        _headerview.frame = CGRectMake(_headerview.frame.origin.x, _headerview.frame.origin.y, _headerview.frame.size.width, _headerview.frame.size.height+offsetHeight);
        
        [self.tableView reloadData];
    }

}

@end
