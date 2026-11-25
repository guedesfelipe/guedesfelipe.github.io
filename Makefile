PORT ?= 8000
SITE_FILES := index.html tokens.css base.css en pt-br

.PHONY: help build check site serve clean

help: ## Show the available targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-7s %s\n", $$1, $$2}'

build: ## Generate /pt-br/ and /en/ from index.html
	@python3 scripts/build_i18n.py

check: ## Fail if /pt-br/ or /en/ are out of date with index.html
	@python3 scripts/build_i18n.py --check

site: build ## Assemble _site/, exactly what GitHub Pages publishes
	@rm -rf _site
	@mkdir -p _site
	@cp -r $(SITE_FILES) _site/
	@touch _site/.nojekyll
	@echo "assembled _site/"

serve: site ## Build and serve _site/ on localhost (PORT=8000 by default)
	@echo ""
	@echo "  http://localhost:$(PORT)/"
	@echo "  http://localhost:$(PORT)/pt-br/"
	@echo "  http://localhost:$(PORT)/en/"
	@echo ""
	@python3 -m http.server $(PORT) --bind 127.0.0.1 --directory _site

clean: ## Remove generated files
	@rm -rf _site en pt-br
