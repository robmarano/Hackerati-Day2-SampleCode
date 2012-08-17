//
//  ViewController.h
//  HackeratiDay2SampleCode
//
//  Created by Kevin Tulod on 8/13/12.
//  Copyright (c) 2012 Kevin Tulod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "ArticleViewController.h"

@interface ViewController : UIViewController <RKRequestDelegate>
{
    NSDictionary *hp_entries;
    NSArray *jsonArray;
    int idx;
    
    NSString *entryUrlString;
    NSString *entryId;
    
    IBOutlet UITextView *articleHeadline;
    IBOutlet UITextView *articleSnippet;
    IBOutlet UIImageView *articleImage;

}

@property (atomic,strong) NSDictionary *hp_entries;
@property (atomic,strong) NSArray *jsonArray;

@property (atomic, strong) IBOutlet UITextView *articleHeadline;
@property (atomic, strong) IBOutlet UITextView *articleSnippet;
@property (atomic, strong) IBOutlet UIImageView *articleImage;
@property (atomic, strong) NSString *entryUrlString;
@property (atomic, strong) NSString *entryId;

// RESTKit
- (void)requestAndLoadArticles;
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response;

// Article Requests
- (void)userRequestsArticle:(int) number;
- (IBAction)userIncrementsArticle:(id)sender;
- (IBAction)userDecrementsArticle:(id)sender;
@end
