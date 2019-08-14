platform :ios, '9.0'
workspace 'AdMobBidMachineSample.xcworkspace'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'


def bidmachine_header_bidding
  pod "BidMachine", "1.3.0"
  pod "BidMachine/VungleAdapter", "1.3.0"
  pod "BidMachine/TapjoyAdapter", "1.3.0"
  pod "BidMachine/MyTargetAdapter", "1.3.0"
  pod "BidMachine/FacebookAdapter", "1.3.0"
  pod "BidMachine/AdColonyAdapter", "1.3.0"
end


target 'AdMobBidMachineSample' do
  project 'AdMobBidMachineSample.xcodeproj'
  pod 'GoogleMobileAdsMediationTestSuite'
  pod 'Google-Mobile-Ads-SDK'
  bidmachine_header_bidding
end

 
target 'BidMachineAdapter' do
  project 'AdMobBidMachineSample.xcodeproj'
  pod 'Google-Mobile-Ads-SDK'
  bidmachine_header_bidding
end
