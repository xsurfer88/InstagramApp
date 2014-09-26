//
//  YZInstagram.h
//  InstagramApp
//
//  Created by Yang Zi on 9/24/14.
//  Copyright (c) 2014 Yang Zi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

extern NSString * const kInstagramBaseURLString;
extern NSString * const kClientId;
extern NSString * const kRedirectUrl;

extern NSString * const kUserAccessTokenKey;

// Endpoints
extern NSString * const kAuthenticationEndpoint;
extern NSString * const kTagsEndpoint;
extern NSString * const kTagsMediaRecentEndpoint;

@interface YZInstagram : AFHTTPClient

+ (YZInstagram *)sharedClient;
- (id)initWithBaseURL:(NSURL *)url;

@end
