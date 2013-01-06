# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'CRUD Client'
  app.info_plist["UIMainStoryboardFile"] = "Example"
  app.interface_orientations = [:portrait]
  app.frameworks << 'CFNetwork'
  app.frameworks << 'CoreData'
  app.pods do
    pod 'RestKit', git: 'https://github.com/RestKit/RestKit.git', branch: 'development'
  end
end
