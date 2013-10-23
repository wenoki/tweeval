tweeval
===========

evals ruby codes from your Twitter client!

run on local
-----------

    git clone https://github.com/wenoki/tweeval.git
    cd tweeval
    bundle install --path=./vendor/bundle
    CLIENT_CONSUMER_KEY=<your consumer key> CLIENT_CONSUMER_SECRET=<your consumer secret> CLIENT_ACCESS_TOKEN=<your access token> CLIENT_ACCESS_TOKEN_SECRET=<your access token secret> CLIENT_USER_ID=<your twitter user id> bundle exec ruby app.ruby

deploy to heroku
-----------

    $ heroku apps:create
    $ heroku config:set CLIENT_CONSUMER_KEY=<your consumer key> CLIENT_CONSUMER_SECRET=<your consumer secret> CLIENT_ACCESS_TOKEN=<your access token> CLIENT_ACCESS_TOKEN_SECRET=<your access token secret> CLIENT_USER_ID=<your twitter user id>
    $ git push heroku master
    $ heroku ps:scale bot=1

usage
-----------

run tweeval, then update status from your twitter...

    -e 1 + 1

a status will be posted by tweeval immediately.

    => 2

if you want to "raw" output...

    -e --raw "Go".tap {|item| rand(20).times {item.concat " go"}}

    Go go go go go go go go go go go go

@ reply/mention is also accepted...

    @someone -e ["Sweet Dreams!", "Goodnight!"].sample