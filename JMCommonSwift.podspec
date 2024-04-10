#
# Be sure to run `pod lib lint JMCommonSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JMCommonSwift'
  s.version          = '0.4.0'
  s.summary          = 'A short description of JMCommonSwift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/James-Geng'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1345492794@qq.com' => 'gengruijie@foxmail.com' }
  s.source           = { :git => 'https://github.com/KyleWhale/JMCommonSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  s.source_files = 'JMCommonSwift/Classes/**/*'

  s.dependency  'SnapKit', '~> 4.2.0'
  s.dependency  'SDWebImage'
  
  s.swift_version = '5.0'

  s.resource_bundles = {
      'JMCommonSwift' => ['JMCommonSwift/Assets/*.png']
  }
  
  # s.resource_bundles = {
  #   'JMCommonSwift' => ['JMCommonSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
