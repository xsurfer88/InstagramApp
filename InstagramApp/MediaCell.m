//
//  Media.m
//  InstagramApp
//
//  Created by Yang Zi on 9/24/14.
//  Copyright (c) 2014 Yang Zi. All rights reserved.
//


#import "MediaCell.h"

@implementation MediaCell

@synthesize media = _media;

- (void)setMedia:(Media *)media{
    _media = media;
    self.mediaImageView.image = _media.image;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.mediaImageView.alpha = highlighted ? 0.75f : 1.0f;
}

@end
