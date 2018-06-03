# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def core_pods
  pod 'RxSwift', '~> 4.0'
end

def core_test_pods
  pod 'RxTest', '~> 4.0'
end

target 'ExampleFramework' do
  use_frameworks!

  core_pods

  target 'ExampleFrameworkTests' do
    inherit! :search_paths
    core_test_pods
  end

end

target 'ExampleFramework-iOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  core_pods

end

target 'TestsExample' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TestsExample

end
