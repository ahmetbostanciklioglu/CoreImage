<div align="center">

# 🎨 Core Image Effects

**A SwiftUI photo editor that applies Core Image filters and Metal-accelerated effects in real time**

[![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange?style=flat-square&logo=swift)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=flat-square&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Xcode](https://img.shields.io/badge/Xcode-16-147EFB?style=flat-square&logo=xcode)](https://developer.apple.com/xcode/)
[![Stars](https://img.shields.io/github/stars/ahmetbostanciklioglu/CoreImage?style=flat-square&color=6E48AA)](https://github.com/ahmetbostanciklioglu/CoreImage/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/ahmetbostanciklioglu/CoreImage?style=flat-square&color=4776E6)](https://github.com/ahmetbostanciklioglu/CoreImage/commits)

</div>

## 📖 Overview

Core Image Effects is an iOS app built entirely with SwiftUI that lets you load a photo from your library or capture one with the camera and instantly transform it with image filters. It combines a set of classic **Core Image** filters with a second tier of **Metal-backed** effects rendered through a `CIContext` bound to the device's GPU. Selecting an effect immediately re-processes the source image and shows the result, so you can compare looks with a single tap.

## ✨ Features

- 📷 **Load images** from the photo library or capture new ones with the camera, with built-in cropping via `UIImagePickerController`.
- 🎛️ **Six Core Image effects** — Original, Grayscale, Sepia, Gaussian Blur, Vintage (sepia + vignette), and a composite Metal color/highlight look.
- ✨ **Five Metal-accelerated effects** — Emboss, Edge Detection, Pixelate, Kaleidoscope, and Crystallize, processed on a background queue for a responsive UI.
- ⚡ **GPU rendering** through a Metal-backed `CIContext` for fast filter output.
- 🖼️ **Horizontally scrollable effect pickers** with icons and live selection highlighting.

## 📸 Preview

<div align="center">
  <img width="305" height="642" alt="Core Image Effects — main screen" src="https://github.com/user-attachments/assets/fb6217b3-764f-4547-ab7a-4c4f1cf3a0b2" />
  <img width="292" height="625" alt="Core Image Effects — applied filter" src="https://github.com/user-attachments/assets/be1d7be8-2c98-4e48-b6e3-22a9fefcec43" />
</div>

## 🚀 Getting Started

```bash
git clone https://github.com/ahmetbostanciklioglu/CoreImage.git
cd CoreImage
open CoreImageApp.xcodeproj
```

Once the project is open in Xcode, select a simulator or a connected device and press **⌘R** to build and run. Camera capture requires a physical device.

## 📋 Requirements

- iOS 18.2 or later
- Xcode 16 or later
- Swift 5.0

## 🧑‍💻 Author

**Ahmet Bostancıklıoğlu** — [@ahmetbostanciklioglu](https://github.com/ahmetbostanciklioglu) · ahmetbostancikli@gmail.com

> ⭐ If this helped you, consider giving the repo a star!
