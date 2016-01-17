# Switch

Switch is a remote command-line tool to enable you to easily tranistion between one type of data representation to another.

The most common use case of switch is for switching between a locale representation in JSON/YAML to a CSV (spreadsheet) based one and vice-versa.

## Install

```
gem install switch
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
