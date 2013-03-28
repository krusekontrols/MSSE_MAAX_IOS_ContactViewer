//
//  ContactList.m
//  ContactViewerIos
//
//  Created by ANDY SELVIG on 3/7/12.
//  Copyright (c) 2012 Tiny Mission. All rights reserved.
//

#import "ContactList.h"

static ContactList* _singleton = nil;
static int activeCurrent = -1;

@implementation ContactList

@synthesize allContacts=_contacts;

//@synthesize currentActiveIndex = _currentActiveIndex;

-(id)initWithCapacity:(NSInteger)capacity {
    self = [super init];
    _contacts = [[NSMutableArray alloc] initWithCapacity:capacity];
    return self;
}

//TODO Need a data store we can edit and save.

+(void)initSingleton {
    // Data.plist code
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"contacts.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property liost into dictionary object
    NSArray *temp = (NSArray *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    _singleton = [[ContactList alloc] initWithCapacity:[temp count]];
    
    for (NSDictionary *key in temp) {
        [_singleton addContact:[[Contact alloc] initWithName:[key objectForKey:@"name"]
                                                    andPhone:[key objectForKey:@"phone"]
                                                    andTitle:[key objectForKey:@"title"]
                                                    andEmail:[key objectForKey:@"email"]
                                                andTwitterId:[key objectForKey:@"twitterId"]]];
    }
}

-(void)addContact:(Contact*)contact {
    [_contacts addObject:contact];
}

-(Contact*)contactAtIndex:(NSInteger)index {
    return [_contacts objectAtIndex:index];
}

+(ContactList*)singleton {
    return _singleton;
}

-(NSInteger)count {
    return [_contacts count];
}

-(void)editContactAtIndex:(NSInteger)index
               withContact:(Contact*)newcontact{
    
    [_contacts removeObjectAtIndex:(index)];
    [_contacts insertObject:newcontact atIndex:(index)];

}

-(void)removeContactAtIndex:(NSInteger)index {
    
    [_contacts removeObjectAtIndex:(index)];
   
}


-(NSInteger)currentActiveIndex
{
    return activeCurrent;
}

-(void)setCurrentActiveIndex:(NSInteger)index
{
    activeCurrent = index;
}
@end
