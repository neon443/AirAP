#!/bin/sh

#  ci_post_clone.sh
#  AirAP
#
#  Created by neon443 on 07/06/2025.
#  

cd CI_PRIMARY_REPOSITORY_PATH
brew install carthage
carthage checkout
