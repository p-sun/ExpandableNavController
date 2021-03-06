# ExpandableNavController
A animated navigation controller where each view controller can supply a supplementary views with custom heights. The supplmentary views, as well as buttons are provided by view controllers.

The navigation controller animates transitions between view controllers and different heights and widths.

Swift 5.

<img src="https://github.com/p-sun/ExpandableNavController/blob/master/Gifs/EPNavController.gif" width="300">

## How to Use
EPNavController can be used just like a regular `UINavigationController`, programically or from storyboard.
```swift
let navController = EPNavController(rootViewController: MyRootViewController())
```

Each view controller optionally declare what goes into the navigation bar by conforming to `EPNavControllerDelegate`.

### Supplementary View

<img src="https://github.com/p-sun/ExpandableNavController/blob/master/Gifs/supplementaryView.png" width="500">

```swift
func supplementary() -> EPSupplementary {
    return EPSupplementary(
        view: MyCustomView(),
        topPadding: 10,
        viewHeight: 140,
        bottomPadding: 30)
}
```

### Navigation Bar Center Title or Image

<img src="https://github.com/p-sun/ExpandableNavController/blob/master/Gifs/titleImage.png" width="500">

```swift
func navBarCenter() -> EPNavBarCenter? {
    return .image(UIImage(named: "sushi"), height: 60)
}
```

<img src="https://github.com/p-sun/ExpandableNavController/blob/master/Gifs/titleString.png" width="500">

```swift
func navBarCenter() -> EPNavBarCenter? {
    return .title("Or a Title String")
}
```

### Left and Right buttons

<img src="https://github.com/p-sun/ExpandableNavController/blob/master/Gifs/leftRightButtons.png" width="500">

```swift
func navBarLeft() -> EPBarButtonItem? {
    return EPBarButtonItem(title: "Left Button", didTapButton: {
        print("Left button tapped")
    })
}

func navBarRight() -> EPBarButtonItem? {
    return EPBarButtonItem(title: "Right Button", didTapButton: {
        print("Right button tapped")
    })
}
```

## Customization

You can set colors, fonts, and sizing in `EPNavController.appearance`.

```swift
EPNavController.appearance.tintColor = .purple
EPNavController.appearance.backgroundColor = .white

EPNavController.appearance.navCornerRadius = 30
EPNavController.appearance.topNavFromLayoutGuide = 60

EPNavController.appearance.shadowColor = .lightGray
EPNavController.appearance.shadowOpacity = 0.4

EPNavController.appearance.titleTextAttributes = [
    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
EPNavController.appearance.backTextAttributes = [
    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
```
## Installation

### Carthage
1. Install the latest version of [Carthage](https://github.com/Carthage/Carthage#installing-carthage)
2. Add this line to your `Cartfile`
```
github "p-sun/ExpandableNavController" ~> 1.0.0
```
3. Follow the [Carthage installation instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

### Manual
Copy the `ExpandableNavController` folder

## Bonus - Method Swizzling 🎉
There's an example of how to Method Swizzle in Swift, which is to say, change the implementation of Apple's methods at runtime. This example replaces all color calls with a method to randomize the colors. Tap any view to randomize the colors of that view and all its subviews.

To use this on any app, copy the `UIColor+Swizzling.swift` file, and call `ColorSwizzler.swizzle()`.

<img src="https://github.com/p-sun/ExpandableNavController/blob/master/Gifs/ColorSwizzling.gif" width="300">
