#!/bin/sh

#  ci_post_clone.sh
#  AirAP
#
#  Created by neon443 on 07/06/2025.
#  

cd ..
brew install carthage
carthage checkout
sed -i 's/SKIP_INSTALL = NO/SKIP_INSTALL = YES/g' Carthage/Checkouts/Airstream/Carthage/Checkouts/shairplay/extras/xcode/alac/alac.xcodeproj/project.pbxproj
sed -i 's/SKIP_INSTALL = NO/SKIP_INSTALL = YES/g' Carthage/Checkouts/Airstream/Carthage/Checkouts/shairplay/extras/xcode/crypto/crypto.xcodeproj/project.pbxproj
sed -i 's/SKIP_INSTALL = NO/SKIP_INSTALL = YES/g' Carthage/Checkouts/Airstream/Carthage/Checkouts/shairplay/extras/xcode/shairplay/shairplay.xcodeproj/project.pbxproj
sed -i 's/SKIP_INSTALL = NO/SKIP_INSTALL = YES/g' Carthage/Checkouts/Airstream/Airstream.xcodeproj/project.pbxproj
