<div align="center">
    <br/>
    <p>
        <img src="https://files.catbox.moe/fdsqnk.png" title="cobalt" alt="cobalt logo" width="100" />
    </p>
    <p>
        use your iphone as an airplay receiver
        <br/>
        <a href="https://neon443.github.io">
            made by neon443
        </a>
    </p>
    <p>
        <a href="https://testflight.apple.com/join/8aeqD8Q2">
            testflight
        </a>
    </p>
    <br/>
</div>

AirAP is a fully native AirPlay server, written in Swift, for iOS. Essentially, AirAP allows you to use your iPhone as an AirPlay receiver in iTunes or on your Mac, meaning that you can use your iPhone to play your device's sound.

## What's AirAP?

Have you ever wanted to stream audio from your Mac, Apple TV, or another iOS device to your iPhone? AirAP makes this possible by implementing a full AirPlay server that runs natively on iOS. Once installed, your iPhone will appear as an available AirPlay destination in System Preferences' Audio pane, Music.app, or any other AirPlay-compatible app.

The concept might seem backwards at first - after all, we're used to streaming from our iPhones to other devices. But there are surprisingly many scenarios where you'd want to do the reverse. Maybe you're working on your Mac late at night and want to route the audio to your iPhone with headphones so you don't disturb anyone (hi 👋). Perhaps you're a developer testing audio applications and need to quickly switch between different output devices. Or maybe you just want to repurpose that old wired speaker.

## Installing AirAP

To try it out, [open this TestFlight link](https://testflight.apple.com/join/8aeqD8Q2), install AirAP, and follow the instructions. After installation, simply launch AirAP and ensure your iPhone is connected to the same Wi-Fi network as the device you want to stream from. Your iPhone will automatically appear in AirPlay device lists, ready to receive audio - if it doesn't, try restarting the app.

## Compiling

Make sure you have [homebrew](https://brew.sh)
```
brew install carthage
git clone https://github.com/neon443/AirAP
cd AirAP
carthage checkout
open AirAP.xcodeproj
```
After adding your Team ID in Project > AirAP > Signing and Capabilities, hit `Command + R` to build and run! 

### thanks to

[qasim/Airstream](https://github.com/qasim/Airstream)
[shairplay](https://github.com/juhovh/shairplay)
would not have been possible without these

---

<sup>
&copy; 2025 Nihaal Sharma. AirPlay, iPhone, iTunes, Mac, and Apple TV are trademarks of Apple Inc.
</sup>

