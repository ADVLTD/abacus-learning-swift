# Near Learning : iOS Application

This is a swift based Learning Application that works with near protocol .

## Installation

Use the git clone command in your terminal to clone the project.

```bash
git clone 
```

## Requirements to run

1. As this project is requires [near-rest-API](https://gitlab.com/alsaabltd_and_headstrait/nr-rest-server.git) server, you will need that server running in the background on localhost:3000.

2. This project will only run on Xcode simulator as the server is locally available for your mac machine.

## Steps to run the project

1. Clone the project, make sure you have Xcode and the [near-rest-API](https://gitlab.com/alsaabltd_and_headstrait/nr-rest-server.git) server running in the background on vsCode.

2. Run the project in Xcode simulator of your choice.

## Additional Notes

1. For API functions go to directory Near -> API -> NearRestAPI.swift, it has all the server calls and functions required for functioning of this project.

2. For string Constants in the code go to directory Near -> Helpers -> StringConstants.swift, it has all the string urls for the server calls and other string constants needed in the project. If you want to change any url just do it here and you are good to go.

3. For JSON DataModels used in NearRestAPI file in the code go to directory Near -> Model -> NearAPIDataModel.swift, it has all the data model objects that are needed to convert the server JSON response into swift object.