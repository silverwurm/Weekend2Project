//
//  WebServicesHandler.h
//  WebServices
//
//  Created by Mac on 4/15/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsStory.h"

#define NonDictionaryLabel

@protocol SegueDataDelegate <NSObject>
-(void)passSegueData:(NSDictionary*)Data;
@end
@interface NSDictionary (NSDictionary_SubKeyLookup)
-(id) valueForKeySequence:(NSArray*)keySequence;
@end

@interface NSMutableDictionary (NSMutableDictionary_KeySequenceSet)
-(void) setValue:(id)value forKeySequence:(NSArray*)keySequence;
@end

@protocol WebServicesHandlerDelegate <NSObject>
@required
-(void)parsedData:(NSArray*)Results;

@end

@interface WebServicesHandler : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate, NSXMLParserDelegate, NSXMLParserDelegate>
@property (nonatomic, weak) id <WebServicesHandlerDelegate> delegate;
-(void) retrieveXMLDataAtURL:(NSString*)URL;
-(void) retrieveJSONDataAtURL:(NSString*)URL;

@end
