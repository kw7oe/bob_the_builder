# Bob the Builder

This is a simple Rakefile to help with generating `Markdown` files
according to templates given and compile into HTML with a simple
index HTML file.

### Installation

1. Install `ruby`. Refer to the
[official installation guide](https://www.ruby-lang.org/en/documentation/installation/)

2. Install `rake`
```
gem install rake
```

3. Install `pandoc`. Refer to the [official installation guide](https://pandoc.org/installing.html)

4. Clone this repository to your desired directory _(where you want to use this)_
```
git clone https://github.com/kw7oe/bob_the_builder.git <directory_name>
```

### Usage

#### 1. Create a Markdown file as template first and place it under `/templates`

For instance, I have a simple Markdown files `/templates/journal_entry.md` as follow:

```
### What did you learn today?
```

You can have more than one templates.

#### 2. To generate a Markdown files according to the template:
```
rake generate[<template_name>]
```

Using the above example, it will be `rake generate['journal_entry']`

**Note:** Currently, `rake generate` will create a file and open
it with `vim`

#### 3. To view your files in html:
```
rake show
```

### How do you generate the HTML files?

`pandoc` is used to generate the HTML files from the Markdown files. Basic styling is added to the HTML files. The CSS file used is taken from https://gist.github.com/killercup/5917178 with slight modification.


### Where is the files located?

All of the generated Markdown files are located under `/sources/<template_name>/`

All of the output HTML files are located under `/outputs/<template
_name>/`


### Limitation

- Currently, it is written only fo `macOS`. Command such as `open` and
file seperator `/` is assumed to be available. For linux user,
who have `xdg-open`, you can directly modify `line 14` of the `Rakefile`, changing `open` to `xdg-open` after the `sh` method.
- The generated `index.html` is still very limited. It doesn't
splits the file entries according to templates yet.
- It's not a command line tool...


### Bugs/Features

The project is still under development.

If there are any bugs/features request, feel free to create a new issues.
