//
//  ViewController.m
//  DemoBackground
//
//  Created by kewei on 15/8/27.
//  Copyright (c) 2015年 hichao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableArray *_arrayReapt;
    NSTimer *_timer;
    BOOL _isBackgroundRun;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _scrollView.layer.borderWidth = 1;
    _scrollView.layer.borderColor = [[UIColor redColor] CGColor];
    _labelRepeat.numberOfLines = 0;
    _arrayReapt = [NSMutableArray array];
    //设置定时器输出时间
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeatPrint) userInfo:nil repeats:YES];
    //监听进入后台动作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationWillResignActiveNotification object:nil];
}
- (void)repeatPrint{
    [_arrayReapt insertObject:[self getCurrentTime] atIndex:0];
    NSLog(@"repeat is running:%@ and backgroundTimeRemaining:%0.1f", [self getCurrentTime],[UIApplication sharedApplication].backgroundTimeRemaining);
    NSString *text = [_arrayReapt componentsJoinedByString:@"\n"];
    _labelRepeat.text = text;
    [_labelRepeat sizeToFit];
    _scrollView.contentSize = _labelRepeat.frame.size;
}
- (NSString *) getCurrentTime{
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
-(IBAction)changedSuspendButton:(id)sender{
    NSLog(@"_switchSuspend status:%d", _switchSuspend.on);
    if(_switchSuspend.on){
        //暂停定时器
        [_timer setFireDate:[NSDate distantFuture]];
        
    }else{
        //继续定时器
        [_timer setFireDate:[NSDate distantPast]];
    }
}
-(IBAction)changedBackgroundRunButton:(id)sender{
    if(_switchBackgroundRun.on){
        _isBackgroundRun = YES;
    }else{
        _isBackgroundRun = NO;
    }
}

-(void)enterBackground{
    NSLog(@"task 's backgroundTimeRemaining :%.02f ", [UIApplication sharedApplication].backgroundTimeRemaining);
    if(!_isBackgroundRun){
        return;
    }
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier task;
    NSLog(@"task will create");
    task = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"task is end;");
        //该回调方法是在task时间用尽时激活
//        [app endBackgroundTask:task];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
