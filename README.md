# node-knex-meta-schema

[![Code Climate](https://codeclimate.com/github/tomi77/node-knex-meta-schema/badges/gpa.svg)](https://codeclimate.com/github/tomi77/node-knex-meta-schema)
[![dependencies Status](https://david-dm.org/tomi77/node-knex-meta-schema/status.svg)](https://david-dm.org/tomi77/node-knex-meta-schema)
[![devDependencies Status](https://david-dm.org/tomi77/node-knex-meta-schema/dev-status.svg)](https://david-dm.org/tomi77/node-knex-meta-schema?type=dev)

Knex meta schema builder

Build Your database schema in JSON/YAML.

## Installation

~~~bash
npm i knex-meta-schema
~~~

## Quick start

Put Your schema in `.yml` or `.json` file in `schemas` directory

~~~yaml
test_table_name:
  id: increments
  name: string
  unique_name:
    type: string
    unique: true
~~~

Create schema before tests

~~~coffee
knex = require('knex')
  client: 'sqlite3'
  connection:
    filename: ':memory:'
  useNullAsDefault: yes

metaSchema = require('knex-meta-schema') knex, __dirname

schemas = metaSchema.load 'test.yml'
before schema for schema in schemas
~~~

## Supported types

* `increments`
* `string`
* `integer`
* `boolean`
* `dateTime`
* `text`

## Mark column as primary

~~~yaml
test_table_name:
  id:
    type: integer
    primary: true
~~~

## Mark column as unique

~~~yaml
test_table_name:
  name:
    type: string
    unique: true
~~~

## Mark column as foreign key

~~~yaml
ref_table_name:
  id: increments
  name: string

test_table_name:
  ref:
    type: integer
    foreign: ref_table_name.id
~~~
