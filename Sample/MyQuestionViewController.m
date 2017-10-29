//
//  MyQuestionViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/4.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "AllDataManager.h"
#import "NetRequestConst.h"
#import "QuestionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "QuestionDetailViewController.h"

#define CELL_MIN_HEIGHT 70

@interface MyQuestionViewController ()
{
    UILabel* calcHeightLable;
    NSArray* curData;
    NSDictionary* curSelectedQuest;
    
    NSString* curSearchText;
    
}
@end

@implementation MyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    calcHeightLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 1000, 283, 21)];
    calcHeightLable.font = [UIFont systemFontOfSize:15];
    
    curData = [[NSArray alloc] init];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    curSearchText = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if ( [AllDataManager sharedAllDataManager].arrChunk ) {
        
        NSString* userId = [[AllDataManager sharedAllDataManager].userInfo objectForKey:@"id"];
        NSMutableArray* curMutableArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary* dic in [AllDataManager sharedAllDataManager].arrChunk) {
            if ([[[dic objectForKey:@"author"] objectForKey:@"id"] isEqualToString:userId]) {
                
                if ([curSearchText isEqualToString:@""] || [[dic objectForKey:@"title"] rangeOfString:curSearchText options:NSCaseInsensitiveSearch].location != NSNotFound || [[dic objectForKey:@"content"] rangeOfString:curSearchText options:NSCaseInsensitiveSearch].location != NSNotFound ) {
                    
                    //if ([[dic objectForKey:@"state"] isEqualToString:state]) {
                    [curMutableArray addObject:dic];
                    //}S
                    
                }
                //[curMutableArray addObject:dic];
                
                
            }
        }
        
        curData = curMutableArray;
    }

    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    [self.tableView setContentOffset:CGPointMake(0,2) animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAdd:(id)sender {
    [self performSegueWithIdentifier:@"myQuestToAddQuest" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"myQuestToDetail"]){
        QuestionDetailViewController* vc = segue.destinationViewController;
        vc.questDic = curSelectedQuest;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* chunks = curData;
    return [chunks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* chunks = curData;
    NSDictionary* chunk = [chunks objectAtIndex:indexPath.row];
    
    calcHeightLable.frame = CGRectMake(0, 1000, 265, 55);
    calcHeightLable.numberOfLines = 0;
    calcHeightLable.text = [chunk objectForKey:@"title"];
    [calcHeightLable sizeToFit];
    
    int height = CELL_MIN_HEIGHT + calcHeightLable.frame.size.height;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary* chunk = [curData objectAtIndex:indexPath.row];
    
    NSString* headUrl = [[AllDataManager sharedAllDataManager].userInfo objectForKey:@"avatar"];
    NSString* schame = [headUrl substringToIndex:4];
    if (![schame isEqualToString:@"http"]) {
        headUrl = [NSString stringWithFormat:@"%@%@",RootUrl, headUrl];
    }
    
    cell.head.dataDetectorTypes = UIDataDetectorTypeAll;
    //[_headImage setDelegate:self];
    //[_questBody loadHTMLString:decodedString baseURL:nil];
    //[_headImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://swarm-dev2.eresearch.unimelb.edu.au/static/avatars/dingo2.svg"]]];
    
    NSString* part = [headUrl substringFromIndex:[headUrl length]-3];
    part = [part lowercaseString];
    if ([part isEqualToString:@"png"]) {
        [cell.head2 sd_setImageWithURL:[NSURL URLWithString:headUrl]];
        cell.head2.hidden = NO;
        cell.head.hidden = YES;
    }
    else {
        [cell.head loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:headUrl]]];
        cell.head2.hidden = YES;
        cell.head.hidden = NO;
    }
    
    //[cell.head loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:headUrl]]];
    
    cell.title.frame = CGRectMake(cell.title.frame.origin.x, cell.title.frame.origin.y, 283, 21);
    cell.title.numberOfLines = 0;
    cell.title.text = [chunk objectForKey:@"title"];
    [cell.title sizeToFit];
    
    cell.author.text = [[chunk objectForKey:@"author"] objectForKey:@"displayName"];
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
    
    cell.time.text = timestr;
    cell.time.frame = CGRectMake(cell.time.frame.origin.x, cell.title.frame.origin.y+cell.title.frame.size.height+30, cell.time.frame.size.width, cell.time.frame.size.height);
    cell.author.frame = CGRectMake(cell.author.frame.origin.x, cell.title.frame.origin.y+cell.title.frame.size.height+30, cell.author.frame.size.width, cell.author.frame.size.height);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    curSelectedQuest = [curData objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"myQuestToDetail" sender:self];
    
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchbar resignFirstResponder];
}

#pragma mark - Refresh and load more methods

- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    [self performSelector:@selector(refreshTableEnd) withObject:nil afterDelay:1.0f];
    if ( [AllDataManager sharedAllDataManager].arrChunk ) {
        
        NSString* userId = [[AllDataManager sharedAllDataManager].userInfo objectForKey:@"id"];
        NSMutableArray* curMutableArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary* dic in [AllDataManager sharedAllDataManager].arrChunk) {
            if ([[[dic objectForKey:@"author"] objectForKey:@"id"] isEqualToString:userId]) {
                
                
                [curMutableArray addObject:dic];
                
                
            }
        }
        
        curData = curMutableArray;
    }
    
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
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

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}// return NO to not become first responder

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    searchBar.showsCancelButton = YES;
//    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
//        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
//            UIButton * cancel =(UIButton *)view;
//            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
//            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
//        }
//    }
//}// called when text starts editing

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![AllDataManager sharedAllDataManager].arrChunk) {
        return;
    }
    
    curSearchText = searchText;
    
    NSMutableArray* curMutableArray = [[NSMutableArray alloc] init];
    
    NSString* userId = [[AllDataManager sharedAllDataManager].userInfo objectForKey:@"id"];
    NSString* keywords = searchText;
    //NSString* state = _state.isOn?@"open":@"closed";
    for (NSDictionary* dic in [AllDataManager sharedAllDataManager].arrChunk) {
        
        if ([[[dic objectForKey:@"author"] objectForKey:@"id"] isEqualToString:userId]) {
            if ([keywords isEqualToString:@""] || [[dic objectForKey:@"title"] rangeOfString:keywords options:NSCaseInsensitiveSearch].location != NSNotFound || [[dic objectForKey:@"content"] rangeOfString:keywords options:NSCaseInsensitiveSearch].location != NSNotFound ) {
                
                //if ([[dic objectForKey:@"state"] isEqualToString:state]) {
                    [curMutableArray addObject:dic];
                //}S
                
            }
        }
    }
    
    curData = curMutableArray;
    
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}// return NO to not resign first responder

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_searchbar resignFirstResponder];
}

@end