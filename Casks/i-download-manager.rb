cask "i-download-manager" do
  version "1.4.0"
  sha256 "8e893e1a2c378a1725718495cc0e121e0357a63d195bb6b96ef1ab3401f2419e"

  url "https://github.com/adeministratorr/i-download-manager/releases/download/v#{version}/iDownload-Manager-#{version}.dmg"
  name "iDownload Manager"
  desc "Multi-connection download manager with Safari, Chrome, torrent and video support"
  homepage "https://github.com/adeministratorr/i-download-manager"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "iDownload Manager.app"

  uninstall quit: "tr.ademyuce.idownloadmanager"

  zap trash: [
    "~/Library/Application Support/iDownload Manager",
    "~/Library/Caches/tr.ademyuce.idownloadmanager",
    "~/Library/Containers/tr.ademyuce.idownloadmanager.safari",
    "~/Library/HTTPStorages/tr.ademyuce.idownloadmanager",
    "~/Library/Preferences/tr.ademyuce.idownloadmanager.plist",
    "~/Library/WebKit/tr.ademyuce.idownloadmanager",
  ]
end
