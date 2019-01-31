/*global cordova, module*/

module.exports = {
    setDeviceVolume: function (successCallback, errorCallback, volume, stream) {
        cordova.exec(successCallback, errorCallback, "VolumeControl", "setDeviceVolume", [volume, stream]);
    }
    getDeviceVolume: function (successCallback, errorCallback, volume, stream) {
        cordova.exec(successCallback, errorCallback, "VolumeControl", "getDeviceVolume", [volume, stream]);
    }
};