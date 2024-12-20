# MarketPriceWatcher

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)

MarketPriceWatcher is a bot for tracking prices and other meta information on products on popular marketplaces. It allows you to flexibly configure triggers for notifications, and receive notifications in the channel when the monitored parameters change.

## Functionality

1. Displaying a list of tracked items
2. Adding an item for tracking
3. Notifications by parameters
4. Item statistics

## Getting Started

### Requirements

Using docker:
- [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/)

Local install:
- **Ruby version**: Ruby 3.0 or higher is required.

### Installation

Clone the repo

```
https://github.com/Onizukachi/MarketPriceWatcher.git
```

 Move to project folder

```
cd MarketPriceWatcher
```

Create .env file

```
cp .env .env.example
```

[Create](https://core.telegram.org/bots/tutorial) a bot in telegram and get a token 

Copy the token into you `.env` file in the variable `TELEGRAM_TOKEN =` with token provided by BotFather

If you are working without docker, install all gems 


```
bundle install
```

and put the data to connect to your postgres database in `.env`

### Start the bot

Using docker

```
docker-compose up --build
```

Local

```
chmod +x ./bin/bot
bin/bot
```

## Author

👤 **Alexey Glazkov**

- GitHub: [@Onizukachi](https://github.com/Onizukachi)
- Telegram: [@onizukachi](https://t.me/onizukachi)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](https://github.com/Onizukachi/MarketPriceWatcher/issues).

## Show your support

Give a ⭐️ if you like this project!
