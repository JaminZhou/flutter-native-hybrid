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
  spec.source       = { :http => "https://pods.jaminzhou.com/JZFlutter-0.0.1_wu5hkeK.zip" }

  spec.vendored_libraries  = "Libraries/*.a"
  spec.vendored_frameworks = "Frameworks/*.framework"
  spec.source_files = "Headers/*.h"

  spec.libraries = "c++"
  spec.ios.deployment_target = "9.0"
end
