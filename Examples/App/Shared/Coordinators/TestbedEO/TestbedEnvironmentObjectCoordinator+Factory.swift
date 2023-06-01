import Foundation
import SwiftUI
import Stinsen

extension TestbedEnvironmentObjectCoordinator {
    @ViewBuilder func makePushScreen() -> some View {
        TestbedEnvironmentObjectScreen()
    }
    
    @ViewBuilder func makeModalScreen() -> some View {
        if #available(iOS 16, *) {
            SwiftUI.NavigationStack {
                TestbedEnvironmentObjectScreen()
            }
        } else {
            NavigationView {
                TestbedEnvironmentObjectScreen()
            }
        }
    }
    
    func makePushCoordinator() -> TestbedEnvironmentObjectCoordinator {
        return TestbedEnvironmentObjectCoordinator()
    }
    
    func makeModalCoordinator() -> NavigationViewCoordinator<TestbedEnvironmentObjectCoordinator> {
        return NavigationViewCoordinator(TestbedEnvironmentObjectCoordinator())
    }
    
    @ViewBuilder func makeStart() -> some View {
        TestbedEnvironmentObjectScreen()
    }
}
