# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'youpropapp'

  #app.info_plist['UIMainStoryboardFile'] = 'Example'

  app.device_family = [:iphone, :ipad]
  
  app.provisioning_profile = '/Users/ptax/Library/MobileDevice/Provisioning Profiles/EA8F07F2-DB5C-43D5-A722-BEF7C43408FB.mobileprovision' 
  app.codesign_certificate = 'iPhone Developer: Paolo Tassinari (9L6JUZD52Q)' 

  # app.info_plist["UIMainStoryboardFile"] = "Example"
  # app.interface_orientations = [:portrait]
  app.frameworks << 'CFNetwork'
  app.frameworks << 'CoreData'
  app.pods do
    pod 'RestKit', git: 'https://github.com/RestKit/RestKit.git', branch: 'development'
    pod 'NVUIGradientButton'
  end
end
