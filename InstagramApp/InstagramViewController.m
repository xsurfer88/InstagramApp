//
//  InstagramViewController.m
//  InstagramApp
//
//  Created by Yang Zi on 9/24/14.
//  Copyright (c) 2014 Yang Zi. All rights reserved.
//

#import "InstagramViewController.h"
#import "YZInstagram.h"
#import "AFHTTPRequestOperation.h"
#import "InstagramUserMedia.h"

const NSInteger kthumbnailWidth = 80;
const NSInteger kthumbnailHeight = 80;
const NSInteger kImagesPerRow = 4;

@interface InstagramViewController ()

@end

@implementation InstagramViewController

@synthesize webView;
@synthesize gridScrollView;
@synthesize accessToken;
@synthesize thumbnails;
@synthesize images;
@synthesize pageTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [super viewDidLoad];
    
    self.thumbnails = [[NSMutableArray alloc] init];
    
    CGRect frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+20, self.view.bounds.size.width, self.view.bounds.size.height);
    self.gridScrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.gridScrollView.contentSize = self.view.bounds.size;
    [self.view addSubview:self.gridScrollView];
    
    // create a webview
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    NSURLRequest* request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:
                                  [NSString stringWithFormat:kAuthenticationEndpoint, kClientId, kRedirectUrl]]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([request.URL.absoluteString rangeOfString:@"#"].location != NSNotFound) {
        NSString* params = [[request.URL.absoluteString componentsSeparatedByString:@"#"] objectAtIndex:1];
        self.accessToken = [params stringByReplacingOccurrencesOfString:@"access_token=" withString:@""];
        self.webView.hidden = YES;
        [self requestImages];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.accessToken forKey:kUserAccessTokenKey];
        [defaults synchronize];
    }
    
	return YES;
}

#pragma mark - image loading

- (void)requestImages
{
    [InstagramUserMedia getUserMediaWithTag:@"selfie" withAccessToken:self.accessToken block:^(NSArray *records) {
        self.images = records;
        int item = 0, row = 0, col = 0;
        for (NSDictionary* image in records) {
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(col*kthumbnailWidth,
                                                                          row*kthumbnailHeight,
                                                                          kthumbnailWidth,
                                                                          kthumbnailHeight)];
            button.tag = item;
            [button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
            ++col;++item;
            if (col >= kImagesPerRow) {
                row++;
                col = 0;
            }
            [self.gridScrollView addSubview:button];
            [self.thumbnails addObject:button];
        }
        [self loadImages];
    }];
}

- (void)loadImages
{
    int item = 0;
    
    for (InstagramUserMedia* media in self.images) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
            NSString* thumbnailUrl = media.thumbnailUrl;
            NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];
            UIImage* image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                UIButton* button = [self.thumbnails objectAtIndex:item];
                [button setImage:image forState:UIControlStateNormal];
            });
        });
        ++item;
    }
    
}

-(void)tapAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    //bring to front doesn't work
    [self.view bringSubviewToFront:button];
    
    button.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        // animate it to 200% scale
        button.transform = CGAffineTransformMakeScale(2.0, 2.0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            // animate it back to position
            button.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished){
            }];
    }];

}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    UIControl *control = sender;
    
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    control.center = center;
}

@end
