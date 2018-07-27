# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

def project_dependecies
    # Pods for PokeApp
    pod 'RxCocoa', '~> 4.0.0'
    pod 'RxSwift', '~> 4.0.0'
    pod 'Kingfisher', '~> 4.6.1'
    pod 'Firebase/Core'
    pod 'Firebase/RemoteConfig'
end

def testing_dependencies
    # Pods for testing
    pod 'RxCocoa', '~> 4.0.0'
    pod 'RxSwift', '~> 4.0.0'
end

target 'PokeApp' do
    
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PokeApp
  project_dependecies
  
  target 'PokeAppTests' do
      
      inherit! :search_paths
      
      # Pods for testing
      testing_dependencies
      
  end
  
end
