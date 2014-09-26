//
//  InstagramViewController.h
//  InstagramApp
//
//  Created by Yang Zi on 9/24/14.
//  Copyright (c) 2014 Yang Zi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXReorderableCollectionViewFlowLayout.h"

@interface InstagramViewController : UICollectionViewController<UIWebViewDelegate, LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSArray* images;
@property (nonatomic, strong) NSString* accessToken;

@property (strong, nonatomic) NSMutableArray *deck;

@end
