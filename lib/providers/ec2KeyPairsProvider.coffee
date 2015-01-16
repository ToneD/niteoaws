path = require 'path'
_ = require 'lodash'
Q = require 'q'
aws = require 'aws-sdk'
tag = require path.join(__dirname, '../tag.js')
resource = require path.join(__dirname, '../resource.js')
resourceProvider = require path.join(__dirname, '../resourceProvider.js')

ec2KeyPairsProvider = class extends resourceProvider
	constructor: (region, @AWS) ->
		super region

	getResources: () ->
		ec2 = new @AWS.EC2({region: @region})
		Q.nbind(ec2.describeKeyPairs, ec2)({ })
			.then (data) =>
				_.map data.KeyPairs, (keyPair) ->
					resource.generateResource keyPair, keyPair.KeyName, @region, [ ], this

ec2KeyPairsProvider.factory = (region) ->
	new ec2KeyPairsProvider region, aws, Q

module.exports = ec2KeyPairsProvider