require 'data_objects'
require 'dm-core'

require 'dm-soap-adapter/resource'
require 'dm-soap-adapter/connection'
require 'dm-soap-adapter/errors'
require 'dm-soap-adapter/version'
require 'dm-soap-adapter/xml_delegate'
require 'dm-soap-adapter/adapter'

require 'nokogiri'

::DataMapper::Adapters::SoapAdapter = DataMapper::Adapters::Soap::Adapter
