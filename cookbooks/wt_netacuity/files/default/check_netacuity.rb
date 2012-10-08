#!/usr/bin/ruby

##Below is Combined NetAcuity.rb and NetAcuityDBDefs.rb

##################################################################
# class NetAcuity: API definitions module to query NetAcuity Server
# File:        NetAcuityDBDefs.rb
# Author:      Digital Envoy
# Program:     NetAcuity API
# Version:     4.96
# Date:        06-FEB-2012
#
# Copyright 2000-2012, Digital Envoy, Inc.  All rights reserved.
#
# This library is provided as an access method to the NetAcuity software
# provided to you under License Agreement from Digital Envoy Inc.
# You may NOT redistribute it and/or modify it in any way without express
# written consent of Digital Envoy, Inc.
#
# Address bug reports and comments to:  tech-support@digitalenvoy.net
#
#
# Description:  Definitions for Access methods to NetAcuity databases.
#
#
##################################################################
module NetAcuityDBDefs

  NA_GEO_DB = 3
  NA_EDGE_DB = 4
  NA_SIC_DB = 5
  NA_DOMAIN_DB = 6
  NA_ZIP_DB = 7
  NA_ISP_DB = 8
  NA_HOME_BIZ_DB = 9
  NA_ASN_DB = 10
  NA_LANGUAGE_DB = 11
  NA_PROXY_DB = 12
  NA_ORGANIZATION_DB = 13
  NA_ISANISP_DB = 14
  NA_COMPANY_DB = 15
  NA_DEMOGRAPHICS_DB = 17
  NA_NAICS_DB = 18
  NA_CBSA_DB = 19

  @GEO = [
    "country",
    "region",
    "city",
    "conn-speed",
    "country-conf",
    "region-conf",
    "city-conf",
    "metro-code",
    "latitude",
    "longitude",
    "country-code",
    "region-code",
    "city-code",
    "continent-code",
    "two-letter-country"
  ]

  @EDGE = [
    "edge-country",
    "edge-region",
    "edge-city",
    "edge-conn-speed",
    "edge-metro-code",
    "edge-latitude",
    "edge-longitude",
    "edge-postal-code",
    "edge-country-code",
    "edge-region-code",
    "edge-city-code",
    "edge-continent-code",
    "edge-two-letter-country",
    "edge-internal-code",
    "edge-area-codes",
    "edge-country-conf",
    "edge-region-conf",
    "edge-city-conf",
    "edge-postal-code-conf",
    "edge-gmt-offset",
    "edge-in-dst"
  ]

  @SIC = ["sic-code"]

  @DOMAIN = ["domain-name"]

  @ZIP = [
    "area-code",
    "zip-code",
    "gmt-offset",
    "in-dst",
    "zip-code-text",
    "zip-country"
  ]

  @ISP = ["isp-name"]

  @HOME_BIZ = ["homebiz-type"]

  @ASN = [
    "asn",
    "asn-name"
  ]

  @LANGUAGE = [
    "primary-lang",
    "secondary-lang"
  ]

  @PROXY = ["proxy-type"]

  @ORGANIZATION = ["dc-company-name"]
  @ISANISP = ["is-an-isp"]
  @COMPANY = ["company-name"]

  @DEMOGRAPHICS = [
    "rank",
    "households",
    "women",
    "w18-34",
    "w35-39",
    "men",
    "m18-34",
    "m35-49",
    "teens",
    "kids"
  ]

  @NAICS = ["naics-code"]
  @CBSA = [
    "cbsa-code",
    "cbsa-title",
    "cbsa-type",
    "csa-code",
    "csa-title",
    "md-code",
    "md-title"
  ]

@GLOBAL = Array.new
@GLOBAL[NA_GEO_DB] = @GEO
@GLOBAL[NA_EDGE_DB] = @EDGE
@GLOBAL[NA_SIC_DB] = @SIC
@GLOBAL[NA_DOMAIN_DB] = @DOMAIN
@GLOBAL[NA_ZIP_DB] = @ZIP
@GLOBAL[NA_ISP_DB] = @ISP
@GLOBAL[NA_HOME_BIZ_DB] = @HOME_BIZ
@GLOBAL[NA_ASN_DB] = @ASN
@GLOBAL[NA_LANGUAGE_DB] = @LANGUAGE
@GLOBAL[NA_PROXY_DB] = @PROXY
@GLOBAL[NA_ORGANIZATION_DB] = @ORGANIZATION
@GLOBAL[NA_ISANISP_DB] = @ISANISP
@GLOBAL[NA_COMPANY_DB] = @COMPANY
@GLOBAL[NA_DEMOGRAPHICS_DB] = @DEMOGRAPHICS
@GLOBAL[NA_NAICS_DB] = @NAICS
@GLOBAL[NA_CBSA_DB] = @CBSA




def self.GLOBAL
  @GLOBAL
end

end

#print "#{NetAcuityDBDefs.GLOBAL[3][2]}"

##################################################################
# class NetAcuity: API class to query NetAcuity Server
# File:        NetAcuity.rb
# Author:      Digital Envoy
# Program:     NetAcuity API
# Version:     4.96
# Date:        06-FEB-2012
#
# Copyright 2000-2012, Digital Envoy, Inc.  All rights reserved.
#
# This library is provided as an access method to the NetAcuity software
# provided to you under License Agreement from Digital Envoy Inc.
# You may NOT redistribute it and/or modify it in any way without express
# written consent of Digital Envoy, Inc.
#
# Address bug reports and comments to:  tech-support@digitalenvoy.net
#
#
# Description:  Access methods to NetAcuity databases.
#
#
##################################################################
#require 'NetAcuityDBDefs'
require 'socket'
require 'timeout'

class NetAcuity

  MAX_RESPONSE_SIZE = 1496
  #################################################################
  # initialize : class constructor
  # server: IP Address of NetAcuity Server to query
  #################################################################
  def initialize(server)
    @server = server
    @port = 5400
    @apiID = 0
    @timeout = 2
  end

  #################################################################
  # setTimeout(): Set the timeout to wait for NetAcuity Server
  #               response
  # timout: number of seconds to wait
  #################################################################
  def setTimeout(timeout)
    @timeout = timeout
  end

  #################################################################
  # setApiID() : set the apiID to pass to the NetAcuity Server
  # id : number to set the id to (default = 0)
  #################################################################
  def setApiID(id)
    @apiID = id
  end

  #################################################################
  # getErrorMessage : if and error occured this call will return
  #                    the reason
  #################################################################
  def getErrorMessage()
    return @ErrorMessage
  end

  #################################################################
  # getResponseSize : get Raw Response size from query
  #
  #################################################################
  def getResponseSize()
    return @responseSize
  end

  #################################################################
  # getRawResponse : get Raw Response for query
  #
  #################################################################
  def getRawResponse()
    return @rawResponse
  end

  #################################################################
  # getNumberOfFields : get number of fields returned from
  #                     Raw Response query
  #################################################################
  def getNumberOfFields()
    return @numOfFields
  end

  #################################################################
  # query(): Method to query the NetActity Server
  # ipAddress: string of ip address to query for
  # dbFeature: number of the database to query
  #################################################################
  def query(ipAddress, dbFeature)
    if (validDB(dbFeature.to_i))
      socket = UDPSocket.new(Socket::AF_INET)
      myquery = "#{dbFeature};#{@apiID};#{ipAddress}"
      socket.send(myquery, 0, @server, @port)
      begin
        timeout(@timeout) do
        response, from = socket.recvfrom(MAX_RESPONSE_SIZE)
      return parseResponse(response, dbFeature.to_i)
      end
    rescue Timeout::Error
      @ErrorMessage = "Timeout querying NetAcuity Server"
        return 0
      end
    end
  end


  ################################################################
  # queryMultipleDBs(): Query NetAcuity with multiple Databases
  #                     with a single call
  # ipAddress: IP Address to query NetAcuity with
  # dbFeatures: array of numbers of databases to query
  ################################################################
  #def queryMultipleDBs(ipAddress, dbFeatures)
   # return queryMultipleDBs(ipAddress, dbFeatures, 0)
  #end

  ################################################################
  # queryMultipleDBs(): Query NetAcuity with multiple Databases
  #                     with a single call
  # ipAddress: IP Address to query NetAcuity with
  # dbFeatures: array of numbers of databases to query
  # transID: id for transaction that will be returned in response
  ################################################################
  def queryMultipleDBs(ipAddress, dbFeatures, transID = 0)
    request = createRequest(ipAddress, dbFeatures, transID)
    socket = UDPSocket.new(Socket::AF_INET)
    @rawResponse = ""
      socket.send(request, 0, @server, @port)
      begin
        timeout(@timeout) do
        isDone = false
        lastPacket = 0
        i =1
        while !isDone do
          response, from = socket.recvfrom(MAX_RESPONSE_SIZE)
          if response.length > 0
            packetNumber = response[0,2].to_i
            totalPacket = response[2,2].to_i
            #getting packets in order
            if ((packetNumber - 1) == lastPacket)
              lastPacket = packetNumber
              if (packetNumber == totalPacket)
                @rawResponse << response[4..-2]
                isDone = true
              else
                @rawResponse << response
              end
            else
              #packet out of order...error
              @ErrorMessage = "Response Packets out of order"
              return 0
            end
            i += 1
          end
        end
        @responseSize = @rawResponse.length
      end
       rescue Timeout::Error
      @ErrorMessage = "Timeout querying NetAcuity Server"
        return 0
    end
      return parseXMLResponse(@rawResponse)
  end

  private


  ################################################################
  # createRequest(): Create xml request for NetAcuity for
  #                  multiple Databases with a single call
  # ipAddress: IP Address to query NetAcuity with
  # dbFeatures: array of numbers of databases to query
  ################################################################
  def createRequest(ipAddress, dbFeatures, transactionID)
    queryString = "<request trans-id=\"#{transactionID}\" " +
                       "ip=\"#{ipAddress}\" api-id=\"#{@apiID}\" >";
    dbFeatures.each do |db|
      if (validDB(db))
         queryString << "<query db=\"#{db}\" />";
      end
    end
    queryString << "</request>";
    return queryString
  end

  ################################################################
  # parseXMLResponse(): parse the xml response for the multiple
  #                     database query
  # response: xml response from NetAcuity Server
  ################################################################
  def parseXMLResponse(response)
    #striping off <response and trailing />
    responses = {}
    if (response.length > 0)

      responseString = response[10..-3]
      tokens = responseString.split(/\" /)
      @numOfFields = tokens.length

      tokens.each do |token|
        equalToken = token.split(/\=/)
        if (equalToken.length == 2)
          field = equalToken[0]
          #remove the '"'(quotes)
          value = equalToken[1].gsub(/"/, '')
          responses[field] = value
        elsif(equalToken.length != 1)
          #ERROR
          @ErrorMessage = "Error with tokens"
        return 0
      end
    end
    end
    return responses
  end

  def validDB(dbFeature)
    return (dbFeature < 500 && dbFeature >= 1) ? true : false;
  end

  ################################################################
  # parseResponse(): parse the response for the single
  #                     database query
  # response: response from NetAcuity Server
  # dbFeature: the database queried
  ################################################################
  def parseResponse(response, dbFeature)
    dataFields = {}

    @responseSize, @numOfFields, @rawResponse = parseResponseMetaData(response)
    fieldValues = @rawResponse.split(/;/)
    index = 0
    fieldValues.each do |fieldValue|
      if (NetAcuityDBDefs.GLOBAL[dbFeature])
        if (NetAcuityDBDefs.GLOBAL[dbFeature][index])
          dataFields[NetAcuityDBDefs.GLOBAL[dbFeature][index]] = fieldValue
        end
      else
        dataFields["field-#{index+1}"] = fieldValue
      end
      index += 1
    end
    return dataFields
  end

  ################################################################
  # parseResponseMetaData(): parse the metadata about the response
  #                          from the NetActuity Server for single
  #                          database query
  # response: response from NetAcuity Server
  ################################################################
  def parseResponseMetaData(response)
    sizeBin = response[0,2]
    size = sizeBin.unpack('n*')[0] -1
    numFieldsBin = response[2,2]
    numFields = numFieldsBin.unpack('n*')[0]
    return [size, numFields, response[4..-3]]
  end
  end

##################################################################
# class NetAcuity: API class to query NetAcuity Server
# File:        NetAcuity.rb
# Author:      Digital Envoy
# Program:     NetAcuity API
# Version:     4.96
# Date:        06-FEB-2012
#
# Copyright 2000-2012, Digital Envoy, Inc.  All rights reserved.
#
# This library is provided as an access method to the NetAcuity software
# provided to you under License Agreement from Digital Envoy Inc.
# You may NOT redistribute it and/or modify it in any way without express
# written consent of Digital Envoy, Inc.
#
# Address bug reports and comments to:  tech-support@digitalenvoy.net
#
#
# Description:  Example using the NetAcuity Ruby API
#
#
##################################################################
if __FILE__ == $0
  #require 'NetAcuity'
  #require 'NetAcuityDBDefs'

  if (ARGV.length > 0)
    test = NetAcuity.new(ARGV[0].to_s)

    #set timeout to 3 seconds
    #default is 2 seconds if not set
    test.setTimeout(20)

    #set apiID..default is 0 if not set
    test.setApiID(4)

    ##################################################################
    # Test single database query
    ##################################################################
    #print "Querying single Database:\n\n"
    if (ARGV.length > 2)
      if (ARGV.length > 3)
        db = ARGV[3]
      else
        db = ARGV[2]
      end
      data = test.query(ARGV[1], db)
      if (0 != data)
        data.keys.each do |field|
        print "#{field} : #{data[field]}\n"
      end
        print "Raw: #{test.getRawResponse()} : Size: #{test.getResponseSize()} : #{test.getRawResponse().length}: Num of Fields: #{test.getNumberOfFields()}\n"
      else
        print "Error: #{test.getErrorMessage}\n"
      end
    else
      #print "Warning: no database was specified so not performing single database query test\n"
    end
    ################################################################
    # Test multiple database query
    ################################################################
    #print "\nQuerying multiple DBs:\n\n"
     data = test.queryMultipleDBs(ARGV[1],
     [
      NetAcuityDBDefs::NA_GEO_DB,
      NetAcuityDBDefs::NA_DOMAIN_DB,
      NetAcuityDBDefs::NA_COMPANY_DB,
      NetAcuityDBDefs::NA_ISP_DB,
      NetAcuityDBDefs::NA_ZIP_DB,
      NetAcuityDBDefs::NA_ASN_DB
      ], 100)
    if (0 != data)

      data.keys.each do |field|
        print "#{field}:#{data[field]} "
      end
      #puts test.getRawResponse()
      exit 0 #Return 0 to Nagios for success
      #print "Raw: #{test.getRawResponse()} : Size: #{test.getResponseSize()} : #{test.getRawResponse().length} : Num of Fields: #{test.getNumberOfFields()}\n"
    else
       print "Error: #{test.getErrorMessage}\n"
       exit 2 #Return 2 to Nagios for cirtical
    end
  else
    print "Usage: <netacuity_server_ip> <query_ip> <db_number>"
  end
end
