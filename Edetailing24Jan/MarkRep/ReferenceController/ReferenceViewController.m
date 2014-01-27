//
//  ReferenceViewController.m
//  MarkRep
//
//  Created by virupaksh on 21/08/13.
//  Copyright (c) 2013 virupaksh. All rights reserved.
//

#import "ReferenceViewController.h"
#import "ContentRefLinksViewController.h"
@interface ReferenceViewController ()

@end


@implementation ReferenceViewController
@synthesize aPath,referenceWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //aPath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"pdf"];
    
    NSData *data = [NSData dataWithContentsOfFile:aPath];

    referenceWebView.delegate=self;
    
    [referenceWebView loadData:data MIMEType: @"application/pdf" textEncodingName: nil baseURL:nil];
    

    UIBarButtonItem *aBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backPressed)];
    self.navigationItem.leftBarButtonItem = aBackButton;
    [aBackButton release];
    aBackButton = nil;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"Did Start");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"Did Finish");
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
        NSLog(@"Did Fail");
    
}



- (void)dealloc {
    [referenceWebView release];
    [super dealloc];
}
#pragma mark - Actions
- (void)backPressed {
//    ContentRefLinksViewController *RefLink = [[ContentRefLinksViewController alloc]init];
//    
//    [RefLink stopChildTimer];
//    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
    //[self dismissModalViewControllerAnimated:YES];
}
@end
