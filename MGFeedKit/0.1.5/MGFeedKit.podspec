Pod::Spec.new do |s|
  s.name             = 'MGFeedKit'
  s.version          = '0.1.5'
  s.summary          = 'When you sit down to work, external critics aren’t'
  s.description      = 'When you sit down to work, external critics aren’t the enemy. It’s you who you must to fight against to do great fucking work. You must overcome yourself. Saul Bass on failure: Failure is built into creativity… the creative act involves this element of ‘newness’ and ‘experimentalism,’ then one must expect and accept the fucking possibility of failure.'
  s.homepage         = 'https://github.com/HaraldBregu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Harald Bregu' => 'harald.bregu@gmail.com' }
  s.source           = { :git => 'https://github.com/HaraldBregu/MGFeedKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.source_files = 'MGFeedKit/Classes/**/*'
  s.resource_bundles = {
    'MGFeedKit' => ['MGFeedKit/Assets/*.{png,lproj,storyboard}']
  }
  s.dependency 'GSImageViewerController'
  s.dependency 'SwiftSoup'
  s.dependency 'FeedKit', '~> 8.0'
  s.dependency 'SDWebImage', '~> 4.0'
  s.swift_version = '4.2'
end
