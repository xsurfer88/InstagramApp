//
//  YZInstagram.h
//  InstagramApp
//
//  Created by Yang Zi on 9/24/14.
//  Copyright (c) 2014 Yang Zi. All rights reserved.
//

#import "YZInstagram.h"

#import "AFJSONRequestOperation.h"

NSString * const kInstagramBaseURLString = @"https://api.instagram.com/v1/";
NSString * const kClientId = @"b4a9bffdc1924be3bb14aaae0424e9ff";
NSString * const kRedirectUrl = @"http://127.0.0.1/test";
NSString* const kUserAccessTokenKey = @"kUserAccessTokenKey";

// Endpoints
NSString * const kAuthenticationEndpoint = 
    @"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token";
NSString * const kTagsEndpoint = @"tag/search";
NSString * const kTagsMediaRecentEndpoint = @"tags/%@/media/recent";

@implementation YZInstagram

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithBaseURL:(NSURL *)url 
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

+ (YZInstagram *)sharedClient
{
    static YZInstagram * _sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kInstagramBaseURLString]];
    });
    
    return _sharedClient;
}

@end
