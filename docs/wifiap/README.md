These notes are havily work in progress.

# 5Ghz configuration

hostapd configuration:

```
interface=wlp1s0
driver=nl80211

ssid=5gtest
hw_mode=a
channel=36
country_code=IE

# 802.11ac support
ieee80211ac=1
channel=36

auth_algs=1
# WPA2 only
wpa=2
auth_algs=1
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_psk=6b6bb89b2835c6659f35dfbf15f9ab207c85bed8fedeeedcd18ed7f2774b8494
```

Note: when configuring `wmm_enabled=1`, there is an issue with at least some Android 
clients not being able to connect to the 802.11ac network, failing during authentication. 
One can see the handshake starting:
```
WPA: 42:34:50:39:5d:0d WPA_PTK entering state PTKSTART
wlp1s0: STA 42:34:50:39:5d:0d WPA: sending 1/4 msg of 4-Way Handshake
```

But it then seems to time out and begin another attempt, until eventually it gives up.
```
wlp1s0: STA 42:34:50:39:5d:0d IEEE 802.11: did not acknowledge association response
nl80211: sta_remove -> DEL_STATION wlp1s0 42:34:50:39:5d:0d --> 0 (Success)
wlp1s0: STA 42:34:50:39:5d:0d WPA: EAPOL-Key timeout
WPA: 42:34:50:39:5d:0d WPA_PTK entering state PTKSTART
wlp1s0: STA 42:34:50:39:5d:0d WPA: sending 1/4 msg of 4-Way Handshake
```

This does not happen when setting the country code to US. Until I root cause this, I am disabling
WMM (if setting country code to US is not an option).

# Generate PSK passphrase

Use `wpa_passphrase`:
```
# wpa_passphrase 5gtest 11111111
```

# DHCP daemon configuration
The interface on which the daemon will listen on needs to be assigned an address from the managed subnet. This can
be done with a `systemd-networkd` [config file](https://github.com/marcoguerri/meta-thirtyd/tree/master/recipes-core/systemd).
Note that `ConfigureWithoutCarrier=true` must be present.

# Unreliable boot from SD
Booting from SD is unreliable. When running fw v4.11.0.6, grub intermittently fails at stage2 with 

```
error: failure reading sector 0x1340 from `hd0'.
```

After upgrading to v4.13.0.4, the situation is unchanged. The failures seems to be triggered by changes of the filesystem and
the might recover after one (or multiple) power cycles.

Enabling SD 3.0 mode in coreboot seems to be changing the failure pattern: now grub stage 1 fails intermittently (which can 
be recovered only with a power cycle), and stage 2 seems instead to be reliably succeeding. SD 3.0 however requires `rootdelay`
in kernel command line.
