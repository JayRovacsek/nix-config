{ config, pkgs, ... }:
let
  packageSettings =
    if pkgs.stdenv.isDarwin then { package = pkgs.firefox-bin; } else { };
in {
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      decentraleyes
      keepassxc-browser
      multi-account-containers
      noscript
      privacy-badger
      ublock-origin
      user-agent-string-switcher
    ];

    profiles.jay = {
      bookmarks = {
        "Duck Duck Go" = {
          keyword = "d";
          url = "https://duckduckgo.com/?q=%s";
        };
        "Google Search" = {
          keyword = "g";
          url = "https://www.google.com/search?q=%s";
        };
        "Google AU Search" = {
          keyword = "ga";
          url = "https://www.google.com.au/search?q=%a";
        };
        "Youtube" = {
          keyword = "y";
          url = "https://www.youtube.com/results?search_query=%s";
        };
        "Github Search" = {
          keyword = "gh";
          url = "https://github.com/search?q=%s";
        };
        "Github Search for Nix" = {
          keyword = "ghn";
          url =
            "https://github.com/search?q=%s+language%3ANix&type=Code&ref=advsearch&l=Nix&l=";
        };
        "Dockerhub Search" = {
          keyword = "dh";
          url = "https://hub.docker.com/search?q=%s";
        };
        "Nix Pkg Search" = {
          keyword = "np";
          url =
            "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&query=%s";
        };
        "Nix Options Search" = {
          keyword = "no";
          url =
            "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&query=%s";
        };
        "Nix Uber Search" = {
          keyword = "ns";
          url =
            "https://search.nix.gsc.io/?q=%s&i=nope&files=&excludeFiles=&repos=";
        };
        "nib Jira Search" = {
          keyword = "j";
          url =
            "https://jira.nib.com.au/issues/?jql=text~%22%s%22%20or%20description%20~%20%22%s%22%20or%20summary%20~%20%22%s%22";
        };
        "nib Confluence Search" = {
          keyword = "c";
          url =
            "https://confluence.nib.com.au/dosearchsite.action?cql=siteSearch+~+%22%s%22&queryString=%s";
        };
        "nib Github Search" = {
          keyword = "ngh";
          url = "https://github.com/nib-group?q=%s&type=&language=";
        };
        OSRSWiki = {
          keyword = "osrs";
          url =
            "https://oldschool.runescape.wiki/?search=%s&title=Special%3ASearch&fulltext=Search";
        };
      };

      settings = {
        "accessibility.force_disabled" = 1;
        "app.normandy.api_url" = "";
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "app.update.auto" = false;
        "app.update.background.scheduling.enabled" = false;
        "beacon.enabled" = false;
        "breakpad.reportURL" = "";
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.max_backups" = 2;
        "browser.cache.disk.capacity" = 1048576;
        "browser.cache.disk.enable" = false;
        "browser.cache.memory.capacity" = -1;
        "browser.cache.memory.enable" = true;
        "browser.contentblocking.category" = "strict";
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.crashReports.unsubmittedCheck.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.display.use_system_colors" = true;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.download.useDownloadDir" = false;
        "browser.fixup.alternate.enabled" = false;
        "browser.formfill.enable" = false;
        "browser.helperApps.deleteTempFileOnExit" = true;
        "browser.link.open_newwindow" = 3;
        "browser.link.open_newwindow.restriction" = 0;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
          false;
        "browser.newtabpage.activity-stream.default.sites" = "";
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.enabled" = false;
        "browser.pagethumbnails.capturing_disabled" = true;
        "browser.ping-centre.telemetry" = false;
        "browser.privatebrowsing.forceMediaMemoryCache" = true;
        "browser.region.network.url" = "";
        "browser.region.update.enabled" = false;
        "browser.safebrowsing.allowOverride" = true;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.search.context.loadInBackground" = false;
        "browser.search.suggest.enabled" = false;
        "browser.sessionstore.privacy_level" = 2;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.ssl_override_behavior" = 1;
        "browser.startup.homepage" = "about:blank";
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.startup.page" = 0;
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.uitour.enabled" = false;
        "browser.uitour.url" = "";
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.urlbar.trimURLs" = false;
        "browser.xul.error_pages.expert_bad_cert" = true;
        "captivedetect.canonicalURL" = "";
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "devtools.chrome.enabled" = false;
        "devtools.debugger.remote-enabled" = false;
        "dom.disable_beforeunload" = true;
        "dom.disable_open_during_load" = true;
        "dom.disable_window_move_resize" = true;
        "dom.event.contextmenu.enabled" = false;
        "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
        "dom.push.enabled" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_send_http_background_request" = false;
        "dom.serviceWorkers.enabled" = false;
        "dom.storage.next_gen" = true;
        "dom.targetBlankNoOpener.enabled" = true;
        "extensions.autoDisableScopes" = 15;
        "extensions.blocklist.enabled" = true;
        "extensions.enabledScopes" = 5;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.postDownloadThirdPartyPrompt" = false;
        "extensions.systemAddon.update.enabled" = false;
        "extensions.systemAddon.update.url" = "";
        "extensions.webcompat-reporter.enabled" = false;
        "geo.provider.ms-windows-location" = false;
        "geo.provider.use_corelocation" = false;
        "geo.provider.use_gpsd" = false;
        "intl.accept_languages" = "en-US, en";
        "layout.spellcheckDefault" = 2;
        "media.autoplay.default" = 5;
        "media.eme.enabled" = false;
        "media.memory_cache_max_size" = 65536;
        "media.peerconnection.enabled" = false;
        "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.ice.no_host" = true;
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        "middlemouse.contentLoadURL" = false;
        "network.IDN_show_punycode" = true;
        "network.captive-portal-service.enabled" = false;
        "network.connectivity-service.enabled" = false;
        "network.cookie.cookieBehavior" = 4;
        "network.cookie.thirdparty.nonsecureSessionOnly" = true;
        "network.cookie.thirdparty.sessionOnly" = true;
        "network.dns.disableIPv6" = true;
        "network.dns.disablePrefetch" = true;
        "network.file.disable_unc_paths" = true;
        "network.gio.supported-protocols" = "";
        "network.http.referer.spoofSource" = false;
        "network.http.sendRefererHeader" = 0;
        "network.http.speculative-parallel-limit" = 0;
        "network.predictor.enabled" = false;
        "network.prefetch-next" = false;
        "network.protocol-handler.external.ms-windows-store" = false;
        "network.proxy.socks_remote_dns" = true;
        "network.trr.mode" = 3;
        "network.trr.uri" = "https://doh.libredns.gr/dns-query";
        "pdfjs.disabled" = false;
        "pdfjs.enableScripting" = false;
        "permissions.delegation.enabled" = false;
        "permissions.manager.defaultsUrl" = "";
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.offlineApps" = true;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.clearOnShutdown.siteSettings" = false;
        "privacy.cpd.cache" = true;
        "privacy.cpd.cookies" = true;
        "privacy.cpd.formdata" = true;
        "privacy.cpd.history" = true;
        "privacy.cpd.passwords" = false;
        "privacy.cpd.sessions" = true;
        "privacy.cpd.siteSettings" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.firstparty.isolate" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.block_mozAddonManager" = true;
        "privacy.resistFingerprinting.letterboxing" = false;
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.sanitize.timeSpan" = 0;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
        "privacy.window.name.update.enabled" = true;
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = false;
        "security.ask_for_password" = 2;
        "security.cert_pinning.enforcement_level" = 2;
        "security.csp.enable" = true;
        "security.dialog_enable_delay" = 1000;
        "security.family_safety.mode" = 0;
        "security.insecure_connection_text.enabled" = true;
        "security.mixed_content.block_display_content" = true;
        "security.password_lifetime" = 5;
        "security.pki.crlite_mode" = 2;
        "security.pki.sha1_enforcement_level" = 1;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.ssl.require_safe_negotiation" = true;
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "security.tls.enable_0rtt_data" = false;
        "security.tls.version.enable-deprecated" = false;
        "services.sync.prefs.sync.browser.startup.homepage" = true;
        "services.sync.prefs.sync.browser.startup.page" = true;
        "services.sync.username" = "jay@rovacsek.com";
        "signon.autofillForms" = false;
        "signon.formlessCapture.enabled" = false;
        "signon.rememberSignons" = false;
        "toolkit.coverage.endpoint.base" = "";
        "toolkit.coverage.opt-out" = true;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.winRegisterApplicationRestart" = false;
        "webchannel.allowObject.urlWhitelist" = "";
        "webgl.disabled" = true;
        "widget.non-native-theme.enabled" = true;
      };
    };
  } // packageSettings;
}
