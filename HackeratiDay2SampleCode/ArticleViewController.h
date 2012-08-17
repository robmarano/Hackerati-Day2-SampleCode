//
//  ArticleViewController.h
//  HackeratiDay2SampleCode
//
//  Created by Rob Marano on 8/14/12.
//  Copyright (c) 2012 Kevin Tulod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface ArticleViewController : UIViewController <RKRequestDelegate>
{
    NSString *currentArticleUrlString;
    NSString *entry_id;
    
//    IBOutlet UIWebView *articleWebView;
    IBOutlet UITextView *articleTextView;
    IBOutlet UILabel *testLabel;
}

- (IBAction)dismissModalViewController:(id)sender;
- (void)extractEntryText:(NSDictionary *)dic;
- (void)requestDidStartLoad:(RKRequest *)request;
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response;

@property (atomic, strong) NSString *currentArticleUrlString;
@property (atomic, strong) NSString *entry_id;
//@property (atomic, strong) IBOutlet UIWebView *articleWebView;
@property (atomic, strong) IBOutlet UITextView *articleTextView;
@property (atomic, strong) IBOutlet UILabel *testLabel;

@end
