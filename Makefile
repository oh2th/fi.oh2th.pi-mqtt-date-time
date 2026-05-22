PERL ?= perl
CPANM ?= cpanm
PERL_DEPS := Net::MQTT::Simple
APT_PKG ?= libnet-mqtt-simple-perl
DNF_PKG ?= perl-Net-MQTT-Simple
YUM_PKG ?= perl-Net-MQTT-Simple
ZYPPER_PKG ?= perl-Net-MQTT-Simple
PACMAN_PKG ?= perl-net-mqtt-simple
APK_PKG ?= perl-net-mqtt-simple

deps:
	@if $(PERL) -MNet::MQTT::Simple -e 1 >/dev/null 2>&1; then \
		echo "Perl dependencies already installed."; \
	elif command -v apt-get >/dev/null 2>&1; then \
		if command -v sudo >/dev/null 2>&1; then sudo apt-get update && sudo apt-get install -y $(APT_PKG); else apt-get update && apt-get install -y $(APT_PKG); fi; \
	elif command -v dnf >/dev/null 2>&1; then \
		if command -v sudo >/dev/null 2>&1; then sudo dnf install -y $(DNF_PKG); else dnf install -y $(DNF_PKG); fi; \
	elif command -v yum >/dev/null 2>&1; then \
		if command -v sudo >/dev/null 2>&1; then sudo yum install -y $(YUM_PKG); else yum install -y $(YUM_PKG); fi; \
	elif command -v zypper >/dev/null 2>&1; then \
		if command -v sudo >/dev/null 2>&1; then sudo zypper --non-interactive install $(ZYPPER_PKG); else zypper --non-interactive install $(ZYPPER_PKG); fi; \
	elif command -v pacman >/dev/null 2>&1; then \
		if command -v sudo >/dev/null 2>&1; then sudo pacman -S --noconfirm $(PACMAN_PKG); else pacman -S --noconfirm $(PACMAN_PKG); fi; \
	elif command -v apk >/dev/null 2>&1; then \
		if command -v sudo >/dev/null 2>&1; then sudo apk add $(APK_PKG); else apk add $(APK_PKG); fi; \
	else \
		command -v $(CPANM) >/dev/null 2>&1 || { \
			echo "No supported system package manager found. Install cpanminus first, then rerun make deps."; \
			exit 1; \
		}; \
		$(CPANM) --notest $(PERL_DEPS); \
	fi
	@$(PERL) -MNet::MQTT::Simple -MTime::HiRes -e 1

check-deps:
	$(PERL) -MNet::MQTT::Simple -MTime::HiRes -e 1

install: deps
	install -m 755 mqtt-date-time.pl /usr/local/bin/mqtt-date-time.pl
	install -m 644 mqtt-date-time.service /etc/systemd/system/mqtt-date-time.service
	systemctl daemon-reload
	systemctl enable mqtt-date-time.service
	systemctl start mqtt-date-time.service

uninstall:
	systemctl stop mqtt-date-time.service
	systemctl disable mqtt-date-time.service
	rm -f /usr/local/bin/mqtt-date-time.pl
	rm -f /etc/systemd/system/mqtt-date-time.service
	systemctl daemon-reload

.PHONY: deps check-deps install uninstall
