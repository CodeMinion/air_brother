# air_brother

A Flutter SDK for scanning using the Brother Scanners.

# Android Support
- Supported

# iOS Support
- Supported.

Note: Make sure to add the following to your Info.plist for iOS.

```
	<key>NSBonjourServices</key>
	<array>
		<string>_ipp._tcp</string>
		<string>_scanner._tcp</string>
		<string>_pdl-datastream._tcp</string>
	</array>
	<key>NSLocalNetworkUsageDescription</key>
	<string>I would like to find scanners.</string>
```