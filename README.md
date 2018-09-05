# Ruboty::ReviewerAssign

ruboty's plugin.
Assign a reviewer from Slack to PithRequest of Github.
Can be tagged to reviewers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-reviewer_assign'
```

## ENV
```
GITHUB_REPOSITORY="xxxx/xxxx" # ex. motsat/hoge_review_repo
OCTOKIT_ACCESS_TOKEN="xxxxxx"
SLACK_TOKEN="xxx"
REDIS_URL="redis://xxx.xxx.x.x:6379"
```

## USAGE
```
@bot add @slack_account github_account
@bot del @slack_account github_account
@bot tagging @slack_account tag1 tag2
@bot assign tag1 https://github.com/motsat/hoge_repo/pulls/1111
```

## How Get Token(bot)
https://slack.com/apps/A0F7YS25R-bots
