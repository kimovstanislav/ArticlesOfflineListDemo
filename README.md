# ArticlesOfflineListDemo

A demo project that loads a list of articles and saves them for offline use.

To run the project, run "pod install" in the terminal in root folder. Then open ArticlesOfflineListDemo.xcworkspace

Comments on implementation details (is also a TODO):

// TODO: use actual AsyncImage, but also manage the offline caching.
SDWebImage is used for async image loading and caching, because AsyncImage is only available from iOS15, and the current requirement is to support iOS14.
Not to use pods, as an alternative could use something like custom AsyncImage implementation in https://www.vadimbulavin.com/modern-mvvm-ios-app-architecture-with-combine-and-swiftui/ or https://github.com/phetsana/BoardGameList-MVVM-Input-Output . But it would be too much needless work, and also the need to provide code coverage.

// TODO: move it to the APIClient, and also try Combine for the delay, if it will be easier than with async/await.
API request retry with delay is implemented manually inside ArticlesListViewModel. The logic for it is also unit tested. As an alternative could also move that logic to the API client implementation, if needed to scale it later (with async/await, though tricky - https://www.swiftbysundell.com/articles/retrying-an-async-swift-task/). Or an approach with Combine like here (which is still tricky): https://www.donnywals.com/retrying-a-network-request-with-a-delay-in-combine/
Will leave as it is for lack of time. But the improvement suggestion are above.

// TODO: make a dummy EncryptionManager at least and insert it. OR think if we need it at all, and remove it completely.
Encryption is not done. I would start approaching it by creating an EncryptionManager, that implements an async encrypt/decrypt on local data write/read. May be injected inside LocalDataClient. For encryption key could use an extract of a user password for example, or would need to investigate. Also to encrypt all data is too heavy, would make more sense to store detail articles separately and encrypt/decrypt only 1 at a time, when it is first loaded, or a screen is opened.

