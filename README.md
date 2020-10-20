# Open Chat Backend Kata

Develop a rest backend for the Open Chat project following api specification in material/APIs.yaml.

## About this Kata

This Kata is used by Robert C. Martin and Sandro Mancuso in "London vs. Chicago" cleancoders serie:

* https://cleancoders.com/videos?series=comparativeDesign
* https://github.com/sandromancuso/cleancoders_openchat/tree/starting-point
* https://github.com/sandromancuso/cleancoders_openchat_webclient
* https://github.com/danielemegna/cleancoders_openchat/tree/openchat-hexagonal

## Application start

To start your server:

  * Install dependencies with `mix deps.get`
  * Start application with `mix run --no-halt`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Docker dev container

Start it with ..
```
$ docker run --rm -itp 4000:4000 -v $PWD:/app -w /app elixir:alpine sh
```

.. into the container get deps
```
$ mix deps.get
```

.. and run test with
```
$ mix test
```

Start Cowboy server via exposed 4000 port with
```
$ mix run --no-halt
```

### Dev resources

* https://github.com/commanded/commanded/
* https://github.com/commanded/commanded/blob/master/guides/Usage.md
* Elixir 1.11 upgrade: https://github.com/bitwalker/alpine-elixir/blob/master/Dockerfile
