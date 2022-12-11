# DependencyGraph

[![Build and Test](https://github.com/simonbs/DependencyGraph/actions/workflows/build_and_test.yml/badge.svg)](https://github.com/simonbs/DependencyGraph/actions/workflows/build_and_test.yml) [![SwiftLint](https://github.com/simonbs/DependencyGraph/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/simonbs/DependencyGraph/actions/workflows/swiftlint.yml)

Generates graphs of the dependencies in an Xcode project or Swift package.


## 👀 Sample

The graph below shows the relationship of the products and targets in this package as of December 11, 2022. Click on the image to see a larger version.

<img width="400" src="./sample-swift-package.png" alt="Example graph showing the dependencies of this package." />

## 🚀 Getting Started

## 📖 Usage

## 🤷‍♂️ OK, why?

As I'm splitting my iOS and macOS applications into small Swift packages with several small targets, I started wishing for a way to visualise the relationship between the products and targets in my Swift packages. That's why I built this tool.

Several other tools can visualise a Swift package, however, I wanted a tool that can take both a Swift package and an Xcode project as input. The example in the top of this README shows a visualization of a Swift package and the graph below shows a visualisation of an Xcode project.
Notice that the left-most subgraph represents an Xcode project named ScriptUIEditor.xcodeproj and it has three targets: ScriptUIEditor, ScriptBrowserFeature, and ScriptBrowserFeatureUITests. Two of these depends on the Swift packages represented by the remaining subgraphs.

<img width="400" src="./sample-xcodeproj.png" alt="Example graph showing the dependencies of an Xcode project." />

## 🧐 ...but how?
