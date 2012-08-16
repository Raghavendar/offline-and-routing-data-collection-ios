/*
 WIContactsManager.m
 Westerville Inspection Demo -- Esri 2012 Dev Summit
 Copyright © 2012 Esri
 
 All rights reserved under the copyright laws of the United States
 and applicable international laws, treaties, and conventions.
 
 You may freely redistribute and use this sample code, with or
 without modification, provided you include the original copyright
 notice and use restrictions.
 
 See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
 
 */

#import "WIContactsManager.h"

//C pointer reference to self so C callback can get back into an Objective-C
//method
void *callbackSelf;

//AddressBook C function callback prototype
void somethingChangedInAddressBook ( ABAddressBookRef addressBook, CFDictionaryRef info, void *context);

@interface WIContactsManager ()
{
    ABAddressBookRef    _addressBook;
}

@property (nonatomic, retain, readwrite) NSArray *allContacts;
@property (nonatomic, retain, readwrite) NSArray *allContactsWithAddresses;

- (void)initializeAddressBook;
- (void)clearAddressBook;

@end


//AddressBook C function callback
void somethingChangedInAddressBook (
                                    ABAddressBookRef addressBook,
                                    CFDictionaryRef info,
                                    void *context
                                    )
{
    //call back into Objective-C method
    [(id)callbackSelf clearAddressBook];
}


@implementation WIContactsManager

@synthesize allContacts = _allContacts;
@synthesize allContactsWithAddresses = _allContactsWithAddresses;


//class method that returns a singleton object for 
//working with a device's contact list
//This method should be called instead of 
//trying to alloc init a user-defined instance
+ (WIContactsManager *)sharedContactsManager
{
    static WIContactsManager *instance;
    @synchronized(self)
    {
        if(!instance)
        {
            instance = [[WIContactsManager alloc] init];
            [instance initializeAddressBook];
            callbackSelf = instance;
        }
    }
    
    return instance;
}

//initialize member variable with the AddressBook
- (void)initializeAddressBook
{
    //wrapped in a synchronization mechanism just in case
    //singleton is hit in a multi-threaded environment
    @synchronized(self)
    {
        _addressBook = ABAddressBookCreate();
        
        //register object as the callback when something in the address book changes
        //from an external program, or another thread
        ABAddressBookRegisterExternalChangeCallback(
                                                    _addressBook,                   //addressBook in question
                                                    somethingChangedInAddressBook,  //callback method when something changes
                                                    self);                          //object to pass into callback, in this case need a referenc to self
    }
}

- (void)clearAddressBook
{
    @synchronized(self)
    {
        self.allContacts = nil;
        self.allContactsWithAddresses = nil;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"AddressBookContactChange" object:nil];
    }
}

//returns all contacts in user's address book
- (NSArray *)allContacts
{
    //wrapped in a synchronization mechanism just in case
    //singleton is hit in a multi-threaded environment
    @synchronized(self)
    {
        if(!_allContacts)
        {
            ABRecordRef source = ABAddressBookCopyDefaultSource(_addressBook);
            ABPersonSortOrdering ordering = ABPersonGetSortOrdering();
            NSArray *contacts = (NSArray*)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(_addressBook, source, ordering);
            self.allContacts = contacts;
            
            CFRelease(source);
            [contacts release];
        }
    }
    
    return _allContacts;
}

//returns all contacts in address book with addresses
- (NSArray *)allContactsWithAddresses
{
    //wrapped in a synchronization mechanism just in case
    //singleton is hit in a multi-threaded environment
    @synchronized(self)
    {
        if(!_allContactsWithAddresses)
        {
            NSMutableArray *contactsWithAddresses = [NSMutableArray arrayWithCapacity:10];
            
            int numContacts = self.allContacts.count;        
            for (int i = 0; i < numContacts; i++) {
                //grab the person record from list of contacts
                ABRecordRef person = [self.allContacts objectAtIndex:i];
                                
                //check to see if person has at least one address. If so, add to list
                ABMutableMultiValueRef addressMulti = ABRecordCopyValue(person, kABPersonAddressProperty);
                
                if (ABMultiValueGetCount(addressMulti) > 0) {
                    [contactsWithAddresses addObject:(id)person];
                }
                
                CFRelease(addressMulti);
            } 
            self.allContactsWithAddresses = contactsWithAddresses;
        }
    }
    
    return _allContactsWithAddresses;    
}

//returns a formatted name for a given record
+ (NSString *)nameForRecord:(ABRecordRef)record
{
    ABPersonCompositeNameFormat nameFormat = ABPersonGetCompositeNameFormat();
    
    NSString *firstName = [(NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty) autorelease];
    if (!firstName) {
        firstName = @"";
    }
    
    NSString *lastName = [(NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty) autorelease];
    if(!lastName)
    {
        lastName = @"";
    }
    
    NSString *firstString = (nameFormat == kABPersonCompositeNameFormatFirstNameFirst) ? firstName : lastName;
    NSString *lastString = (nameFormat == kABPersonCompositeNameFormatLastNameFirst) ? firstName : lastName;
    
    return [NSString stringWithFormat:@"%@ %@", firstString, lastString];
    
}

//returns a formatted string for the address given by a dictionary
+ (NSString *)stringForAddress:(NSDictionary *)address
{
    NSString *addressText = [NSString string];
    
    //assembly string from candidate address dictionary
    NSString *streetField = [address objectForKey:(NSString *)kABPersonAddressStreetKey];
    NSString *cityField = [address objectForKey:(NSString *)kABPersonAddressCityKey];
    NSString *stateField = [address objectForKey:(NSString *)kABPersonAddressStateKey];
    NSString *zipField = [address objectForKey:(NSString *)kABPersonAddressZIPKey];
    NSString *countryField = [address objectForKey:(NSString *)kABPersonAddressCountryKey];
    
    
    BOOL bAddComma = NO;
    BOOL bAddSpace = NO;
    
    if (streetField != nil)
    {
        addressText = [addressText stringByAppendingFormat:@"%@", streetField];
        bAddComma = YES;
    }
    if (cityField != nil)
    {
        addressText = [addressText stringByAppendingFormat:@"%@%@", (bAddComma ? @", " : @""), cityField];
        bAddComma = YES;
    }
    if (stateField != nil)
    {
        addressText = [addressText stringByAppendingFormat:@"%@%@", (bAddComma ? @", " : @""), stateField];
        bAddSpace = YES;
    }
    if (zipField != nil)
    {
        //no comma, just a space between state and Zip
        addressText = [addressText stringByAppendingFormat:@"%@%@", (bAddSpace ? @" " : @""), zipField];
        bAddSpace = YES;
    }            
    if (countryField != nil)
    {
        //no comma, just a space between state and Zip
        addressText = [addressText stringByAppendingFormat:@"%@%@", (bAddSpace ? @" " : @""), countryField];
    }           
    
    return addressText;
}


//make sure copying can't take place
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//don't alter retain count
- (id)retain
{
    return self;
}


//make sure user can't release sharedContacts
- (oneway void)release
{
    // do nothing
}  

//autorelease shouldn't do anything
- (id)autorelease
{
    return self;
}

//just a protection mechanism from contacts from ever being deallocated
- (NSUInteger)retainCount
{
    return NSUIntegerMax; // Random high number!
}

@end
