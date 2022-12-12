class DependencyGraph < Formula
  desc "Generates graphs of the dependencies in an Xcode project or Swift package."
  homepage "https://github.com/simonbs/DependencyGraph"
  url "git@github.com:simonbs/dependency-graph.git", tag: "1.0.0", using: :git
  head "https://github.com/simonbs/dependency-graph", branch: "main"

  depends_on xcode: ["12.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/dependency-graph"
  end

  test do
    system "#{bin}/dependency-graph", "--version"
  end
end
