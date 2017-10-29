//
//  AddAnswerViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/7.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "AddAnswerViewController.h"
#import "NetLogicInterface.h"
#import "NSString+SBJSON.h"
#import "AllDataManager.h"

@interface AddAnswerViewController ()

@end

@implementation AddAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
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
    
    NSString* content = _answerContent.text;
    
    if (![content isEqualToString:@""]) {
        [[NetLogicInterface sharedNetLogicInterface] RequestAddAnswerByToken:[[AllDataManager sharedAllDataManager].dicToken objectForKey:@"access_token"] andParentID:[_questDic objectForKey:@"id"] andContent:content andTaskID:@"RequestAddAnswerByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestAddAnswerByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestAddAnswerFinished:) name:@"RequestAddAnswerByToken" object:nil];
    }
}

-(void)requestAddAnswerFinished:(NSNotification*) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestAddAnswerByToken" object:nil];
    
    if (!notification.object) {
        return;
    }
    
    NSLog(@"json:\n%@", notification.object);
    NSDictionary *jsonObj = [notification.object  JSONValue];
    if ([jsonObj objectForKey:@"chunk"] && [jsonObj objectForKey:@"chunk"]!=[NSNull null]) {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"adding answer ok!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
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
    [_answerContent resignFirstResponder];
}

@end
