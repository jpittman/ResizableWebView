ResizableWebView
================

This is an experiment.  The original idea was to create a dynamically sizable UIWebview 
based upon it's loaded content.  This comes from the need to create a view to display some
stylized text of considerable size.  HTML being the easiest way to handle the style part,
it made sense to use a UIWebView.

But the problem isn't that simple.  What it became is:

 * View Controller with a ScrollView as its root view.
 * A UIWebView as one of its subviews.
 * altering the shape of both views to handle large amounts of text.


So I've needed to solve this problem for a while, but haven't really had the time to sit 
and come up with a simple repeatable solution.

License
-------

This project's code is distributed under the terms of the MIT License.  See the
license.txt file for complete text.

Contributions
-------------

Please feel free to fork, fix, enhance or add and send me a pull request with the result. 
And if you decide to use this code in a published project, send me a message with a link.

References
----------

The following links were used in putting this little experiment together.  Pieces of each
of these posts/threads were put to good use in coming up with the final solution.

 * http://stackoverflow.com/questions/7341767/ios-resize-uiwebview-to-fit-content
 * http://iphoneincubator.com/blog/windows-views/right-scale-for-a-uiwebview
 * http://stackoverflow.com/questions/3582994/dynamically-sizing-a-uiwebview-based-on-its-content-font-size
 * http://www.iphonedevsdk.com/forum/iphone-sdk-development/17933-uiwebview-resize-height-content.html
 * http://www.techotopia.com/index.php/IPhone_Rotation%2C_View_Resizing_and_Layout_Handling
 * http://stackoverflow.com/a/4094906/1080311
 * http://stackoverflow.com/a/6104537/1080311
 * http://warmfuzzyapps.com/2011/08/fun-with-uiwebview/
 * http://www.icab.de/blog/2011/08/02/adding-javascript-files-as-resources-to-an-xcode-project/
 