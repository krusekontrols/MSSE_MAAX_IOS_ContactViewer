//
//  DetailViewController.m
//  ContactViewerIos
//
//  Created by ANDY SELVIG on 3/7/12.
//  Copyright (c) 2012 Tiny Mission. All rights reserved.
//

#import "DetailViewController.h"
#import "EditViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize editViewController = _editViewController;

@synthesize contacts = _contacts;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailName.text = [self.detailItem name];
        self.detailPhone.text = [self.detailItem phone];
        self.detailTitle.text = [self.detailItem title];
        self.detailEmail.text = [self.detailItem email];
        self.detailTwitterId.text = [self.detailItem twitterId];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.editViewController = (EditViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.contacts = _contacts;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(issueGetRequest)
                                                 name:@"detailReloadRequest"
                                               object:nil];
}

- (void)viewDidUnload
{
    
    [self setDetailName:nil];
    [self setDetailPhone:nil];
    [self setDetailEmail:nil];
    [self setDetailTitle:nil];
    [self setDetailTwitterId:nil];
    [self setDetailTitle:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)issueGetRequest
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* url = [NSURL URLWithString:
                      [NSString stringWithFormat:@"http://contacts.tinyapollo.com/contacts/%@?key=maax",
                       self.detailItem._id]];
        
        // create the request!
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        // get the response!
        NSHTTPURLResponse *reponse = nil;
        NSError* error = [[NSError alloc] init];
        NSData* responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&reponse error:&error];
        
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:responseDict waitUntilDone:YES];
        
      });
}


- (void)receiveData:(NSDictionary *)responseDict {
    NSDictionary * thisContactDict = [responseDict objectForKey:@"contact"];
    Contact* thisContact = [[Contact alloc] initWithName:[thisContactDict objectForKey:@"name"]
                                                andPhone:[thisContactDict objectForKey:@"phone"]
                                                andTitle:[thisContactDict objectForKey:@"title"]
                                                andEmail:[thisContactDict objectForKey:@"email"]
                                            andTwitterId:[thisContactDict objectForKey:@"twitterId"]
                                                   andId:[thisContactDict objectForKey:@"_id"]];
    [self setDetailItem:thisContact];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //update here
    
    self.detailItem = [self.contacts contactAtIndex:self.contacts.currentActiveIndex];
    
    self.detailName.text = [self.detailItem name];
    self.detailPhone.text = [self.detailItem phone];
    self.detailTitle.text = [self.detailItem title];
    self.detailEmail.text = [self.detailItem email];
    self.detailTwitterId.text = [self.detailItem twitterId];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    NSNotification *notif = [NSNotification notificationWithName:@"masterReloadRequest" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    
    if([identifier isEqualToString:@"showEdit"])
    {
        DetailViewController *detailController = segue.destinationViewController;
        //Contact *ct = [contacts contactAtIndex:self.tableView.indexPathForSelectedRow.row];
        detailController.detailItem = self.detailItem;
        detailController.contacts = self.contacts;
    }
    
    
}
@end
