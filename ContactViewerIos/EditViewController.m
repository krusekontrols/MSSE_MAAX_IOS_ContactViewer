//
//  EditViewController.m
//  ContactViewerIos
//
//  Created by Mark Kruse on 3/26/13.
//  Copyright (c) 2013 Tiny Mission. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController()

@end

@implementation EditViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;

@synthesize contacts = _contacts;

- (id)initWithStyle:(UITableViewStyle)style
{
   // self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailName.text = [self.detailItem name];
        self.detailPhone.text = [self.detailItem phone];
        self.detailTitle.text = [self.detailItem title];
        self.detailEmail.text = [self.detailItem email];
        self.detailTwitterId.text = [self.detailItem twitterId];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    
    if(self.contacts.currentActiveIndex > -1)
    {
        NSNotification *notif = [NSNotification notificationWithName:@"detailReloadRequest" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
    else
    {
        NSNotification *notif = [NSNotification notificationWithName:@"masterReloadRequest" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
}


- (void)issuePutRequest: (Contact *) contact
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* url = [NSURL URLWithString:
                      [NSString stringWithFormat:@"http://contacts.tinyapollo.com/contacts/%@?key=maax",
                       self.detailItem._id]];
        
        // create the request!
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"PUT"];
        [request addValue:@"application/x-www-form-urlencoded"
       forHTTPHeaderField:@"Content-Type"];
        NSString *putData = [NSString stringWithFormat:@"name=%@&phone=%@&title=%@&email=%@&twitterId=%@",
                             contact.name, contact.phone, contact.title, contact.email, contact.twitterId];
        NSString *length = [NSString stringWithFormat:@"%d", [putData length]];
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[putData dataUsingEncoding:NSASCIIStringEncoding]];
        
        // get the response!
        NSHTTPURLResponse *reponse = nil;
        NSError* error = [[NSError alloc] init];
        [NSURLConnection sendSynchronousRequest:request
                      returningResponse:&reponse error:&error];
        
    });
}

- (void)issuePostRequest: (Contact *) contact
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* url = [NSURL URLWithString:
                      [NSString stringWithFormat:@"http://contacts.tinyapollo.com/contacts?key=maax"]];
        
        // create the request!
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/x-www-form-urlencoded"
       forHTTPHeaderField:@"Content-Type"];
        NSString *postData = [NSString stringWithFormat:@"name=%@&phone=%@&title=%@&email=%@&twitterId=%@",
                             contact.name, contact.phone, contact.title, contact.email, contact.twitterId];
        NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
        
        // get the response!
        NSHTTPURLResponse *reponse = nil;
        NSError* error = [[NSError alloc] init];
        NSData* responseData =[NSURLConnection sendSynchronousRequest:request
                                                    returningResponse:&reponse error:&error];
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
        NSDictionary * thisContactDict = [responseDict objectForKey:@"contact"];
        Contact* thisContact = [[Contact alloc] initWithName:[thisContactDict objectForKey:@"name"]
                                                    andPhone:[thisContactDict objectForKey:@"phone"]
                                                    andTitle:[thisContactDict objectForKey:@"title"]
                                                    andEmail:[thisContactDict objectForKey:@"email"]
                                                andTwitterId:[thisContactDict objectForKey:@"twitterId"]
                                                       andId:[thisContactDict objectForKey:@"_id"]];
        [self setDetailItem:thisContact];
        
    });
}


-(IBAction)onSaveContact:(id)sender {
 

    NSString *nam2 = self.detailName.text ;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"save contact"
                                                    message:nam2 //@"You need to do something here"
                                                   delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
    
    ///TODO  - need to save the edited value here!
    Contact *ct = [Contact alloc];

    if (ct) {
        ct.name = self.detailName.text ;
        ct.Phone = self.detailPhone.text ;
        ct.title = self.detailTitle.text ;
        ct.email = self.detailEmail.text ;
        ct.twitterId = self.detailTwitterId.text;
    }
    
    if(self.contacts.currentActiveIndex > -1 || self.detailItem)
    {
        [self issuePutRequest: ct];
    }
    else
    {
        [self issuePostRequest: ct];
    }
    
    //[self.contacts saveContactList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
