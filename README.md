# Simple Templating

m4 and envsubst are probably built in to your system. Together they make for lightweight templating with includes and variables.

## Usage

If you only need includes:

```
m4 template.m4
```

If you need variables:

```
cat template | ./with-env vars.env envsubst
```

If you need both:

```
m4 template.m4 | ./with-env vars.env envsubst
```

## How it works

`m4` recursively expands any includes in the given template file. Includes look like:

```
include(\`other.m4')
```

`envsubst` replaces shell variables, which look like:

```
$VARIABLE
```

The values need to be set in the environment. To populate that, first make a file, whose lines look like:

```
VARIABLE="value"
```

Then you can pass that file to this `with-env` script to run `envsubst` with the variables loaded in the environment.
