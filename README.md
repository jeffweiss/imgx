# Imgx

Imgx is a personal experiment to what it would take to display images inline in
[iTerm 2.9+](https://www.iterm2.com/images.html) using Elixir. As a side result
(I have yet to judge if great or terrible), you may now embed images (and
animated gifs) into git commits.

```shell
$ ./imgx <giphy_search_terms> | git commit --allow-empty -F -
```

## Build

You'll require Erlang and Elixir.

```shell
$ mix deps.get
$ mix compile
$ mix escript.build
$ ./imgx funny cat
```

