Pod::Spec.new do |spec|
  spec.name         = "RetroVisor"
  spec.version      = "0.2.0"
  spec.summary      = "Tools to help with UnitTesting UIViews"


  spec.description  = <<-DESC
  Use RetroVisor in your UIView unit tests, to easiliy access certain UIViews, similarly
  to Xcode's UITesting XCUIElements and related types.
  
  Access a given UIView's subviews recursively through the added `elements` property, on which you can then perform
  different queries, like text matching or even completely custom filtering with a custom predicate
                   DESC

  spec.homepage     = "https://github.com/tadelv/RetroVisor"

  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "Vid Tadel" => "vid@tadel.net" }

  spec.platform     = :ios, "12.1"
  spec.source       = { :git => "https://github.com/tadelv/RetroVisor.git", :tag => "#{spec.version}" }


  spec.source_files  = "RetroVisor"
  spec.swift_version = '5.3'
end
