# Simple Templating

I need a little bit of templating sometimes, and I think I shouldn't have to choose and install a tool for that.

`m4`, `env`, and `perl` are built into my system. Together they make for lightweight templating with includes and variables.

## Usage

If you need both includes and variables:

```sh
m4 template.m4 | env -iS "$(cat vars.env)" \
  "$(which perl)" -pe 's/\$([A-Za-z_]\w*)/$ENV{$1}/g'
```

If you have `envsubst`, which is part of the common `gettext` brew package, you can use it with no arguments instead of `perl`.

```sh
m4 template.m4 | env -iS "$(cat vars.env)" "$(which envsubst)"
```

If you only need includes, stop early:

```sh
m4 template.m4
```

If you only need variables, start late:

```sh
cat template | env -iS "$(cat vars.env)" \
  "$(which perl)" -pe 's/\$([A-Za-z_]\w*)/$ENV{$1}/g'
```

> I hereby acknowledge these useless uses of cat and elect to optimize for reader understanding.

## How it works

As a macro processor, `m4` will expand any includes in the given template file, recursively. Includes look like:

```m4
include(`other.m4')
```

This use of `perl` (or just `envsubst`) replaces shell variables in its input, which look like:

```sh
$VAR_1
```

Variable values need to be set in `perl`'s environment. To populate that, first make a file, whose lines look like:

```sh
VAR_1="value1"
VAR_2="value2"
```

Then you can pass that file as `env -iS "$(cat vars.env)" …` to run the command that follows, `perl`, with the values available.

- `-S $(cat vars.env)` supplies each variable in the file.
- `-i` ignores all the variables from the environment that called `env`, so only the file's variables are available.
  > This also ignores `PATH`. That's why we use `"$(which perl)"` to locate `perl` up front.

You could also use `env -i VAR_1="value1" VAR_2="value2" …` and not involve a file.

## Q: Why isn't this a gist?

A: I was confounded by the combination of wanting to supply example files, wanting to name the gist like I named this repo, and gists taking the name of their alphabetically first file.
