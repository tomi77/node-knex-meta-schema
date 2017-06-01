path = require 'path'
YAML = require 'yamljs'
jsonFile = require 'jsonfile'
map = require 'lodash/map'
isString = require 'lodash/isString'
assignIn = require 'lodash/assignIn'
forEach = require 'lodash/forEach'

module.exports = class MetaSchema
  constructor: (@knex, @currentDir) ->
    @schemas = {}
    return

  builder: (schema, tableName) =>
    @knex.schema.createTableIfNotExists tableName, (table) ->
      for colName, colDefinition of schema
        type = if isString(colDefinition) then colDefinition else colDefinition.type

        col = switch type
          when 'increments' then table.increments()
          when 'string' then table.string colName
          when 'integer' then table.integer colName
          when 'boolean' then table.boolean colName
          when 'dateTime' then table.dateTime colName
          when 'text' then table.text colName
          else throw new Error "Unsupported column type: #{ type }"

        if colDefinition.unique
          col = col.unique()

        if colDefinition.primary
          table.primary colName

        if colDefinition.foreign
          table.foreign colName
          .references colDefinition.foreign

      return

  load: (schemasFileName) ->
    unless path.isAbsolute schemasFileName
      schemasFileName = path.resolve @currentDir, 'schemas', schemasFileName

    ext = path.extname schemasFileName

    schemas = switch ext.toLowerCase()
      when '.json'
        jsonFile.readFileSync schemasFileName
      when '.yml', '.yaml'
        YAML.load schemasFileName
      else
        throw new Error "Unsupported format: #{ ext }"
    @schemas = assignIn @schemas, schemas

  create: () => Promise.all map @schemas, @builder
