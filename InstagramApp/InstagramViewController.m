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
#import "MediaCell.h"

const NSInteger kthumbnailWidth = 80;
const NSInteger kthumbnailHeight = 80;
const NSInteger kImagesPerRow = 4;

@interface InstagramViewController ()

@end

@implementation InstagramViewController

@synthesize webView;
@synthesize accessToken;
@synthesize images;
@synthesize deck;

#define LX_LIMITED_MOVEMENT 0

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+20, self.view.bounds.size.width, self.view.bounds.size.height);
    
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
    
    deck = [[NSMutableArray alloc]init];

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
    
        int i = 0;
        for (InstagramUserMedia* image in records) {
            Media *media = [[Media alloc] init];
            NSString* thumbnailUrl = image.thumbnailUrl;
           
            NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];
            UIImage* image = [UIImage imageWithData:data];
            media.image = image;
            media.tag = [NSNumber numberWithInt:i];
            [deck addObject:media];
            i++;
        }
    
        [self.collectionView reloadData];
    }];
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

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex {
    return self.deck.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Media *media = self.deck[indexPath.item];
    MediaCell *mediaCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCell" forIndexPath:indexPath];
    mediaCell.media = media;
    
    return mediaCell;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    Media *media = self.deck[fromIndexPath.item];
    
    [self.deck removeObjectAtIndex:fromIndexPath.item];
    [self.deck insertObject:media atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
#if LX_LIMITED_MOVEMENT == 1
    Media *media = self.deck[indexPath.item];
#else
    return YES;
#endif
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
#if LX_LIMITED_MOVEMENT == 1
    Media *fromMedia = self.deck[fromIndexPath.item];
    Media *toMedia = self.deck[toIndexPath.item];
#else
    return YES;
#endif
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did end drag");
}

@end
