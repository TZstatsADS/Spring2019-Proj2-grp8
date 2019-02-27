# Project 2: Shiny App Development Version 2.0

### [Project Description](doc/project2_desc.md)

![screenshot](doc/welcome.png)
![screenshot](doc/Search.png)
![screenshot](doc/FeelingLucky.png)

In this second project of GR5243 Applied Data Science, we develop a version 2.0 of an *Exploratory Data Analysis and Visualization* shiny app: *Day Planner* on travel advising using [NYC Open Data](https://opendata.cityofnewyork.us/) and data scrwalled using Google API. See [Project 2 Description](doc/project2_desc.md) for more details.  

## Day Planner: a shiny app for travel advising
Term: Spring 2019

+ Team #8
+ **Team members**: 
	+ Charlie Chen: zc2422@gsb.columbia.edu
	+ Yuqiao Li: yl3965@columbia.edu
	+ Weixuan Wu: ww2493@columbia.edu
	+ Caihui Xiao: cx2225@columbia.edu
	+ Xiaoxi Zhao: xz2740@columbia.edu

+ **Project summary**: In this second project of GR5243 Applied Data Science, we built a demo app to assit users in choosing places they would like to visit in New York City. Based on shiny app projects conducted by group 6 (Fall 2017) and group 14 (Spring 2017), we have integrated datasets of businesses, such as restaurants, museums and theatres, and organized to display various business information in a data table and to visualize the places in maps to further enhance users' experience.
	+ Search Page: Users can select their own choice of places (up to three choices) and can specify restaurant type in the top left panel. Key business information of the selected businesses will be displayed in the left table. The right panel shows the heatmap of the businesses in New York City. Users can zoom in and out using the "+" and "-" button on the top left of the map. Businesses displayed on the data table will automatically change as the users interacting with the city map. Key information of the businesses, such as Name, Tel, and Address are available on the map if clicked.
	
	+ Feeling Lucky Page: On this page, we will provide travel suggestions for users who do not specify their travel preferences. Users can enter their current location on input box. The App will track users' address and show users' current location on a pop-up map after users clicking "confirm" next to the input box. Click "Feeling lucky", and the App will provide travel suggestions for three random places within users' specified distance, including one restaurant and two businesses from another two random categories. Click "Feeling lucky" again to get a different travel suggestion.

+ **Data Source**: We primarily used data from NYC Open Data. In addition, we utilized Google API during data processing. For data sources detail, please check [data source description](doc/project2_desc.md).

+ **Contribution statement**: (See [Note on contributions](doc/a_note_on_contributions.md) for more details ) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 
	+ Data Acquisition
		+ updated museum dataset: cx2225
		+ online scraped
		+ something else
	+ Data Cleaning
		+ things did 1: uni1, uni2, uni3
		+ things did 2: uni1, uni2, uni3
	+ Data Processing
		+ things did 1: uni1, uni2, uni3
		+ things did 2: uni1, uni2, uni3
	+ UI Design
		+ Created the three-page frame: cx2225
		+ things did 1: uni1, uni2, uni3
		+ things did 2: uni1, uni2, uni3
	+ Server - Welcome Page
		+ things did 1: uni1, uni2, uni3
		+ things did 2: uni1, uni2, uni3
	+ Server - Search Page
		+ Input selection : cx2225
		+ Datatable ouput : cx2225
		+ Reset map button: cx2225
		+ Create Map : cx2225
		+ Map with markers : cx2225
		
		+ things did 2: uni1, uni2, uni3
	+ Server - Feeling Lucky Page
		+ Initial map show at New York: cx2225
		+ things did 1: uni1, uni2, uni3
		+ things did 2: uni1, uni2, uni3
		
	+ Publish: yl3965
		
	
	Debug : zc2422, yl3965, ww2493, cx2225, xz2740
	
+ **Reference**: We used part of the codes from [group 6 (Fall 2017)](https://github.com/TZstatsADS/Fall2017-project2-grp6) as reference for data visualization. The feeling lucky page of our APP was inferred from the random choice page of [group 14 (Spring 2017)](https://github.com/TZstatsADS/Spr2017-proj2-grp14). Please cite the repository with citations.

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── app/
├── lib/
├── data/
├── doc/
└── output/
```

Please see each subfolder for a README file.

