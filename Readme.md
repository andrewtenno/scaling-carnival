Project setup / install
- This project requires use of CocoaPods. To set up the dependencies needed for this project run `$ pod install`

Usage of 3rd Party Libraries
- I used Haneke to assist in downloading and caching images

Outstanding Issues
- Due to the way comments are presented I wasn't able to implement paging on the comments page (mostly due to time constraints). Right now comments are displayed sequentially and don't show the tree structure displayed on the website. One possible way to do this would be by using a tableView with each section corresponding to an indent level in the comments. This would require pretty heavy use of batch updating to ensure that there is good performance.
- I am only displaying the raw text in the comments. I know it is possible to render HTML into an NSAttributedString but as a first pass I think displaying the plain text is adequate.

Architecture:
- I went with an MVVM architecture where all values needed for presentation are computed into immutable view models. If we needed to do more complex string manipulations for the UI we could do this on a background thread which would improve scrolling performance in the table view.
- Right now all the posts and comments are kept in memory. After a user scrolls long enough we will undoubtedly run out of memory. One possible solution to this problem would be to save items to disk or refetch the posts/comments from the server.
