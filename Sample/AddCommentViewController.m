//
//  AddCommentViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/8.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "AddCommentViewController.h"
#import "NetLogicInterface.h"
#import "NSString+SBJSON.h"
#import "AllDataManager.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
   
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submit:(id)sender {
    
    //[[NetLogicInterface sharedNetLogicInterface] RequestChunkByTaskID:@""];
    
    NSString* content = _commentContent.text;
    
    if (![content isEqualToString:@""]) {
        [[NetLogicInterface sharedNetLogicInterface] RequestAddCommentByToken:[[AllDataManager sharedAllDataManager].dicToken objectForKey:@"access_token"] andParentID:[_answerDic objectForKey:@"id"] andContent:content andTaskID:@"RequestAddCommentByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestAddCommentByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestAddCommentFinished:) name:@"RequestAddCommentByToken" object:nil];
    }
}

-(void)requestAddCommentFinished:(NSNotification*) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestAddCommentByToken" object:nil];
    
    if (!notification.object) {
        return;
    }
    
    NSLog(@"json:\n%@", notification.object);
    NSDictionary *jsonObj = [notification.object  JSONValue];
    if ([jsonObj objectForKey:@"chunk"] && [jsonObj objectForKey:@"chunk"]!=[NSNull null]) {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"adding comment ok!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
    }
    else
    {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"operation failed!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
        
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_commentContent resignFirstResponder];
}


@end
