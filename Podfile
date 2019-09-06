platform :ios, '9.0'
workspace 'AdMobBidMachineSample.xcworkspace'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'


def bidmachine_header_bidding
  pod "BidMachine", "1.3.1"
  pod "BidMachine/VungleAdapter"
  pod "BidMachine/TapjoyAdapter"
  pod "BidMachine/MyTargetAdapter"
  pod "BidMachine/FacebookAdapter"
  pod "BidMachine/AdColonyAdapter"
  pod "BidMachine/MintegralAdapter"
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
