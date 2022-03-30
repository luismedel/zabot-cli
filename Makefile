.DEFAULT_GOAL := help
.PHONY: help

localenv=telegram
envpath=/root/.telegram-cli
image=weibeld/ubuntu-telegram-cli
command=bin/telegram-cli
dockercmd=docker run --rm -i -v $(CURDIR)/$(localenv):$(envpath) $(image) $(command)
lockfile=$(CURDIR)/$(localenv)/.lock

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed -n 's/^\(.*\): \(.*\)##\(.*\)/\1\t-> \3/p' \
	| column -c 2

$(lockfile):
	mkdir -p $(CURDIR)/$(localenv)
	$(dockercmd) -qDWC -e "quit"
	touch $(lockfile)

auth: ## Re-autorizes Telegram account
	rm -f $(lockfile)
	make $(lockfile)

mark: $(lockfile) ## Sends the /mark command
	$(dockercmd) -DWC -e "msg ZABot /mark"

shell: ## Starts a Telegram shell
	$(dockercmd) -W

clean: ## Cleanup
	rm -rf $(CURDIR)/$(localenv)

