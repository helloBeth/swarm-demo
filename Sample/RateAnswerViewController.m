//
//  RateAnswerViewController.m
//  SignInSample
//
//  Created by jy on 2017/10/8.
//  Copyright © 2017  Google Inc. All rights reserved.
//

#import "RateAnswerViewController.h"
#import "NetLogicInterface.h"
#import "NSString+SBJSON.h"
#import "AllDataManager.h"


@interface RateAnswerViewController ()
{
    NSArray* likehoodData;
    NSArray* reasoningData;
    NSArray* presentationData;
    
    //ns
}

@end

@implementation RateAnswerViewController

int likehoodValue[7] = {3, 13, 33,50,67, 87,97};
int reasoningValue[7] = {3, 13, 33,50,67, 87,97};
int presentationValue[7] = {3, 13, 33,50,67, 87,97};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    likehoodData = [NSArray arrayWithObjects:@"Almost no chance (01-04%)",@"Very unlikely (05-19%)", @"Unlikely (20-44%)", @"Roughly even chance (45-54%)",@"Likely (55-79%)",@"Very Likely (80-94%)",@"Almost certain (95-99%)",nil];
    
    reasoningData = [NSArray arrayWithObjects:@"Zero/undermining (01-04%)",@"Weak (05-19%)",@"Poor (20-44%)",@"Moderate (45-54%)",@"Strong (55-79%)",@"Very strong (80-94%)",@"Conclusive (95-99%)", nil];
    
    presentationData = [NSArray arrayWithObjects:@"Zero/undermining (01-04%)",@"Weak (05-19%)",@"Poor (20-44%)",@"Moderate (45-54%)",@"Strong (55-79%)",@"Very strong (80-94%)",@"Conclusive (95-99%)", nil];
    
    NSDictionary* dic = [[_answerDic objectForKey:@"scores"] objectForKey:@"mine"];
    
    int midlikehood = 0;
    if ([dic objectForKey:@"midLikelihood"] && ![[dic objectForKey:@"midLikelihood"] isEqual:[NSNull null]]) {
        midlikehood = [[dic objectForKey:@"midLikelihood"] intValue];
    }
    
    int likeIndex = 0;
    if (midlikehood < 5) {
        likeIndex = 0;
    }
    else if (midlikehood < 20){
        likeIndex = 1;
    }
    else if (midlikehood < 45){
        likeIndex = 2;
    }
    else if (midlikehood < 55){
        likeIndex = 3;
    }
    else if (midlikehood < 80){
        likeIndex = 4;
    }
    else if (midlikehood < 95){
        likeIndex = 5;
    }
    else {
        likeIndex = 6;
    }
    
    [_likehood selectRow:likeIndex inComponent:0 animated:NO];
    
    float reasoning = 0;
    if ([dic objectForKey:@"reasoning"] && ![[dic objectForKey:@"reasoning"] isEqual:[NSNull null]]) {
        reasoning = [[dic objectForKey:@"reasoning"] floatValue];
    }
    
    int reasoningIndex = 0;
    if (reasoning < 5) {
        reasoningIndex = 0;
    }
    else if (reasoning < 20){
        reasoningIndex = 1;
    }
    else if (reasoning < 45){
        reasoningIndex = 2;
    }
    else if (reasoning < 55){
        reasoningIndex = 3;
    }
    else if (reasoning < 80){
        reasoningIndex = 4;
    }
    else if (reasoning < 95){
        reasoningIndex = 5;
    }
    else {
        reasoningIndex = 6;
    }
    
    [_Reasoning selectRow:reasoningIndex inComponent:0 animated:NO];
    
    float presentation = 0;
    if ([dic objectForKey:@"presentation"] && ![[dic objectForKey:@"presentation"] isEqual:[NSNull null]]) {
        presentation = [[dic objectForKey:@"presentation"] floatValue];
    }
    
    int presentationIndex = 0;
    if (presentation < 5) {
        presentationIndex = 0;
    }
    else if (presentation < 20){
        presentationIndex = 1;
    }
    else if (presentation < 45){
        presentationIndex = 2;
    }
    else if (presentation < 55){
        presentationIndex = 3;
    }
    else if (presentation < 80){
        presentationIndex = 4;
    }
    else if (presentation < 95){
        presentationIndex = 5;
    }
    else {
        presentationIndex = 6;
    }
    
    [_Presentation selectRow:presentationIndex inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"operation ok!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];

    }
    else {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"operation failed!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
        
    }
    
}

- (IBAction)submit:(id)sender {
    
    NSDictionary* dicToken = [AllDataManager sharedAllDataManager].dicToken;
    
    if (dicToken) {
        NSInteger likeIndex = [_likehood selectedRowInComponent:0];
        NSInteger reasoningIndex = [_Reasoning selectedRowInComponent:0];
        NSInteger presentationIndex = [_Presentation selectedRowInComponent:0];
        
        NSDictionary* rate = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:likehoodValue[likeIndex]],@"midLikelihood",[NSNumber numberWithInteger:presentationValue[presentationIndex]],@"presentation",[NSNumber numberWithInteger:reasoningValue[reasoningIndex]],@"reasoning", nil];
        
        NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys: rate, @"rate", nil];
        
        [[NetLogicInterface sharedNetLogicInterface] RequestRatingByToken:[dicToken objectForKey:@"access_token"]  andCommentID:[_answerDic objectForKey:@"id"] andRateDic:param andTaskID:@"RequestRatingByToken"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RequestRatingByToken" object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestRateFinished:) name:@"RequestRatingByToken" object:nil];
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
                                                       message: @"operation ok!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
    }
    else
    {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"tips"
                                                       message: @"operation failed!"delegate:self cancelButtonTitle:@"ok" otherButtonTitles: @"cancel", nil];
        
        [tips show];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:_likehood]) {
        return 7;
    }
    else if ([pickerView isEqual:_Reasoning]){
        return 7;
    }
    else if ([pickerView isEqual:_Presentation]){
        return 7;
    }
    
    return 0;
}

#pragma mark UIPickerViewDelegate

// title
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:_likehood]) {
        return [likehoodData objectAtIndex:row];
    }
    else if ([pickerView isEqual:_Reasoning]){
        return [reasoningData objectAtIndex:row];;
    }
    else if ([pickerView isEqual:_Presentation]){
        return [presentationData objectAtIndex:row];;
    }
    
    return @"";
}
// selected
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if ([pickerView isEqual:_likehood]) {
//        return [likehoodData objectAtIndex:row];
//    }
//    else if ([pickerView isEqual:_Reasoning]){
//        return [reasoningData objectAtIndex:row];;
//    }
//    else if ([pickerView isEqual:_Presentation]){
//        return [presentationData objectAtIndex:row];;
//    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel *lbl = (UILabel *)view;
    
    if (lbl == nil) {
        
        lbl = [[UILabel alloc]init];
        
        lbl.font = [UIFont systemFontOfSize:12];
        
        lbl.textColor = [UIColor blueColor];
        
        [lbl setBackgroundColor:[UIColor clearColor]];
        
    }
    
    //重新加载lbl的文字内容
    
    lbl.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return lbl;
}




@end
