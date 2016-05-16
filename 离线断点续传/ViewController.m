//
//  ViewController.m
//  离线断点续传
//
//  Created by liujianjian on 16/5/11.
//  Copyright © 2016年 rdg. All rights reserved.
//

#import "ViewController.h"
#import "JJDownloadManager.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)dealloc {
    
    NSLog(@"界面2释放了");
//    [self.label removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)download:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *str = @"http://ardownload.adobe.com/pub/adobe/reader/win/11.x/11.0.00/zh_CN/AdbeRdr11000_zh_CN.exe";
    
    [[JJDownloadManager sharedInstances] downloadUrl:str progress:^(CGFloat progress) {
//        NSLog(@"currentThread = %@", [NSThread currentThread]);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.label.text = [NSString stringWithFormat:@"%f", progress];
        });
        
        NSLog(@"progress = %f", progress);
    } complete:^(NSError *error, NSString *filePath) {
        NSLog(@"%@---%@", error, filePath);
    }];
}




@end
