# PageChangeNotifier

## TODOs

  * user session managament (create/login/current_user)
  * simpler UI
  * new websites(kalaydo, immoscout)
  * ~~exception notification~~

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deployment
`git push heroku master`

### Telegram
Set up Telegram bot token with `heroku config:set TELEGRAM_BOT_TOKEN=fookhbar`
Setup the webhook url with https://api.telegram.org/botTELEGRAM_BOT_TOKEN/setWebhook?url=YOUR_WEBHOOK_URL

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
