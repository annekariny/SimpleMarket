# SimpleMarket
This is an iOS project from a simple market app, it was done using concepts like of MVP-C architecture, DI, SRP and Unit Tests.

## About
This is a market app, where users can add products, remove and save orders.

## Features

### Market View
Lists all products from a sample product API, this is the main view from the project. The user can interact with it and add products to the cart.

### Cart View
Lists all order items details added and removed from the cart. It shows the quantity of each product and the total value of the order. Users can interact with it by adding and removing order items. Also, it's possible to save the order.

### Orders View
Lists all orders created by the user by showing its ID and value. Also, it's possible to delete all orders created previously (including the current cart).

### Orders Widget
Shows the last 3 orders created on the device's home screen. Available only for small size.

## And much more
Besides the features, there are included some other code details, like:
* API consuming
* Realm database
* MVP-C architecture
* Unit Tests
* View Code
* Strings Localization
* Dark mode support

## How to install

Inside projects folder type a pod install command.

`pod install`

## Screenshots

![ScreenShot](./ScreenShots/s1.png "Market View")
![ScreenShot](./ScreenShots/s2.png "Cart View")
![ScreenShot](./ScreenShots/s3.png "Orders View")
![ScreenShot](./ScreenShots/s4.png "Widget")
![ScreenShot](./ScreenShots/s5.png "Widget")
