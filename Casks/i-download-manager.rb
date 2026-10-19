cask "i-download-manager" do
  version "1.4.2"
  sha256 "2472bcd9438ad5a3007179a8cfc3d129ee55cd5b4985836fc7e4005f22cba6bd"

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
