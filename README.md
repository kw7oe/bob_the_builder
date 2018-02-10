# rnote

This is a simple Rakefile to help with generating `Markdown` files
according to templates given and compile into HTML with a simple
index.

### Installation

1. Install `ruby`. Refer to the
[official installation guide](https://www.ruby-lang.org/en/documentation/installation/)
2. Install `rake`
```
gem install rake
```

### Usage

1. Create a Markdown file as template first and place it under `/templates`

For instance, I have a simple Markdown files `/templates/journal_entry
.md` as follow:

```
### What did you learn today?
```

2. To generate a Markdown files according to the template:
```
rake generate[<template_name>]
```

Using the above example, it will be `rake generate['journal_entry']`

**Note:** Currently, `rake generate` will create a file and open
it with `vim`

3. To view your files in html, use `rake show`.
4. `rake -T` to view more available commands.

### Where is the files located?

All of the generated Markdown files are located under `/sources/<
template_name>/`

All of the output HTML files are located under `/outputs/<template
_nane>/`


### Limitation

Currently, it is written only fo `macOS`. Command such as `open` and
file seperator '/' is assumed to be available.

### Bugs/Features

The project is still under development.

If there are any bugs/features request, feel free to create a new issues.
