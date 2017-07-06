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

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/slashquery/slashquery").install buildpath.children
    cd "src/github.com/slashquery/slashquery" do
      system "make"
      bin.install "slashquery"
    end
  end

  test do
    system bin/"slashquery", "-v"
  end
end
