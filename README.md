Westerville Inspection Demo
Esri 2012 Developer Summit
Copyright © 2012 Esri
 
All rights reserved under the copyright laws of the United States
and applicable international laws, treaties, and conventions.

You may freely redistribute and use this sample code, with or
without modification, provided you include the original copyright
notice and use restrictions.

See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm

This sample is a complete application for viewing, creating, and editing inspections
of assets in the field. The application allows the user to take his data offline so he/she
can work out in the field without a connection.

---------------------------------
How to Use This Sample App
---------------------------------

To learn how this app works from a user perspective we recommend that you watch
the video demonstrating this app at the 2012 Esri Developer Summit.  The app
demo is in Part 2 of the Plenary Session video starting at 9:42 into the video.
The video can be found at the following URL:

  http://www.esri.com/events/devsummit/videos/video2.html

To learn how this app was written and how the code works we recommend that you
watch the two videos from the iOS Technical Workshops from the 2012 Esri 
Developer Summit.  Those videos can be found at:

  http://video.esri.com/watch/1170/building-applications-with-arcgis-runtime-sdk-for-iospart-i
  http://video.esri.com/watch/1177/building-applications-with-arcgis-runtime-sdk-for-iospart-ii


---------------------------------
Using/Modifying the Sample
---------------------------------

WIConstants.h:
   There are several constants that you can modify to make the application work with your own authored web map. 
   This includes the web map ID, the portal URL, routing services, etc.
   

sample.csv:
    If you would like to add your own stops via email, follow the template shown in sample.csv. Opening a csv 
    file via email on your device will give you the option to view it in this application.
    
Note: 
    When using an offline tile package, the projection (spatial reference) for the tile package must be the same
    as the projection for the web map's base map.   Feature layers are not reprojected to a different projection.

Custom URI:
    The application supports initiating an inspection via a custom URI. Custom URI's take on the following form:
    
    inspectiondemo://(Feature Layer Name)/(Object ID of feature to inspect)
    
    Here is a sample: inspectiondemo://ReferenceLayer3%20-%20Reference%20Layer%203/20
    
    You can open this link via email or text message, and the application will automatically open and begin an inspection
    of the feature with object ID 20.
