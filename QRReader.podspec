#
# Be sure to run `pod lib lint QRReader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QRReader'
  s.version          = '0.4.1'
  s.summary          = 'qr読み込みを簡略化します。'

  s.homepage         = 'https://github.com/KiraSoga/QRReader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'KiraSoga' => 'sogakira0202@gmail.com' }
  s.source           = { :git => 'https://github.com/KiraSoga/QRReader.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'QRReader/Classes/**/*'
  s.swift_version = '5.0'
  # s.resource_bundles = {
  #   'QRReader' => ['QRReader/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
