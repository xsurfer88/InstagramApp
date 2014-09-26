//
//  InstagramUserMedia.h
//  InstagramApp
//
//  Created by Yang Zi on 9/24/14.
//  Copyright (c) 2014 Yang Zi. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface InstagramUserMedia : NSObject

@property (nonatomic, strong) NSString* thumbnailUrl;
@property (nonatomic, strong) NSString* standardUrl;
@property (nonatomic, assign) NSUInteger likes;

@property (assign, nonatomic) NSInteger rank;

+ (void)getUserMediaWithTag:(NSString*)tagName
           withAccessToken:(NSString*)accessToken
                     block:(void (^)(NSArray *records))block;


@end
