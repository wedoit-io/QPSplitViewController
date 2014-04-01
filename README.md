QPSplitViewController
=====================

Split View Controller (like Settings app) for iOS

![alt tag](https://raw.githubusercontent.com/quangpc/QPSplitViewController/master/Screenshots/demo.png)

=====================
<h1>HOW TO USE:</h1><br>
<h2>1. Add to your projects</h2>
  Manual: add QPSplitViewController
  Cocoapods: pod 'QPSplitViewController'
<br>
<h2>2. Init</h2>

```
    QPSplitViewController *splitVC = [[QPSplitViewController alloc] initWithLeftViewController:left rightViewController:right];
    self.window.rootViewController = splitVC;
```

<h2>3. Change controller</h2>

```
    // Use UIViewController Category
    [self.qp_splitViewController setRightController:newRight];
```

<h2>4. Change size</h2>

```
    // Change left or right split width
    self.qp_splitViewController.leftSplitWidth = 320.0;
```
