README
======

To setup the Docker image run:

    $ docker-compose build

Then add your [Intercom access token] to the `.env.secrets` file:

    $ vi .env.secrets

It only needs to contain one line. Make it look like this:

    ACCESS_TOKEN=<your-token>

Finally, run the script to download all the data from your account:

    $ docker-compose run --rm intercom ruby dump.rb

You should then find that the script starts retrieving data from the Intercom API, and storing the raw JSON that their API returns in files inside a folder called `./intercom-dump`.

At this point, **protect your customers' data by removing `.env.secrets`**.

I also recommend you **encrypt the `./intercom-dump` folder immediately**. Use a strong encryption tool such as PGP (or GnuPG). Can't be bothered? What happens if you should lose your computer, with all your customers' contact details, geographic locations, etc on it? It doesn't bear thinking about, right?

And please don't run this on any computers whose filesystems aren't encrypted with strong encryption. You can't securely delete a file from an SSD drive, so if you save one of these JSON files containing customer data to such a disk, the only way you'll be able to reliably destroy the data is to destroy the drive.

[Intercom access token]: https://developers.intercom.com/building-apps/docs/authorization
