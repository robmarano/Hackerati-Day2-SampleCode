//
//  ViewController.m
//  HackeratiDay2SampleCode
//
//  Created by Kevin Tulod on 8/13/12.
//  Copyright (c) 2012 Kevin Tulod. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize hp_entries,jsonArray;
@synthesize articleHeadline,articleImage,articleSnippet;
@synthesize entryUrlString;
@synthesize bgActivityIndic;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // RESTKit
    [RKClient clientWithBaseURL:[NSURL URLWithString:@"http://www.huffingtonpost.com/"]];
    
    idx = 0;
}

- (void) viewWillAppear:(BOOL)animated
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"edition" forKey:@"us"];
    [[RKClient sharedClient] post:@"mobileweb/homepage_top_news.php" params:params delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// RestKit Functions
- (void)requestAndLoadArticles {
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"edition" forKey:@"us"];
    [[RKClient sharedClient] post:@"mobileweb/homepage_top_news.php" params:params delegate:self];
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
            
        }
        
    } else if ([request isPOST]) {
        
        // Handling POST /other.json
        if ([response isJSON]) {
            NSError *e = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:[response body] options:NSJSONReadingMutableContainers error:&e];
            
            if ([jsonObject isKindOfClass:[NSArray class]]) {
                NSLog(@"its an array!");
                jsonArray = (NSArray *)jsonObject;
                NSLog(@"jsonArray - %@",jsonArray);
            }
            else {
                NSLog(@"its probably a dictionary");
                hp_entries = (NSDictionary *)jsonObject;
                
                [self userRequestsArticle:idx];
            }
        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

- (void) requestImageInBackgroundWithURL:(NSArray *)params
{
    id sender = [params objectAtIndex:0];
    NSURL *url = [params objectAtIndex:1];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [(ViewController *) sender clearBackgroundThreadsWithImage:data];
}

- (void) clearBackgroundThreadsWithImage:(NSData *)data
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(clearBackgroundThreadsWithImage:) withObject:data waitUntilDone:NO];
    }
    else
     {
         articleImage.image = [UIImage imageWithData:data];
     }
}

- (void)userRequestsArticle:(int) number
{
    NSLog(@"Requesting: %i",idx);
    NSDictionary *currentArticle = [[hp_entries objectForKey:@"entries"] objectAtIndex:idx];
    
    articleHeadline.text = [currentArticle objectForKey:@"entry_headline"];
    articleSnippet.text = [currentArticle objectForKey:@"entry_title"];
    entryUrlString = [currentArticle objectForKey:@"entry_url"];
    entryId = [currentArticle objectForKey:@"entry_id"];
    NSLog(@"%@",entryUrlString);
    
    NSURL *url = [NSURL URLWithString:[currentArticle objectForKey:@"entry_image_large"]];
    
    [bgActivityIndic startAnimating];
    
    NSArray *params = [NSArray arrayWithObjects:self, url, nil];

    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(requestImageInBackgroundWithURL:) object:params];
    
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    [opQueue addOperation:operation];
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//    
//    dispatch_async(queue, ^{
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            articleImage.image = [UIImage imageWithData:data];
//            [bgActivityIndic stopAnimating];
//        });
//    });
    
//    NSURL *url = [NSURL URLWithString:[currentArticle objectForKey:@"entry_image_large"]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    articleImage.image = [UIImage imageWithData:data];
}

- (IBAction)userIncrementsArticle:(id)sender
{
    if (idx == [[hp_entries objectForKey:@"entries"] count] - 1) {
        idx = 0;
    } else {
        idx++;
    }
    
    [self userRequestsArticle:idx];
}

- (IBAction)userDecrementsArticle:(id)sender
{
    if (idx == 0) {
        idx = [[hp_entries objectForKey:@"entries"] count] - 1;
    } else {
        idx = idx - 1;
    }
    
    [self userRequestsArticle:idx];
}

//- (IBAction)userRequestsToReadArticle:(id)sender
//{
//    NSLog(@"User requesting to read article");
//    // instead of presenting this in Storyboard, we're doing it in code
//    ArticleViewController *articleViewController = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:[NSBundle mainBundle]];
//    articleViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    articleViewController.currentArticleUrlString = entryUrlString;
//    [self presentModalViewController:articleViewController animated:YES];
//}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    
    if ([[segue identifier] isEqualToString:@"toModal"]) {
        ArticleViewController *articleViewController = [segue destinationViewController];
        articleViewController.currentArticleUrlString = entryUrlString;
        articleViewController.entry_id = entryId;
    }
}

@end
