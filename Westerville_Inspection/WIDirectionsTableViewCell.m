/*
 WIDirectionsTableViewCell.m
 Westerville Inspection Demo -- Esri 2012 Dev Summit
 Copyright © 2012 Esri
 
 All rights reserved under the copyright laws of the United States
 and applicable international laws, treaties, and conventions.
 
 You may freely redistribute and use this sample code, with or
 without modification, provided you include the original copyright
 notice and use restrictions.
 
 See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
 
 */

#import "WIDirectionsTableViewCell.h"

@interface WIDirectionsTableViewCell () 

@property (nonatomic, retain) UIImageView   *currentDirectionImageView;

@end

@implementation WIDirectionsTableViewCell

@synthesize currentDirectionImageView   = _currentDirectionImageView;
@synthesize isSelectedDirection         = _isSelectedDirection;

- (void)dealloc
{
    self.currentDirectionImageView  = nil;
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"]];
        iv.frame = CGRectMake(self.frame.size.width - 48, 10, 60, 25);
        iv.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        iv.hidden = YES;
        
        self.currentDirectionImageView = iv;
        [iv release];
        
        [self addSubview:self.currentDirectionImageView];
    }
    
    return self;
}

- (void)setIsSelectedDirection:(BOOL)isSelectedDirection
{
    _isSelectedDirection = isSelectedDirection;
    self.currentDirectionImageView.hidden = !_isSelectedDirection;
}

@end
