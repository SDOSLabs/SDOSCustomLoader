@version = "1.1.0"
Pod::Spec.new do |spec|
  spec.platform     = :ios, '8.0'
  spec.name         = 'SDOSCustomLoader'
  spec.authors      = 'SDOS'
  spec.version      = @version
  spec.homepage     = 'https://github.com/SDOSLabs/SDOSCustomLoader'
  spec.license      = { :type => 'MIT' }
  spec.summary      = 'Librería con la definición de un tipo de loader'
  spec.source       = { :git => "https://github.com/SDOSLabs/SDOSCustomLoader.git", :tag => "#{spec.version}" }
  spec.framework    = ['Foundation', 'UIKit']
  spec.requires_arc = true

  spec.subspec 'CustomLoader' do |s2|
    s2.preserve_paths = 'src/Classes/*'
    s2.source_files = ['src/Classes/*{*.m,*.h,*.swift}', 'src/Classes/**/*{*.m,*.h,*.swift}']
  end

end
