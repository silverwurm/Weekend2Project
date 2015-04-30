//
//  NewsStory.m
//  Weekend2Project
//
//  Created by Mac on 4/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "NewsStory.h"

@implementation NewsStory{
    NSString* title;
    NSString* description;
    NSString* thumbnail_image_URL;
    NSString* Story_URL;
    UIImage* thumbnail_image;
    NSMutableData* ImageData;
}
-(void)setTitle:(NSString*)Title
{
    title = Title;
}
-(void)setDescription:(NSString*)Description
{
    description = Description;
}
-(void)setURL:(NSString*)URL
{
    Story_URL = URL;
}
-(void)setImageURL:(NSString*)IURL
{
    thumbnail_image_URL = IURL;
    thumbnail_image = [UIImage imageNamed:@"loading"];
    NSURL* url = [NSURL URLWithString:thumbnail_image_URL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}
-(NSString*)Title
{
    return title;
}
-(NSString*)Description
{
    return description;
}
-(NSString*)LinkURL
{
    return Story_URL;
}
-(UIImage*)Image
{
    return thumbnail_image;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    ImageData = [[NSMutableData alloc] init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [ImageData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    thumbnail_image = [UIImage imageWithData:ImageData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageLoadingComplete" object:self];

}

@end
