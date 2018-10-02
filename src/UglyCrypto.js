import { NativeModules } from 'react-native';

const { UglyCrypto } = NativeModules;

const symmetricKey = {
  primaryKeyId: 1458084022,
  key: [{
      keyData: {
          typeUrl: "type.googleapis.com/google.crypto.tink.AesGcmKey",
          keyMaterialType: "SYMMETRIC",
          value: "GhC64zqUIAN9rEvRVUCCD5MV"
      },
      outputPrefixType: "TINK",
      keyId: 1458084022,
      status: "ENABLED"
  }]
}

const assymetricKey = {
  primaryKeyId: 1259605205,
  key: [{
      keyData: {
          typeUrl: "type.googleapis.com/google.crypto.tink.EciesAeadHkdfPublicKey",
          keyMaterialType: "ASYMMETRIC_PUBLIC",
          value: "EkQKBAgCEAMSOhI4CjB0eXBlLmdvb2dsZWFwaXMuY29tL2dvb2dsZS5jcnlwdG8udGluay5BZXNHY21LZXkSAhAQGAEYARohANG4YJjQpscTLPod6I4vA0WZkD6fWyqVpQWCaLR91GSwIiEAg2k4FbwKcdspyLea4P1LAImxtv8n2eCaAsJ6cTFRSK8="
      },
      outputPrefixType: "TINK",
      keyId: 1259605205,
      status: "ENABLED"
  }]
}

const encryptSymmetric = (data, contextInfo) =>
    UglyCrypto.encryptSymmetric(data, contextInfo, JSON.stringify(symmetricKey));

const encryptAsymmetric = (data, contextInfo) =>
    UglyCrypto.encryptAsymmetric(data, contextInfo, JSON.stringify(assymetricKey));

export { encryptSymmetric, encryptAsymmetric }
