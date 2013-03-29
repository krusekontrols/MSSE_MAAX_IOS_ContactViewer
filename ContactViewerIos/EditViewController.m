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
    
    if(self.contacts.currentActiveIndex > -1)
    {
        [self.contacts editContactAtIndex:(self.contacts.currentActiveIndex) withContact:(ct)];
    }
    else
    {
        [self.contacts addContact:ct];
    }
    
    [self.contacts saveContactList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
