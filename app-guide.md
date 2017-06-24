<img src="https://s3-us-west-1.amazonaws.com/udacity-content/degrees/catalog-images/nd003.png" alt="iOS Developer Nanodegree logo" height="70" >

# Card Mine App Guide

![Platform iOS](https://img.shields.io/badge/nanodegree-iOS-blue.svg)


### Overview
This repository contains code for the Card Mine iOS App. 
(My capstone project in Udacity's iOS Nanodegree).

It's a simple card factory that helps you generate, design, and share different kinds of cards along with your favorite text !


### Usage Instruction 
The app is simple and easy to use as in the following summarized steps:

  1) After booting, sign in screen is presented. For first time users, there is a link below for signing up.
  2) Sign up as a new user. An email address confirmation message will be sent to you. confirm using it.
  3) Login after confirmation.
  4) Done ! you can start exploring the app.

For more details, check the next section.


### User Flow and Screens 

![1](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/1.png)

![2](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/2.png)

![3](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/3.png)

![4](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/4.png)

![5](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/5.png)

![6](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/6.png)

![7](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/7.png)

![8](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/8.png)

![9](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/9.png)

![10](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/10.png)

![11](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/11.png)

![12](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/12.png)

![13](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/13.png)

![14](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/14.png)

![15](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/15.png)

![15_5](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/15_5.png)

![16](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/16.png)

![17](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/17.png)

![18](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/18.png)

![19](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/19.png)

![20](https://raw.githubusercontent.com/abarrak/card-mine/master/screen-shots/20.png)


### Building the RESTful API 
There's a recommendation in the project guidelines to look for an interesting REST API and integrate with it.

During my research journey, I found nothing near to what I had in mind as an idea. 
Being experienced in writing web apps and apis maid it a reasonable choice and good practice to build [Card Mine own API](https://github.com/abarrak/card-mine-api). 

It's `TDD`ed API that has complete solutions for authentication, user management, cards resources and templates.
Also, client app (like our iOS app) tokens are implemented and handled as a second outer layer in the authentication part.


### Integration with Other Libraries 
Besides iOS standard modules, the only 3rd-party lib I integrated and customized is a [small color picker](https://github.com/EthanStrider/ColorPickerExample).


### Data Modeling And Persistence 
All of user representation data and authentication are communicated with the external API and priested locally.
A logged in user will still logged even after app restart, until logging out (which also invalidate login tokens external).

All template and card models are the building block for designing a card.
After user finishes designing, A finalCard model is created and persisted for later viewing and sharing.

### Page Screens
There are buttons that brings content for the user about the app: `about` and `help` screens.
They are basically static content pages obtained from the API.
They're enhanced with typography and images to form a foundation for pleasant to read page screens.

### Assets
The card templates are the result of researching open source and free illustrations and designs along with extra processing for improvement and be App-ready.
[All is here](https://github.com/abarrak/card-mine-assets ).
