# Hex for Ian’s iPhone

Our own copy of the iPhone app from [Hex](https://github.com/anomalyco/hex) (MIT licence), built for Ian's TestFlight.

- `ios/`, `app/AppIcon.icon` and `tests/fixtures/…` are copied unchanged from the original's `dev` branch. Don't edit them here: the daily update overwrites them.
- `scripts/prepare.sh` swaps in Ian's Apple team and identifiers at build time.
- **2. Daily update** copies the original each morning and, if the iPhone app changed, builds and sends it to TestFlight.
- **3. Build Hex** also runs on the 1st of each month so the TestFlight copy never expires.
- **1. Set up with Apple**: identifiers, certificates, testers.

Source: https://github.com/anomalyco/hex
Our copy builds automatically; see the Actions tab.
