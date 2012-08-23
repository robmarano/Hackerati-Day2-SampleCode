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
@synthesize entry_id;
@synthesize articleWebView;
//@synthesize articleTextView;
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
    
    // RESTKit
    [RKClient clientWithBaseURL:[NSURL URLWithString:@"http://www.huffingtonpost.com/"]];

}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"url: %@", currentArticleUrlString);
    testLabel.text = currentArticleUrlString;
    
//    NSURL *url = [NSURL URLWithString: currentArticleUrlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [articleWebView loadRequest:request];
    
    NSArray *keys = [NSArray arrayWithObjects:@"t", @"ftext", @"entry_ids", nil];
    NSArray *values = [NSArray arrayWithObjects:@"entry", @"1", entry_id, nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:values forKeys:keys];
//    [[RKClient sharedClient] post:@"api/" params:params delegate:self];
    [[RKClient sharedClient] get:@"/api/" queryParameters:params delegate:self];
    
}

- (void)requestDidStartLoad:(RKRequest *)request
{
    //NSLog(@"RK Request description: %@",[request description]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    NSLog(@"Received response");
    if ([request isGET]) {
        // Handling GET /foo.xml
        NSLog(@"GET");
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
            if ([response isJSON]) {
                NSError *e = nil;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:[response body] options:NSJSONReadingMutableContainers error:&e];
                
                NSLog(@"its probably a dictionary");
                NSDictionary *entry = (NSDictionary *)jsonObject;
                [self extractEntryText:entry];
            }            
        }
        
    } else if ([request isPOST]) {
        // Handling POST /other.json
        if ([response isJSON]) {
            NSError *e = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:[response body] options:NSJSONReadingMutableContainers error:&e];
            
            NSLog(@"its probably a dictionary");
            NSDictionary *entry = (NSDictionary *)jsonObject;
            [self extractEntryText:entry];
        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

- (void)extractEntryText:(NSDictionary *)dic
{
    NSDictionary *outerdic = [dic objectForKey:@"response"];
    NSDictionary *innerdic = [outerdic objectForKey:entry_id];
    
    NSString *myText = [NSString stringWithFormat:@"<html><body>%@</body></html>",[innerdic objectForKey:@"entry_text"]];
    NSLog(myText);
//    articleTextView.text = [innerdic objectForKey:@"entry_text"];
    [articleWebView loadHTMLString:myText baseURL:nil];
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
