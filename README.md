[![Build Status](https://travis-ci.org/realmetrics/realmetrics.svg?branch=master)](https://travis-ci.org/realmetrics/realmetrics)
[![Code Climate](https://codeclimate.com/github/realmetrics/realmetrics/badges/gpa.svg)](https://codeclimate.com/github/realmetrics/realmetrics)
[![Test Coverage](https://codeclimate.com/github/realmetrics/realmetrics/badges/coverage.svg)](https://codeclimate.com/github/realmetrics/realmetrics/coverage)

## How to get started

Create a config/application.yml file with the following environment variables:

```
REDIS_URL: 'redis://127.0.0.1:6379/0'
DEFAULT_URL: 'http://app.lvh.me:3000'
SMTP_DOMAIN: 'gmail.com'
SMTP_PORT: '587'
SMTP_ADDRESS: 'smtp.gmail.com'
SMTP_USERNAME: '********'
SMTP_PASSWORD: '********'
STRIPE_APP_ID: '********'
STRIPE_PUBLISHABLE_KEY: '********'
STRIPE_SECRET_KEY: '********'
ADMIN_USERNAME: 'admin'
ADMIN_PASSWORD: 'admin'
```
