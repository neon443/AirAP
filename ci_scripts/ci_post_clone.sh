#!/bin/sh

#  ci_post_clone.sh
#  AirAP
#
#  Created by neon443 on 07/06/2025.
#  

cd ..
brew install carthage
carthage update --use-xcframeworks
