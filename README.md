# slackmine

A simple script that uses the Redmine Atom feeds (e.g. activity) to read updates and post them to a Slack channel of your choice via a webhook.

I wrote this for when you are a Redmine user and don't have (access to) the Redmine API key but still want to integrate the updates into your team's Slack.

You can just run it or have cron run it periodically. I let cron run this script every minute. Updates are near realtime.

![It looks a little bit like this](https://www.dropbox.com/s/bjbq0duaugll3sq/Slackmine.png?dl=1)

Editing the colour scheme for the messages or the bot :emoji: can be done in the script.
