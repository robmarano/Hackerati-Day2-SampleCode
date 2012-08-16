//
//  ArticleViewController.m
//  HackeratiDay2SampleCode...
//
//  Created by Rob Marano on 8/14/12.
//  Copyright (c) 2012 Kevin Tulod. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController

@synthesize currentArticleUrlString;
@synthesize articleWebView;
@synthesize testLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"url: %@", currentArticleUrlString);
    testLabel.text = currentArticleUrlString;
    
    NSURL *url = [NSURL URLWithString: currentArticleUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [articleWebView loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissModalViewController:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
