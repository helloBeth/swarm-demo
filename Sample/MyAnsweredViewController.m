//
//  MyAnsweredViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/4.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "MyAnsweredViewController.h"
#import "AllDataManager.h"
#import "NetLogicInterface.h"
#import "NSString+SBJSON.h"
#import "QuestionTableViewCell.h"

#define CELL_MIN_HEIGHT 70

@interface MyAnsweredViewController ()
{
    UILabel* calcHeightLable;
    NSArray* curData;
}
@end

@implementation MyAnsweredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    calcHeightLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 1000, 283, 21)];
    calcHeightLable.font = [UIFont systemFontOfSize:15];
    
    curData = [[NSArray alloc] init];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSearch:(id)sender {
    _searchView.hidden = NO;
}

- (IBAction)startSearch:(id)sender {
    
    if (![AllDataManager sharedAllDataManager].arrChunk) {
        return;
    }
    
    NSMutableArray* curMutableArray = [[NSMutableArray alloc] init];
    
    NSString* keywords = _keywords.text;
    NSString* state = _state.isOn?@"open":@"closed";
    for (NSDictionary* dic in [AllDataManager sharedAllDataManager].arrChunk) {
        if ([[dic objectForKey:@"title"] rangeOfString:keywords].location != NSNotFound || [[dic objectForKey:@"content"] rangeOfString:keywords].location != NSNotFound ) {
            
            if ([[dic objectForKey:@"state"] isEqualToString:state]) {
                [curMutableArray addObject:dic];
            }
            
        }
    }
    
    curData = curMutableArray;
    
    _searchView.hidden = YES;
    
    [_keywords resignFirstResponder];
    
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
    
    cell.title.frame = CGRectMake(18, 8, 283, 21);
    cell.title.numberOfLines = 0;
    cell.title.text = [chunk objectForKey:@"title"];
    [cell.title sizeToFit];
    
    cell.author.text = [[chunk objectForKey:@"author"] objectForKey:@"displayName"];
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
    
    cell.time.text = timestr;
    cell.time.frame = CGRectMake(cell.time.frame.origin.x, cell.title.frame.origin.y+cell.title.frame.size.height+30, cell.time.frame.size.width, cell.time.frame.size.height);
    cell.author.frame = CGRectMake(cell.author.frame.origin.x, cell.title.frame.origin.y+cell.title.frame.size.height+30, cell.author.frame.size.width, cell.author.frame.size.height);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
