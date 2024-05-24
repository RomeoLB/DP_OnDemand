**Project Description**

The exported BA:Connected (BACon) presentation, available in this repo, allows the use of a Dynamic playlist called "On-Demand-Feed", 

<img width="620" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/5ea59564-2ae7-4ca4-951e-30016c7731a5">


as the content source for an "On Demand" state in BA:Connected.

<img width="735" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/2fc4fbfd-619f-46db-8658-d17b63d309ca">



The "On Demand" state allows to playback a file stored in that state using a UDP message which correspond to the key derived from the title value assigned to it in the "On-Demand-Feed". 

<img width="606" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/8c0dbc43-2e99-4c53-a215-b920e37a0ece">

The provided "ParseDynPlaylistAndSetKey.brs" plugin is used to:
 1. look for a Dynamic playlist feed in the "feed_cache" folder on the player SD card
 2. parse the feed for all the files in the Dynamic/Playlist and extract their title name
 3. generate a string in the format "pentagon1.mp4:pentagon2.mp4:pentagon3.mp4:pentagon4.mp4"
 4. assign the generated string to a user variable called "OnDemandKeys"
 5. check/monitor feed update and regenerate the the string and update the user variable whenever a feed update takes place


The Custom Device Web page which is accessible on port :8008,

<img width="851" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/eb7a27f7-c9e3-40e5-a6e4-7626790679fb">



queries the /GetUserVars endpoint for the "OnDemandKeys" user variable when clicking on the "refresh" button

<img width="892" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/1b43a798-5922-4cd7-b240-7da5b21a636e">

After clicking the "Refresh" button the Device Web page generates a button to send a UDP command for each one of the files that are part of the "OnDemandKeys" user variable string

<img width="849" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/ab453ea2-c46f-4949-9375-d03d94bf3dc7">

Please make sure to create a Dynamic Playlist called "On-Demand-Feed" on your Content Cloud account and to assign that Dynamic playlist as a source feed using the "Populate From Feed" option.

<img width="618" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/7a79febb-591e-4d7a-8ffd-7f498de2044f">

