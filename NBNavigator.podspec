Pod::Spec.new do |s|
  s.name             = 'NBNavigator'
  s.version          = '1.0.0'
  s.summary          = '一个基于URL的APP导航'
  s.homepage         = 'https://github.com/liubin303/NBNavigator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liubin303' => '273631976@qq.com' }
  s.source           = { :git => 'https://github.com/liubin303/NBNavigator.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files     = 'NBNavigator/*.{h,m}'
  s.requires_arc     = true

end