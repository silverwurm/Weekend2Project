//
//  NewsStory.h
//  Weekend2Project
//
//  Created by Mac on 4/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsStory : NSObject <NSURLConnectionDataDelegate>
-(void)setTitle:(NSString*)Title;
-(void)setDescription:(NSString*)Description;
-(void)setURL:(NSString*)URL;
-(void)setImageURL:(NSString*)IURL;
//-(void)setImage:(UIImage*)Image;
//-(void)loadImage;
-(NSString*)Title;
-(NSString*)Description;
-(NSString*)LinkURL;
-(UIImage*)Image;
@end
