//
//  MasterViewController.m
//  ContactViewerIos
//
//  Created by ANDY SELVIG on 3/7/12.
//  Copyright (c) 2012 Tiny Mission. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "EditViewController.h"

#import "Contact.h"

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;

//mek?
@synthesize editViewController = _editViewController;

@synthesize myTableView;
@synthesize contacts;

- (void)awakeFromNib
{
    // get the contact list
    
    [self issueGetRequest];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}


- (void)issueGetRequest
{
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        [request setURL:[ NSURL URLWithString: [ NSString stringWithFormat: @"http://contacts.tinyapollo.com/contacts?key=maax"] ]];
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
    [ContactList initSingleton: responseDict];
    contacts = [ContactList singleton];
    [self.myTableView reloadData];
}

- (void)issueDeleteRequest: (NSString *) contactId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* url = [NSURL URLWithString:
                      [NSString stringWithFormat:@"http://contacts.tinyapollo.com/contacts/%@?key=maax",
                       contactId]];
                       
        // create the request!
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
                       [request setURL:url];
        [request setHTTPMethod:@"DELETE"];
        // get the response!
        NSHTTPURLResponse *reponse = nil;
        NSError* error = [[NSError alloc] init];
        [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&reponse error:&error];
        
        [self issueGetRequest];
    });
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
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.editViewController = (EditViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    //add delete button
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem.title = @"Del";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(issueGetRequest)
                                                 name:@"masterReloadRequest"
                                               object:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // Make sure you call super first
    [super setEditing:editing animated:animated];
    
    if (!editing)
    {
        self.editButtonItem.title = @"Del";
    }
}



- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
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


#pragma mark - Table View Data Source
/*
-(IBAction)onAddContact:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Contact"
                                                    message:@"You need to do something here"
                                                   delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
}
*/

#pragma mark - Table View Data Source

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contacts count];
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // get or create the cell
    static NSString *CellIdentifier = @"ContactCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    
    // set the content in the cell based on the contact
    Contact* contact = [contacts contactAtIndex:indexPath.row];
    cell.textLabel.text = contact.name;
    // this is a bit of a hack, but now we don't need to make a custom cell item
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@            %@", 
                                 contact.phone, contact.title];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.detailViewController.detailItem = [contacts contactAtIndex:indexPath.row];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        Contact* contact = [contacts contactAtIndex:indexPath.row];
        [self issueDeleteRequest:contact._id];
        //[contacts removeContactAtIndex:indexPath.row];
        //[contacts saveContactList];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    
         
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    
    
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    
   
        DetailViewController *detailController = segue.destinationViewController;
        if([identifier isEqualToString:@"showDetail"])
        {
            Contact *ct = [contacts contactAtIndex:self.tableView.indexPathForSelectedRow.row];
            detailController.detailItem = ct;
        
            //set the index # in contacts instance
            contacts.currentActiveIndex = self.tableView.indexPathForSelectedRow.row;
        }
        else {
             contacts.currentActiveIndex = -1;
        }
        detailController.contacts = contacts;
}

@end
