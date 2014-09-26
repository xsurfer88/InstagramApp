//
//  InstagramViewController.h
//  InstagramApp
//
//  Created by Yang Zi on 9/24/14.
//  Copyright (c) 2014 Yang Zi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) UIScrollView* gridScrollView;
@property (nonatomic, strong) NSArray* images;
@property (nonatomic, strong) NSMutableArray* thumbnails;
@property (strong, nonatomic) IBOutlet UILabel *pageTitle;

@property (nonatomic, strong) NSString* accessToken;

@end
