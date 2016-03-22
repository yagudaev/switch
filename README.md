# Switch

Switch helps you add multiple languages to your site by leveraging the power of google spreadsheets. It is a commandline tool providing you with an easy way to automate the process and avoid common mistakes.

The most common use case of switch is for switching between a locale representation in JSON/YAML to a CSV (spreadsheet) based one and vice-versa.

[Watch introduction video](https://www.youtube.com/watch?v=9J9G0qybgSE)
[Read introduction blog post](http://yagudaev.com/posts/introducing-the-switch-gem/)

## Install

```
gem install switch-cli
```

## Usage

```
switch json2csv [input-dir] [output-file]
```

Converts multiple `json` files to be a single `csv` file with columns for each file, with the file name as the column header.

If you do not specify an `input-dir` it will be taken as `./locales` and `output-file` would be the direcotry name + .csv.

```
switch csv2json [input-file] [output-dir]
```

Converts a single `csv` file into multiple `json` files, with a file for each column using the `key` and `order` columns to construct the files.
