class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    read_config
    setup_client

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    storyboard = UIStoryboard.storyboardWithName "Storyboard", bundle: nil
    @window.rootViewController = storyboard.instantiateInitialViewController
    @window.makeKeyAndVisible

    true
  end

  def setup_client
    AFMotion::Client.build_shared("https://api.instagram.com/v1/") do
      response_serializer :json

      header "Accept", "application/json"
    end
  end

  def read_config
    return if @instagram_client_id

    if path = NSBundle.mainBundle.pathForResource("config", ofType:"yml")
      json = YAML.load(File.read(path))
      ENV['INSTAGRAM_CLIENT_ID'] = json['instagram']['client_id']
    else
      puts 'WARNING! Main bundle missing config.yml.'
    end
  end
end
