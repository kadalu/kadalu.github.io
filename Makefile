build:
	bundle exec nanoc

live:
	bundle exec nanoc
	bundle exec nanoc view -L

setup-dev:
	bundle install
	npm install
	npm run build:css
	bundle exec nanoc

setup-prod:
	bundle install
	npm install
	npm run prod:css
	bundle exec nanoc compile --env prod
