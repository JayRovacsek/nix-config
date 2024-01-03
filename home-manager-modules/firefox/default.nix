{ lib, osConfig, pkgs, ... }:
let
  packageSettings =
    lib.optionalAttrs pkgs.stdenv.isDarwin { package = pkgs.firefox-bin; };

  addons = with pkgs.nur.repos.rycee.firefox-addons; [
    clearurls
    darkreader
    decentraleyes
    i-dont-care-about-cookies
    keepassxc-browser
    multi-account-containers
    noscript
    privacy-badger
    temporary-containers
    ublock-origin
    user-agent-string-switcher
  ];
  # TODO: see if aarch can be supported upstream for this language set
  languagePacks =
    if (builtins.hasAttr "firefox-langpack-en-GB" pkgs.nur.repos.sigprof) then
      with pkgs.nur.repos.sigprof; [ firefox-langpack-en-GB ]
    else
      [ ];
  dictionaries = with osConfig.flake.packages.${pkgs.system};
    [ better-english ];
  extensions = addons ++ languagePacks ++ dictionaries;

  localhost = "http://127.0.0.1/";
in {
  programs.firefox = {
    enable = true;

    profiles.jay = {
      id = 0;
      inherit extensions;

      search = {
        force = true;
        default = "DuckDuckGo";
        order = [ "DuckDuckGo" ];
        engines = {
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
          "Google".metaData.hidden = true;
          "Wikipedia (en)".hidden = true;
        };
      };
      bookmarks = {
        "Duck Duck Go" = {
          keyword = "d";
          url = "https://duckduckgo.com/?q=%s";
        };
        "Brave Search" = {
          keyword = "g";
          url = "https://search.brave.com/search?q=%s";
        };
        # Get wrecked, force myself to not use the googs
        "Google Search" = {
          keyword = "google";
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
        "Noogle" = {
          keyword = "noo";
          url = "https://noogle.dev/?term=%22%s%22";
        };
        "Github Code Search" = {
          keyword = "cs";
          url = "https://cs.github.com/?scopeName=All+repos&scope=&q=%s";
        };
        "Github Nix Code Search" = {
          keyword = "ncs";
          url =
            "https://cs.github.com/?scopeName=All+repos&scope=&q=%s+language%3Anix";
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
        "Nix Home Manager Options Search" = {
          keyword = "hm";
          url = "https://mipmip.github.io/home-manager-option-search/?query=";
        };
        "nib Jira Search" = {
          keyword = "j";
          url =
            "https://nibgroup.atlassian.net/issues/?jql=text~%22%s%22%20or%20description%20~%20%22%s%22%20or%20summary%20~%20%22%s%22";
        };
        "nib Confluence Search" = {
          keyword = "c";
          url = "https://nibgroup.atlassian.net/wiki/search/?text=%s";

        };
        "nib Github Search" = {
          keyword = "ngh";
          url = "https://github.com/nib-group?q=%s&type=&language=";
        };
        "nib Monday Search" = {
          keyword = "m";
          url =
            "https://nib-group.monday.com/boards/1933538575/views/65368537?term=%s";
        };
        "Terraform Search" = {
          keyword = "t";
          url = "https://registry.terraform.io/search/providers?q=%s";
        };
      };

      settings = {
        "accessibility.force_disabled" = 1;

        "app.faqURL" = localhost;
        "app.feedback.baseURL" = localhost;
        "app.normandy.api_url" = "";
        "app.normandy.enabled" = false;
        "app.privacyURL" = localhost;
        "app.releaseNotesURL" = localhost;
        "app.shield.optoutstudies.enabled" = false;
        "app.support.baseURL" = localhost;
        "app.support.inputURL" = localhost;
        "app.update.auto" = false;
        "app.update.background.scheduling.enabled" = false;
        "app.update.url" = localhost;
        "app.vendorURL" = localhost;

        "beacon.enabled" = false;

        "breakpad.reportURL" = "";

        "browser.aboutConfig.showWarning" = false;
        "browser.aboutHomeSnippets.updateUrl" = "data:text/html";
        "browser.apps.URL" = "";
        "browser.bookmarks.max_backups" = 2;
        "browser.cache.disk.capacity" = 1048576;
        "browser.cache.disk.enable" = false;
        "browser.cache.memory.capacity" = -1;
        "browser.cache.memory.enable" = true;
        "browser.cache.offline.enable" = false;
        "browser.casting.enabled" = false;
        "browser.contentblocking.category" = "strict";
        "browser.contentblocking.report.hide_vpn_banner" = true;
        "browser.contentblocking.report.mobile-android.url" = "";
        "browser.contentblocking.report.mobile-ios.url" = "";
        "browser.contentblocking.report.monitor.home_page_url" = localhost;
        "browser.contentblocking.report.show_mobile_app" = false;
        "browser.contentblocking.report.vpn-android.url" = "";
        "browser.contentblocking.report.vpn-ios.url" = "";
        "browser.contentblocking.report.vpn-promo.url" = "";
        "browser.contentblocking.report.vpn.enabled" = false;
        "browser.contentblocking.report.vpn.url" = "";
        "browser.contentHandlers.types.1.uri" = "";
        "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.crashReports.unsubmittedCheck.enabled" = false;
        "browser.customizemode.tip0.learnMoreUrl" = localhost;
        "browser.disableResetPrompt" = true;
        "browser.discovery.containers.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.discovery.sites" = localhost;
        "browser.display.use_system_colors" = true;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.download.useDownloadDir" = false;
        "browser.EULA.override" = true;
        "browser.fixup.alternate.enabled" = false;
        "browser.formfill.enable" = false;
        "browser.geolocation.warning.infoURL" = "";
        "browser.helperApps.deleteTempFileOnExit" = true;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
          false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
          false;
        "browser.newtabpage.activity-stream.asrouter.useruser_prefs.cfr" =
          false;
        "browser.newtabpage.activity-stream.disableSnippets" = true;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showTopSites" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.activity-stream.tippyTop.service.endpoint" = "";
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.onboarding.enabled" = false;
        "browser.onboarding.newtour" =
          "performance,private,addons,customize,default";
        "browser.onboarding.updatetour" =
          "performance,library,singlesearch,customize";
        "browser.pagethumbnails.capturing_disabled" = true;
        "browser.ping-centre.telemetry" = false;
        "browser.pocket.enabled" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.privatebrowsing.forceMediaMemoryCache" = true;
        "browser.privatebrowsing.promoEnabled" = false;
        "browser.region.network.scan" = false;
        "browser.region.network.url" = "";
        "browser.region.update.enabled" = false;
        "browser.safebrowsing.allowOverride" = true;
        "browser.safebrowsing.appRepURL" = "";
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.provider.google.gethashURL" = "";
        "browser.safebrowsing.provider.google.updateURL" = "";
        "browser.safebrowsing.provider.google4.gethashURL" = "";
        "browser.safebrowsing.provider.google4.updateURL" = "";
        "browser.safebrowsing.provider.mozilla.gethashURL" = "";
        "browser.safebrowsing.provider.mozilla.updateURL" = "";
        "browser.search.context.loadInBackground" = false;
        "browser.search.separatePrivateDefault.urlbarResult.enabled" = true;
        "browser.search.suggest.enabled" = false;
        "browser.search.update" = false;
        "browser.selfsupport.url" = "";
        "browser.send_pings" = false;
        "browser.sessionstore.privacy_level" = 2;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.slowStartup.notificationDisabled" = true;
        "browser.snippets.enabled" = false;
        "browser.snippets.geoUrl" = localhost;
        "browser.snippets.statsUrl" = localhost;
        "browser.snippets.syncPromo.enabled" = false;
        "browser.snippets.updateUrl" = localhost;
        "browser.ssl_override_behavior" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.startup.homepage" = "about:blank";
        "browser.startup.page" = 0;
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.translation.engine" = "";
        "browser.uitour.enabled" = false;
        "browser.uitour.themeOrigin" = localhost;
        "browser.uitour.url" = localhost;
        "browser.urlbar.groupLabels.enabled" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.trimURLs" = false;
        "browser.urlbar.update2.engineAliasRefresh" = true;
        "browser.user_preferences.inContent" = false;
        "browser.user_preferences.moreFromMozilla" = false;
        "browser.webapps.checkForUpdates" = 0;
        "browser.webapps.updateCheckUrl" = localhost;
        "browser.xr.warning.infoURL" = "";
        "browser.xul.error_pages.expert_bad_cert" = true;

        "datareporting.healthreport.about.reportUrl" = localhost;
        "datareporting.healthreport.documentServerURI" = localhost;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.policy.dataSubmissionPolicyVersion" = 2;
        "datareporting.policy.firstRunTime" = 0;

        "device.sensors.ambientLight.enabled" = false;
        "device.sensors.enabled" = false;
        "device.sensors.motion.enabled" = false;
        "device.sensors.orientation.enabled" = false;
        "device.sensors.proximity.enabled" = false;

        "dom.battery.enabled" = false;
        "dom.ipc.plugins.flash.subprocess.crashreporter.enabled" = false;
        "dom.push.enabled" = false;
        "dom.security.https_only_mode_ever_enabled" = true;
        "dom.security.https_only_mode" = true;
        "dom.webaudio.enabled" = false;
        "dom.webnotifications.enabled" = false;
        "dom.webnotifications.serviceworker.enabled" = false;

        "experiments.activeExperiment" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "experiments.supported" = false;

        "extensions.allowPrivateBrowsingByDefault" = true;
        "extensions.blocklist.enabled" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
        "extensions.getAddons.cache.enabled" = false;
        "extensions.getAddons.langpacks.url" = localhost;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.shield-recipe-client.api_url" = "";
        "extensions.shield-recipe-client.enabled" = false;
        "extensions.update.enabled" = false;
        "extensions.webservice.discoverURL" = "";

        "font.default.x-western" = "sans-serif";

        "gecko.handlerService.schemes.irc.0.name" = "";
        "gecko.handlerService.schemes.irc.0.uriTemplate" = "";
        "gecko.handlerService.schemes.webcal.0.name" = "";
        "gecko.handlerService.schemes.webcal.0.uriTemplate" = "";

        "gfx.xrender.enabled" = true;
        "gfx.webrender.force-disabled" = true;

        "healthreport.uploadEnabled" = false;

        "identity.mobilepromo.android" = localhost;
        "identity.sync.tokenserver.uri" =
          "https://firefox-syncserver.rovacsek.com/1.0/sync/1.5";

        "intl.locale.matchOS" = true;

        "keyword.enabled" = false;

        "lightweightThemes.getMoreURL" = localhost;

        "loop.enabled" = false;

        "media.autoplay.default" = 1;
        "media.autoplay.enabled" = false;
        "media.eme.enabled" = false;
        "media.gmp-provider.enabled" = false;
        "media.gmp-widevinecdm.enabled" = false;
        "media.memory_cache_max_size" = 65536;
        "media.navigator.enabled" = false;
        "media.peerconnection.enabled" = false;
        "media.video_stats.enabled" = false;

        "network.allow-experiments" = false;
        "network.captive-portal-service.enabled" = false;
        "network.cookie.cookieBehavior" = 1;
        "network.dns.disablePrefetch" = true;
        "network.dns.disablePrefetchFromHTTPS" = true;
        "network.http.pipelining.maxrequests" = 10;
        "network.http.pipelining" = true;
        "network.http.proxy.pipelining" = true;
        "network.http.referer.spoofSource" = true;
        "network.http.sendRefererHeader" = 2;
        "network.http.speculative-parallel-limit" = 0;
        "network.IDN_show_punycode" = true;
        "network.predictor.enable-prefetch" = false;
        "network.predictor.enabled" = false;
        "network.prefetch-next" = false;
        "network.protocol-handler.external.ms-windows-store" = false;
        "network.proxy.socks_remote_dns" = true;
        "network.trr.mode" = 3;
        "network.trr.uri" = "https://doh.libredns.gr/dns-query";

        "nglayout.initialpaint.delay" = 0;

        "pdfjs.disabled" = true;
        "pdfjs.enableScripting" = false;

        "permissions.delegation.enabled" = false;
        "permissions.manager.defaultsUrl" = "";

        "pfs.datasource.url" = localhost;
        "pfs.filehint.url" = localhost;

        "plugins.hide_infobar_for_missing_plugin" = true;
        "plugins.hide_infobar_for_outdated_plugin" = true;
        "plugins.notifyMissingFlash" = false;
        "plugins.update.url" = localhost;

        "privacy.announcements.enabled" = false;
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
        "privacy.donottrackheader.value" = 1;
        "privacy.firstparty.isolate" = true;
        "privacy.query_stripping" = true;
        "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" =
          false;
        "privacy.resistFingerprinting.block_mozAddonManager" = true;
        "privacy.resistFingerprinting.exemptedDomains" = "*.rovacsek.com";
        "privacy.resistFingerprinting.letterboxing" = true;
        "privacy.resistFingerprinting.randomDataOnCanvasExtract" = false;
        "privacy.resistFingerprinting.target_video_res" = 1080;
        "privacy.resistFingerprinting" = true;
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.sanitize.timeSpan" = 0;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.usercontext.about_newtab_segregation.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
        "privacy.window.name.update.enabled" = true;

        "security.ask_for_password" = 2;
        "security.cert_pinning.enforcement_level" = 2;
        "security.csp.enable" = true;
        "security.dialog_enable_delay" = 1000;
        "security.family_safety.mode" = 0;
        "security.insecure_connection_text.enabled" = true;
        "security.mixed_content.block_display_content" = true;
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = false;
        "security.password_lifetime" = 5;
        "security.pki.crlite_mode" = 2;
        "security.pki.sha1_enforcement_level" = 1;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.ssl.disable_session_identifiers" = true;
        "security.ssl.errorReporting.enabled" = false;
        "security.ssl.require_safe_negotiation" = true;
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "security.ssl3.dhe_dss_aes_128_sha" = false;
        "security.ssl3.dhe_rsa_aes_128_sha" = false;
        "security.ssl3.dhe_rsa_aes_256_sha" = false;
        "security.ssl3.dhe_rsa_des_ede3_sha" = false;
        "security.ssl3.rsa_des_ede3_sha" = false;
        "security.ssl3.rsa_seed_sha" = true;
        "security.tls.enable_0rtt_data" = false;
        "security.tls.insecure_fallback_hosts.use_static_list" = false;
        "security.tls.insecure_fallback_hosts" = "localhost";
        "security.tls.unrestricted_rc4_fallback" = false;
        "security.tls.version.enable-deprecated" = false;
        "security.tls.version.min" = 1;
        "security.webauthn.ctap2" = false;

        "services.settings.server" = "";
        "services.sync.prefs.sync-seen.browser.search.update" = true;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.redTopSite" =
          false;
        "services.sync.prefs.sync.browser.startup.homepage" = true;
        "services.sync.prefs.sync.browser.startup.page" = true;
        "services.sync.privacyURL" = localhost;

        "signon.autofillForms" = false;
        "signon.formlessCapture.enabled" = false;
        "signon.rememberSignons" = false;

        "social.directories" = "";
        "social.enabled" = false;
        "social.remote-install.enabled" = false;
        "social.toast-notifications.enabled" = false;

        "spellchecker.dictionary" = "en-GB";

        "toolkit.coverage.endpoint.base" = "";
        "toolkit.coverage.opt-out" = true;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.cachedClientID" = "";
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.winRegisterApplicationRestart" = false;

        "webchannel.allowObject.urlWhitelist" = "";

        "webgl.renderer-string-override" = "";
        "webgl.vendor-string-override" = "";

        "widget.non-native-theme.enabled" = true;
      };
    };
  } // packageSettings;
}
