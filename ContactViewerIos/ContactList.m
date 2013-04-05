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

+(void)initSingleton: (NSDictionary *) responseDict{

    _singleton = [[ContactList alloc] initWithCapacity:[[responseDict objectForKey:@"contacts"] count]];
    
    for (NSDictionary *thisContactDict in [responseDict objectForKey:@"contacts"]) {
        [_singleton addContact:[[Contact alloc] initWithName:[thisContactDict objectForKey:@"name"]
                                                    andPhone:[thisContactDict objectForKey:@"phone"]
                                                    andTitle:[thisContactDict objectForKey:@"title"]
                                                    andEmail:[thisContactDict objectForKey:@"email"]
                                                andTwitterId:[thisContactDict objectForKey:@"twitterId"]
                                                andId:[thisContactDict objectForKey:@"_id"]]];
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
