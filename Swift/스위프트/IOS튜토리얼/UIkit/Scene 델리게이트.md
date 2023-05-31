# 스트리 보드 없이 앱만들때 초기 셋팅
```swift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = MainTabController()
        window?.makeKeyAndVisible()
    }

그리고 앱 타겟에 가서 Main Interface를 런치스크린으로 바구거나 해주어야하고
info 에서 main을 삭제해야한다.

```