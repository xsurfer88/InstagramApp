//
//  MediaCell.h
//  InstagramApp
//
//  Created by Yang Zi on 9/24/14.
//  Copyright (c) 2014 Yang Zi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "InstagramUserMedia.h"
#import "Media.h"

@class Media;

@interface MediaCell : UICollectionViewCell

@property (strong, nonatomic) Media *media;
@property (strong, nonatomic) IBOutlet UIImageView *mediaImageView;

@end
