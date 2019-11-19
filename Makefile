.PHONY help deps

help:
	@echo "deps - Install dependencies"

deps:
	bundle install --path vendor/bundle
