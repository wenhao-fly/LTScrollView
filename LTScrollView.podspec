
Pod::Spec.new do |s|
  s.name             = 'LTScrollView'
  s.version          = '0.2.1'
  s.summary          = 'LTScrollView'

  s.description      = <<-DESC
TODO: ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC / Swift，实现原理：http://blog.csdn.net/glt_code/article/details/78576628
                       DESC

  s.homepage         = 'https://github.com/gltwy/LTScrollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1282990794@qq.com' => '1282990794@qq.com' }
  s.source           = { :git => 'https://github.com/gltwy/LTScrollView.git', :tag => s.version.to_s }

  # Pod库的构建设置排除arm64架构模拟器
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  # 主工程的构建设置排除arm64架构模拟器
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }


  s.ios.deployment_target = '11.0'

  s.source_files = 'Example/LTScrollView/Lib/**/*'
end
