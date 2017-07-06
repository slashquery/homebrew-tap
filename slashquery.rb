require "language/go"

class Slashquery < Formula
  desc "API Gateway"
  homepage "https://slashquery.com"
  url "https://github.com/slashquery/slashquery.git",
      :tag => "0.1.0",
      :revision => "d06468de9a8c66a127f71547d956c7848ac846d2"

  head "https://github.com/slashquery/slashquery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "179e07bb22e2755e3d082f07607cf2e98e266defaace3ceb764a4c32f03ccf8d" => :sierra
    sha256 "5be8ef01a8568b7de75b19d525a4830b0c934c43b9e8f9fb150cbdcb18091a26" => :el_capitan
    sha256 "6dcf9d7de2489f5e3d6fd56488c3abe2bff1ea6f6bf0d9de89421b0e9a7e2e38" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/go-yaml/yaml" do
    url "https://github.com/go-yaml/yaml.git",
        :revision => "cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b"
  end

  go_resource "github.com/nbari/violetear" do
    url "https://github.com/nbari/violetear.git",
        :revision => "431db125cc1892866a2b306ba4cc8d1d4f5d577d"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
        :revision => "e46719b2fef404d2e531c0dd9055b1c95ff01e2e"
  end

  go_resource "github.com/slashquery/resolver" do
    url "https://github.com/slashquery/resolver.git",
        :revision => "b3941358c7b7b73f5ce4a7402827c83b5d52cb14"
  end

  go_resource "github.com/golang/tools" do
      url "https://github.com/golang/tools.git",
        :revision => "72ed06fbe2cf37c56ab4877b06571d2e7620627b"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/slashquery/slashquery").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/slashquery/slashquery" do
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "run", "genroutes.go", "-f", "testdata/default.yml"
      system "go", "build", "-ldflags", ldflags, "-o" "#{bin}/slashquery", "cmd/slashquery/main.go"
      bin.install "slashquery"
    end
  end

  test do
    system bin/"slashquery", "-v"
  end
end
