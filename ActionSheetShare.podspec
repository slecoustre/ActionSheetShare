Pod::Spec.new do |s|

  s.name         = "ActionSheetShare"
  s.version      = "0.1"
  s.summary      = "Clone ShareView iOS"
  s.homepage     = "https://github.com/slecoustre/ActionSheetShare"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Stéphane LE COUSTRE" => "slecoustre@hotmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/slecoustre/ActionSheetShare.git", :tag => "0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.dependency "pop", "~> 1.0.7"
  s.requires_arc = false

end
