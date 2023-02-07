# ArticlesOfflineListDemo

Just a test project.

To run the project, run "pod install" in the terminal in root folder. Then open VieSureDemo.xcworkspace

Comments on implementation details (is also a TODO):

SDWebImage is used for async image loading and caching, because AsyncImage is only available from iOS15, and the current requirement is to support iOS14.
Not to use pods, as an alternative could use something like custom AsyncImage implementation in https://www.vadimbulavin.com/modern-mvvm-ios-app-architecture-with-combine-and-swiftui/ or https://github.com/phetsana/BoardGameList-MVVM-Input-Output . But it would be too much needless work, and also the need to provide code coverage.

API request retry with delay is implemented manually inside ArticlesListViewModel. The logic for it is also unit tested. As an alternative could also move that logic to the API client implementation, if needed to scale it later (with async/await, though tricky - https://www.swiftbysundell.com/articles/retrying-an-async-swift-task/). Or an approach with Combine like here (which is still tricky): https://www.donnywals.com/retrying-a-network-request-with-a-delay-in-combine/
Will leave as it is for lack of time. But the improvement suggestion are above.

Encryption is not done. I would start approaching it by creating an EncryptionManager, that implements an async encrypt/decrypt on local data write/read. May be injected inside LocalDataClient. For encryption key could use an extract of a user password for example, or would need to investigate. Also to encrypt all data is too heavy, would make more sense to store detail articles separately and encrypt/decrypt only 1 at a time, when it is first loaded, or a screen is opened. But it's ideas before a proper investigation, for the lack of time.

Regarding Combine, async/await looks to me like a more simple and flexible approach, that is also more widely used and supported. Myself, would only use Combine to connect ViewModel to UI. Didn't find for myself other Combine uses, where it's better. in my experience trying to use too much Comine just needlessly complicates things. But of course my experience is limited, I may learn more in the future.

The UI is basic. Focused on the app architecture, paid minimal attention for the UI to do more than just the basic function to display the data. The navigation between screens is also the most simple. In real life my experience was to only use Coordinator with UIKit NavigationController, and have SwiftUI views inside the containers, each one separately. In my experience I didn't see or wasn't able to come up with a pure SwiftUI navigation for a big project. So didn't even try in this simple example.

