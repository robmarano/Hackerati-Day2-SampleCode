//
//  ArticleViewController.h
//  HackeratiDay2SampleCode
//
//  Created by Rob Marano on 8/14/12.
//  Copyright (c) 2012 Kevin Tulod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController
{
    NSString *currentArticleUrlString;
    IBOutlet UIWebView *articleWebView;
    IBOutlet UILabel *testLabel;
}

- (IBAction)dismissModalViewController:(id)sender;

@property (atomic, strong) NSString *currentArticleUrlString;
@property (atomic, strong) IBOutlet UIWebView *articleWebView;
@property (atomic, strong) IBOutlet UILabel *testLabel;

@end
