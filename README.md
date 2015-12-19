# sitewatcher
ruby script to watch sites for changes and alert you via slack; meant to be run with unix crontabs

## what
get a message in a slack channel alerting you of updates to a site

## how
clone this repo and add a `secrets.yml` file to that dir containting something like
```
target: http://jnmandal.github.io
slack_webhook: https://hooks.slack.com/services/foo/barbaz
```
where:
* the `target` is the site you want to watch
* the `slack_webhook` is the url to the [slack incoming webhook](https://api.slack.com/incoming-webhooks) that you set up
```
crontab -e
```
input something like:
```
*/1 * * * *  /bin/bash -lc 'ruby /root/to/this/script.rb'
```
where: 
* the `1` is the interval in minutes (more info here: http://www.nncron.ru/help/EN/working/cron-format.htm)
* the `bin/bash -lc` is a command to make sure ruby uses the settings in your .bash_profile
* the `root/to/this/script.rb` is the real path to your script

???

profit.
