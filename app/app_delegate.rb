INSTAGRAM_CLIENT_ID = 'add your id here'

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    setup_client

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    storyboard = UIStoryboard.storyboardWithName "Storyboard", bundle: nil
    @window.rootViewController = storyboard.instantiateInitialViewController
    @window.makeKeyAndVisible

    true
  end

  def setup_client
    AFMotion::Client.build_shared("https://api.instagram.com/v1/") do
      operation :json

      header "Accept", "application/json"
    end
  end
end
