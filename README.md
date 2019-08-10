# MoonCascadeTest
The app sends a request to remote server for a list of employees to be returned in json format. This json data is then mapped to `Employee` objects and then displayed on the screen.

In order to display data correctly on all iPhones, `Auto Layouts` and `Size Classes` are used.

## Architecture
The project follows MVC design pattern with an addition of Network Layer.

The controller requests network layer for the list of employees, network layer fetches that list in the form of json data, converts this data into valid employee objects and passes that list to the controller. The controller then displays this information in a `UITableView` 

## Features
* Pull to refresh
* Search by first name, last name, email, projects or position
* Offline Storage of the last successful response
* Employees are grouped together on basis of their positions
* Employees are displayed in the form of first name + last name combination
* Employees are sorted by last name


## Requirements
* iOS 12.0
* Xcode 10.0
* Swift 4.0
