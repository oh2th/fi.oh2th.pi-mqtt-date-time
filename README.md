# fi.oh2th.fi.mqtt-date-time

This Perl script updates two MQTT topics, "system/date" and "system/time," every minute with the current date and time. The date is formatted with a Finnish weekday in two characters followed by yyyy-MM-dd, and the time is in 24-hour format as HH:mm. The script utilizes the Net::MQTT::Simple module for MQTT communication and Time::HiRes for precise timing.

## Dependencies

- Perl
- Net::MQTT::Simple (CPAN)
- Time::HiRes (core Perl module)

Install Perl dependencies:

```sh
make deps
```

`make deps` prefers your system package manager (apt, dnf, yum, zypper, pacman, or apk) when available, and falls back to `cpanm` only if no supported system package manager is found.

Verify required modules are available:

```sh
make check-deps
```
