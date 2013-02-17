# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'mctv-mapkit'
  app.frameworks += ['CoreLocation', 'MapKit','AddressBook']

  app.pods do
    pod 'AFNetworking'
    pod 'KNSemiModalViewController'
  end
end
