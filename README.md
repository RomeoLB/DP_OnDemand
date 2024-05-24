Project Description

The attached exported BA:Connected (BACon) presentation allows the use of a Dynamic playlist called "On-Demand-Feed", 

<img width="620" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/5ea59564-2ae7-4ca4-951e-30016c7731a5">


as the content source for an On Demand state in BA:Connected.

<img width="648" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/052db56c-3b20-4c1c-b0bb-7ae49605ba2b">


The On Demand state allows to playback a file stored in that state using a UDP message which correspond to the key derived from the title value assigned to it in the "On-Demand-Feed". 

<img width="606" alt="image" src="https://github.com/RomeoLB/DP_OnDemand/assets/136584791/8c0dbc43-2e99-4c53-a215-b920e37a0ece">

The "ParseDynPlaylistAndSetKey.brs" plugin is used to:
 1. look for a Dynamic playlist feed in the "feed_cache" folder on the player SD card
 2. parse the feed for all the files in the Dynamic/Playlist and extract their title name
 3. generate a string in the format "pentagon1.mp4:pentagon2.mp4:pentagon3.mp4"
 4. assign the generated string to a user variable called "OnDemandKeys"
 5. check/monitor feed update and regenerate the the string and update the user variable whenever a feed update takes place


