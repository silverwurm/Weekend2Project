//
//  WebServicesHandler.m
//  WebServices
//
//  Created by Mac on 4/15/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "WebServicesHandler.h"


@implementation NSDictionary (NSDictionary_SubKeyLookup)
-(id) valueForKeySequence:(NSArray*)keySequence
{
    if([keySequence count] == 0)
        return nil;
    else
    {
        id temp = self;
        for(NSString* key in keySequence)
        {
            if(temp == nil)
                return nil;
            temp = [temp objectForKey:key];
        }
        return temp;
    }
}
@end

@implementation NSMutableDictionary (NSMutableDictionary_KeySequenceSet)

-(void)setValue:(id)value forKeySequence:(NSArray *)keySequence
{
    if([keySequence count] > 0)
    {
        id temp = self;
        for(int i = 0; i < ([keySequence count]-1); i++)
        {
            id temp2 = [temp valueForKey:keySequence[i]];
            if(!temp2)
            {
                //this sequence does not currently exist
                temp2 = [[NSMutableDictionary alloc] initWithCapacity:0];
                [temp setValue:temp2 forKey:keySequence[i]];
            }
            temp = temp2;
        }
        [temp setValue:value forKey:[keySequence lastObject]];
    }
}
@end


@implementation WebServicesHandler
{
    NSMutableData* webData;
    NSMutableDictionary* tempDictionary;
    NSMutableArray* ResultsArray;
    NSMutableArray* currentKeyPath;
    NSString* CurrentElement;
    NSArray* AcceptablePaths;
    bool IS_XML;
    NewsStory* CurrentStory;
}

-(NSArray*) SplitStringByRemovingHTMLTags:(NSString*)Input
{
    NSMutableArray* Array = [[NSMutableArray alloc] initWithCapacity:0];
    NSString* temp = Input;
    while([temp length] > 0)
    {
        //remove all tags
        NSString* TagTemplate = @"(<[^>]+>)+";
        NSRange r = [temp rangeOfString:TagTemplate options:NSRegularExpressionSearch];
        NSRange subStringRange;
        if(r.length == 0)
        {
            //all of temp is the string
            subStringRange = NSMakeRange(0, [temp length]);
        }
        else if(r.location == 0)
        {
            //html at the beginning
            temp = [temp stringByReplacingCharactersInRange:r withString:@""];
            r = [temp rangeOfString:TagTemplate options:NSRegularExpressionSearch];
            if(r.length == 0)
            {
                //all of temp is now the next string
                subStringRange = NSMakeRange(0, [temp length]);
            }
            else
            {
                subStringRange = NSMakeRange(0, r.location);
            }
        }
        else
        {
            subStringRange = NSMakeRange(0, r.location);
        }
        
        [Array addObject:[temp substringWithRange:subStringRange]];
        temp = [temp stringByReplacingCharactersInRange:subStringRange withString:@""];
    }
    return Array;
}
-(instancetype)init
{
    return self = [super init];
    
}
-(void) retrieveJSONDataAtURL:(NSString *)URL
{
    IS_XML = false;
    [self retrieveData:URL];
}
- (void)retrieveXMLDataAtURL:(NSString *)URL
{
    IS_XML = true;
    //AcceptablePaths = Paths;
    [self retrieveData:URL];
}
-(void) retrieveData:(NSString*)URL
{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"%@", response);
    webData = [NSMutableData new];
    ResultsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"%@", connection);
    if(IS_XML)
    {
        //parse the song data as xml
        NSXMLParser * myParser = [[NSXMLParser alloc] initWithData:webData];
        myParser.delegate = self;
        currentKeyPath = [[NSMutableArray alloc] initWithCapacity:0];
        tempDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        CurrentStory = nil;
        CurrentElement = nil;
        [myParser parse];
    }
    else
    {
        //parse the song data as JSON
        [self.delegate parsedData:[NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingAllowFragments error:nil]];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"item"])
    {
        CurrentStory = [[NewsStory alloc] init];
        [CurrentStory setDescription:@""];
    }
    //[currentKeyPath insertObject:elementName atIndex:[currentKeyPath count]];
    CurrentElement = elementName;
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"%@", currentKeyPath);
    //[currentKeyPath removeObjectAtIndex:[currentKeyPath count]-1];
    if([elementName isEqualToString:@"item"])
    {
        [ResultsArray addObject:CurrentStory];
        CurrentStory = nil;
    }
        
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(CurrentStory != nil)
    {
        if([CurrentElement isEqualToString:@"title"])
            [CurrentStory setTitle:string];
        else if([CurrentElement isEqualToString:@"description"])
        {
            //[CurrentStory setDescription:[[CurrentStory Description] stringByAppendingString:string]];
            [CurrentStory setDescription:string];
        }
        else if([CurrentElement isEqualToString:@"link"])
        {
            [CurrentStory setURL:[string stringByReplacingOccurrencesOfString:@"url=" withString:@""]];
        }
    }
    //check to see if this is one of the paths that need to be recorded
    /*bool addData = true;
    for(NSArray* tempArray in AcceptablePaths)
    {
        //NSLog(@"tempArray: %i", [tempArray count]);
        //NSLog(@"currentKeyPath: %i", [currentKeyPath count]);
        if([tempArray count] == [currentKeyPath count])
        {
            for(int j = 0; j < [currentKeyPath count]; j++)
            {
                if(![currentKeyPath[j] isEqualToString:tempArray[j]])
                {
                    addData = false;
                    break;
                }
            }
        }
        else
        {
            addData = false;
        }
        if(!addData)
            break;
    }
    if(addData)
        [tempDictionary setValue:string forKeySequence:currentKeyPath];*/
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.delegate parsedData:ResultsArray];
}
@end
