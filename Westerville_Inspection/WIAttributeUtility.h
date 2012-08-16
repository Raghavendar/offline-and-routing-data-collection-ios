/*
 WIAttributeUtility.h
 Westerville Inspection Demo -- Esri 2012 Dev Summit
 Copyright © 2012 Esri
 
 All rights reserved under the copyright laws of the United States
 and applicable international laws, treaties, and conventions.
 
 You may freely redistribute and use this sample code, with or
 without modification, provided you include the original copyright
 notice and use restrictions.
 
 See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
 
 */

/*
 Attribute Utility is a container class that will make it simpler to pass around 
information about regarding the popover, including the popupInfo, and the feature 
layer the featue comes from.  The utility will supply methods for field name dictionaries, 
decoding templated strings, etc.  
 */

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@class AGSPopup;
@class AGSFeatureType;
@class AGSFeatureLayer;
@class AGSDomain;
@class AGSField;

/* Object to pull information out of the popup for display purposes */
@interface WIAttributeUtility : NSObject 

@property (nonatomic, retain) AGSPopup *popup;
@property (nonatomic, retain) AGSFeatureType *featureType;
@property (nonatomic, retain) AGSFeatureLayer *featureLayer;

/*dictionary of actual attribute names to the labels that should be
presented  */
@property (nonatomic, retain) NSDictionary *fieldNamesDictionary;

/*dictionary of attribute names to the AGSField that defines the actual
field */
@property (nonatomic, retain) NSDictionary *fieldDictionary;

/*dictionary of AGSFields to the the corresponding FieldInfo in the
 popupInfo */
@property (nonatomic, retain) NSDictionary *fieldInfosDictionary;

//default initializer
- (id)initWithPopup:(AGSPopup *)popup;

//resolves attributes in a string with the attribute values
- (NSString *)stringByApplyingTemplatesToString:(NSString *)aString;

//string value for AGS field value
- (NSString *)attributeStringForField:(AGSField *)field;

- (AGSFieldType)fieldTypeForFieldInfo:(AGSPopupFieldInfo *)fieldInfo;
- (AGSDomain *)domainForFieldInfo:(AGSPopupFieldInfo *)fieldInfo;
- (int)lengthForFieldInfo:(AGSPopupFieldInfo *)fieldInfo;
- (NSString*)stringForDate:(NSDate*)date format:(AGSPopupFieldInfoDateFormat)format;

- (BOOL)isAStringField:(AGSField *)field;
- (BOOL)isANumberField:(AGSField *)field;
- (BOOL)isADateField:(AGSField *)field;

@end
