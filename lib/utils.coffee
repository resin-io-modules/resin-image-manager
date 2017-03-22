###
Copyright 2016 Resin.io

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
###

Promise = require('bluebird')
semver = require('semver')
fs = Promise.promisifyAll(require('fs'))
resin = require('resin-sdk-preconfigured')

###*
# @summary Get file created date
# @function
# @protected
#
# @param {String} file - file path
# @returns {Promise<Date>} date since creation
#
# @example
# utils.getFileCreatedDate('foo/bar').then (createdTime) ->
# 	console.log("The file was created in #{createdTime}")
###
exports.getFileCreatedDate = (file) ->
	return fs.statAsync(file).get('ctime')

###*
# @summary Get the device type manifest
# @function
# @protected
#
# @param {String} deviceType - device type slug or alias
# @returns {Promise<Object>} device type manifest
###
exports.getDeviceType = (deviceType) ->
	resin.models.device.getManifestBySlug(deviceType)

###*
# @summary Get the most recent compatible version
# @function
# @protected
#
# @param {String} deviceType - device type slug or alias
# @param {String} versionOrRange - supports the same version options
# as `resin.models.os.getMaxSatisfyingVersion`.
# See `manager.get` for the detailed explanation.
# @returns {Promise<String>} the most recent compatible version.
###
exports.resolveVersion = (deviceType, versionOrRange) ->
	resin.models.os.getMaxSatisfyingVersion(deviceType, versionOrRange)
	.tap (version) ->
		if not version
			throw new Error('No such version for the device type')

###*
# @summary Check if the string is a valid semver version number
# @function
# @protected
# @description Throws an error if the version is invalid
#
# @param {String} version - version number to validate
# @returns {void} the most recent compatible version.
###
exports.validateVersion = (version) ->
	if not semver.valid(version)
		throw new Error('Invalid version number')
