site-build:
	bundle exec nanoc

site-build-prod:
	bundle install
	bundle exec nanoc compile --env prod

site-view:
	bundle exec nanoc view -L

gen-css:
	sass --sourcemap=none sass/stylesheet.scss:content/bulma-0.9.4.min.css
