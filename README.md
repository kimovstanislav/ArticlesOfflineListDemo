# ArticlesOfflineListDemo

A demo project that loads a list of articles and saves them for offline use.

To run the project, run "pod install" in the terminal in root folder. Then open ArticlesOfflineListDemo.xcworkspace

Comments on implementation details (is also a TODO):


Remarks:
API request retry with delay is implemented manually inside ArticlesListViewModel. The logic for it is also unit tested. As an alternative could also move that logic to the API client implementation (with async/await - https://www.swiftbysundell.com/articles/retrying-an-async-swift-task/). Or an approach with Combine like here: https://www.donnywals.com/retrying-a-network-request-with-a-delay-in-combine/

