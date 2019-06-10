Pod::Spec.new do |spec|
  spec.name         = "JZFlutter"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of JZFlutter."
  spec.description  = <<-DESC
  A description of JZFlutter.
                   DESC
  spec.homepage     = "https://www.github.com.com/JaminZhou"
  spec.license      = "MIT"
  spec.author       = { "JaminZhou" => "me@jaminzhou.com" }
  spec.source       = { :http => "https://pods.jaminzhou.com/JZFlutter-0.0.1_pAH2J5n.zip" }

  spec.vendored_libraries  = "repo/ios/Libraries/*.a"
  spec.vendored_frameworks = "repo/ios/Frameworks/*.framework"
  spec.source_files = "repo/ios/Headers/*.h"

  spec.libraries = "c++"
  spec.ios.deployment_target = "9.0"
end
